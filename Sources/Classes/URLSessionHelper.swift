//
//  URLSessionHelper.swift
//  HydraKit-iOS
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 HydraKit. All rights reserved.
//

import Foundation
import Hydra

/*
 Centralises the download operation
 */

typealias DownloadPromiseFulfill = (Data) -> Void
typealias DownloadPromiseError = (Error) -> Void

open class URLSessionHelper {
  
  public var maxConcurrentOperationCount: Int = 30 {
    didSet {
      queue.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
  }
  
  public var queue: OperationQueue = OperationQueue.main
  public var configuration: URLSessionConfiguration = URLSessionConfiguration.default
  public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
  public var timeoutInterval: TimeInterval = 60.0
  
  public static var shared: URLSessionHelper = URLSessionHelper()
  
  fileprivate init() {
  }
  
  public func get(in context: Context? = nil, from url: URL, headers: [String: String]? = nil) -> Promise<Data> {
    return Promise<Data>(in: context, token: nil) { (fulfill, fail, status) in
      let session = URLSession(configuration: self.configuration,
                               delegate: URLSessionHelperDelegate(fulfill: fulfill, fail: fail),
                               delegateQueue: self.queue)
      
      var request = URLRequest(url: url,
                               cachePolicy: self.cachePolicy,
                               timeoutInterval: self.timeoutInterval)
      request.httpMethod = "GET"
      if let headers = headers {
        for entry in headers {
          request.addValue(entry.value, forHTTPHeaderField: entry.key)
        }
      }
      
      let task: URLSessionDataTask = session.dataTask(with: request)
      task.resume()
    }
  }
  
  public func post(in context: Context? = nil, to: URL, body: Data, headers: [String: String]? = nil) -> Promise<Data> {
    return Promise<Data>(in: context, token: nil) { (fulfill, fail, status) in
      let session = URLSession(configuration: self.configuration,
                               delegate: URLSessionHelperDelegate(fulfill: fulfill, fail: fail),
                               delegateQueue: self.queue)
      print("post to \(to)")
      var request = URLRequest(url: to)
      request.httpMethod = "POST"
      request.httpBody = body
      if let headers = headers {
        for entry in headers {
          request.addValue(entry.value, forHTTPHeaderField: entry.key)
        }
      }
      let task: URLSessionDataTask = session.dataTask(with: request)
      task.resume()
    }
  }
  
}

fileprivate class URLSessionHelperDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
  
  private(set) var expectedCount: Int = 0
  private(set) var buffer: Data = Data()
  
  var progress: Float {
    guard expectedCount >= 0 else {
      return 0.0
    }
    return Float(buffer.count) / Float(expectedCount)
  }
  private(set) var count: Int = 0
  
  var fulfill: DownloadPromiseFulfill
  var fail: DownloadPromiseError
  
  init(fulfill: @escaping DownloadPromiseFulfill, fail: @escaping DownloadPromiseError) {
    self.fulfill = fulfill
    self.fail = fail
  }
  
  func urlSession(
    _ session: URLSession,
    dataTask: URLSessionDataTask,
    didReceive response: URLResponse,
    completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
    defer {
      completionHandler(.allow)
    }
    expectedCount = Int(response.expectedContentLength)
    count = 0
  }
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    buffer.append(data)
    count += data.count
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    guard let error = error else {
      fulfill(buffer)
      return
    }
    fail(error)
  }
  
}
