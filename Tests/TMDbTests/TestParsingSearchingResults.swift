//
//  TestParsingSearchingResults.swift
//  TMDb
//
//  Created by Shane Whitehead on 25/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import XCTest
@testable import TMDbKit

class TestParsingSearchingResults: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testThatCanParseMovieSearchResults() {
		let bundle = Bundle(for: type(of: self))
		print("\(String(describing: bundle.path(forResource: "MovieSearchResults", ofType: "json")))")
		guard let url = bundle.url(forResource: "MovieSearchResults", withExtension: "json") else {
			XCTFail("Could not find MovieSearchResults.json")
			return
		}
		do {
			let data = try Data(contentsOf: url)
			let decoder = JSONDecoder()
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd"
			decoder.dateDecodingStrategy = .formatted(formatter)
			let movieSearchResults = try decoder.decode(DefaultMoiveSearchResults.self, from: data)
			
			print("Page \(movieSearchResults.page ?? 0)")
			print("Total Pages \(movieSearchResults.totalPages ?? 0)")
			print("Total Results \(movieSearchResults.totalResults ?? 0)")

			for result in movieSearchResults.searchResults {
				print("\(result.title); \(result.originalTitle); \(result.releaseDate)")
			}
		} catch let error {
			XCTFail("\(error)")
		}
	}
	
}
