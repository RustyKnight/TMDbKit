//
//  TestSearch.swift
//  TMDb-iOS Tests
//
//  Created by Shane Whitehead on 25/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import XCTest
@testable import TMDbKit
import Hydra
import HydraKit

class TestSearch: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testThatSearchResultsCanBeDownloaded() {
		let exp = expectation(description: "Perform search")
		async { () -> URLBuilder in
			let builder = URLBuilder(baseURL: "https://api.themoviedb.org/3/search/movie")
				.with(parameter: "api_key", value: "b8031409dad8c17a516fc3f8468be7ba")
				.with(parameter: "language", value: "en-AU")
				.with(parameter: "query", value: "Star Wars")
				.with(parameter: "page", value: 1)
				.with(parameter: "include_adult", value: false)
				.with(parameter: "region", value: Country.australia)
			return builder
		}.then { (builder) -> Promise<Data> in
			let url = try builder.build()
			print(url)
			let response = URLSessionHelper.shared.get(from: url)
			return response
		}.then { (data) in
			exp.fulfill()
		}
		waitForExpectations(timeout: 3600.0, handler: { (error) in
			guard let error = error else {
				return
			}
			XCTFail("\(error)")
		})
	}
	
	func downloadResults(from: URLBuilder) {
//		return Promise<MovieSearchResults>()
	}
	
	func parse(_ data: Data) throws -> DefaultMoiveSearchResults {
		let decoder = JSONDecoder()
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		decoder.dateDecodingStrategy = .formatted(formatter)
		return try decoder.decode(DefaultMoiveSearchResults.self, from: data)
	}
	
	func results(with builder: URLBuilder, forPage page: Int) -> Promise<DefaultMoiveSearchResults> {
		return Promise<URLBuilder>(in: .userInitiated) { (fulfill, fail, _) in
			let copy = builder.copy()
			fulfill(copy.with(parameter: QueryParameters.page, value: page))
		}.then({ (builder) -> Promise<Data> in
			let url = try builder.build()
			print(url)
			return URLSessionHelper.shared.get(from: url)
		}).then({ (result) -> DefaultMoiveSearchResults in
			return try self.parse(result)
		})
	}
	
	func testMultiPageResults() {
		let exp = expectation(description: "Perform search")
		TMDb.shared.apiKey = "b8031409dad8c17a516fc3f8468be7ba"
		let builder = TMDb.shared.build(command: Commands.Search.movies,
														 language: .english + .unitedStatesOfAmerica,
														 region: .australia)
			.with(parameter: QueryParameters.query, value: "star")
		async(in: .userInitiated) { () in
		}.then { () -> Promise<Data> in
			let url = try builder.build()
			print(url)
			return URLSessionHelper.shared.get(from: url)
		}.then { (result) -> DefaultMoiveSearchResults in
			return try self.parse(result)
		}.then { (result) -> Promise<[DefaultMoiveSearchResults]> in
			guard let totalPages = result.totalPages, totalPages > 1 else {
				return Promise<[DefaultMoiveSearchResults]>(resolved: [result])
			}
			var requests: [Promise<DefaultMoiveSearchResults>] = []
			requests.append(Promise<DefaultMoiveSearchResults>(resolved: result))
			print("Found \(totalPages) pages")
			for page in 2...totalPages {
				requests.append(self.results(with: builder, forPage: page))
			}
			
			return all(requests)
		}.then { (results) in
			print("Completed processing \(results) pages")
		}.always {
			exp.fulfill()
		}.catch { (error) -> (Void) in
			print(error)
		}
		waitForExpectations(timeout: 3600.0, handler: { (error) in
			guard let error = error else {
				return
			}
			XCTFail("\(error)")
		})
	}
	
	func testMovieSearch() {
		let exp = expectation(description: "Perform search")
		TMDb.shared.apiKey = "b8031409dad8c17a516fc3f8468be7ba"
		TMDb.shared.search(forMovie: "star").then { (results) in
			print("Found \(results.count) matches")
			exp.fulfill()
		}.catch { (error) -> (Void) in
			XCTFail("\(error)")
		}
		waitForExpectations(timeout: 3600.0, handler: { (error) in
			guard let error = error else {
				return
			}
			XCTFail("\(error)")
		})
	}
	
}
