//
//  DownloadOperationQueue.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 25/7/18.
//  Copyright © 2018 TMDb. All rights reserved.
//

import Foundation
import Hydra
import HydraKit

// This is all balls up crazy fun to try and overcome the rate limiting
// restricitions of the API
// Basically we start with a limited concurrent queue, allowing a max of 5 operations
// Add ontop of that a slight delay at the end of each operation and we get a balancing point
//
// The download query takes a series of URLs an downloads their content and collects it together
// and then returns all of them when they are finished via closure

class DownloadQueue {
	
	static let shared: DownloadQueue = DownloadQueue()
	
	private var queue: OperationQueue = {
		let oq = OperationQueue()
		oq.name = "TMDb download queue"
		oq.maxConcurrentOperationCount = 5
		return oq
	}()
	
	fileprivate init() {
	}
	
	var taskCount = 0
	
	func download(from: [URL], then: @escaping ([Data]) -> Void, fail: @escaping (Error) -> Void) {
		let collector = Collector(then: then, fail: fail)
		for url in from {
			let task = DownloadTask(url: url, collector: collector)
			collector.tasks.append(task)
			collector.addDependency(task)
		}
		
		for task in collector.tasks {
			queue.addOperation(task)
		}
		queue.addOperation(collector)
	}

}

class Collector: Operation {
	
	var responses: [Data] = []
	var tasks: [DownloadTask] = []
	
	let completed: ([Data]) -> Void
	let failed: (Error) -> Void
	
	init(then: @escaping ([Data]) -> Void, fail: @escaping (Error) -> Void) {
		self.completed = then
		self.failed = fail
	}
	
	func add(_ data: Data) {
		responses.append(data)
	}
	
	func fail(error: Error) {
		cancel()
		for task in tasks {
			task.cancel()
		}
		failed(error)
	}
	
	override func main() {
		guard !isCancelled else {
			// Should have failed by now :/
			return
		}
		completed(responses)
	}
}

enum DownloadError: String, Error, CustomStringConvertible {
	case noData = "No Data"

	var description: String {
		return self.rawValue
	}
}

class DownloadTask: Operation {
	
	private let url: URL
	private let collector: Collector
	
	init(url: URL, collector: Collector) {
		self.collector = collector
		self.url = url
		super.init()
	}
	
	override func main() {
		guard !isCancelled else {
			return
		}
		let session = URLSession(configuration: .default)
		let sempahore = DispatchSemaphore(value: 0)
		let task = session.dataTask(with: url) { data, response, error in
			defer {
				sempahore.signal()
			}
			guard !self.isCancelled else {
				return
			}
			if let error = error {
				self.collector.fail(error: error)
				return
			}
			guard let data = data else {
				self.collector.fail(error: DownloadError.noData)
				return
			}
			self.collector.add(data)
		}
		task.resume()
		sempahore.wait()
		Thread.sleep(forTimeInterval: 0.1)
	}
}
