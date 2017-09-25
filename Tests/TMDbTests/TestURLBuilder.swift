//
//  TestURLBuilder.swift
//  TMDb-iOS Tests
//
//  Created by Shane Whitehead on 25/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import XCTest
@testable import TMDbKit

class TestURLBuilder: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testThatBuilderGeneratesValidURL() {
		guard let url = URLBuilder(baseURL: "https://api.themoviedb.org/3/search/movie")
			.with(parameter: "api_key", value: "b8031409dad8c17a516fc3f8468be7ba")
			.with(parameter: "language", value: "en-AU")
			.with(parameter: "query", value: "Star Wars")
			.with(parameter: "page", value: 1)
			.with(parameter: "include_adult", value: false)
			.with(parameter: "region", value: Country.australia)
//			.with(parameter: "year", value: 1974)
//			.with(parameter: "primary_release_year", value: 1974)
			.build() else {
				XCTFail("Failed to generate a valid URL?")
				return
		}
		print(url)
	}
	
}
