//
//  SearchCommand.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 25/7/18.
//  Copyright © 2018 TMDb. All rights reserved.
//

import Foundation
import HydraKit
import Hydra

public extension Commands {
	struct Search {
		static let multi = SearchCommand(name: "/search/multi")
		static let companies = SearchCommand(name: "/search/company")
		static let collections = SearchCommand(name: "/search/collection")
		static let keywords = SearchCommand(name: "/search/keyword")
		static let movies = SearchCommand(name: "/search/movie")
		static let people = SearchCommand(name: "/search/person")
		static let tv = SearchCommand(name: "/search/tv")
	}
}


public extension TMDb {
	
	public func search(forMovie query: String,
										 language: Language = .english + .unitedStatesOfAmerica,
										 includeAdultContent: Bool = false,
										 region: Country? = nil,
										 year: Int? = nil,
										 primaryReleaseYear: String? = nil) -> Promise<[MovieSearchResult]> {
		// Make URL
		// &api_key
		// &language
		// &query
		// &page
		// &include_adult
		// &region
		// &year
		// &primary_release_year
		
		let builder = build(version: APIVersion.three,
												command: Commands.Search.movies,
												language: language,
												includeAdultContent: includeAdultContent,
												region: region)
			.with(parameter: QueryParameters.query, value: query)
			//			.with(parameter: QueryParameters.page, value: page)
			.with(parameter: QueryParameters.year, value: year)
			.with(parameter: QueryParameters.primaryReleaseYear, value: primaryReleaseYear)
		
		return MovieSearcher(builder: builder).execute()
	}

//
//	public func search(forCompanies query: String,
//										 page: Int = 1) {
//
//	}
//
//	public func search(forCollections query: String,
//										 language: Language = .english + .unitedStatesOfAmerica,
//										 page: Int = 1) {
//
//	}
//
//	public func search(forKeywords query: String,
//										 page: Int = 1) {
//
//	}
//
//	public func multiSearch(query: String,
//													language: Language = .english + .unitedStatesOfAmerica,
//													page: Int = 1,
//													includeAdult: Bool = false,
//													region: Country? = nil) {
//
//	}
//
//	public func search(forPeople query: String,
//										 language: Language = .english + .unitedStatesOfAmerica,
//										 page: Int = 1,
//										 includeAdult: Bool = false,
//										 region: Country? = nil) {
//
//	}
//
//	public func search(forTV query: String,
//										 language: Language = .english + .unitedStatesOfAmerica,
//										 page: Int = 1,
//										 firstAirDateYear: Int? = nil) {
//
//	}
}

class MovieSearcher {
	
	let builder: URLBuilder
	
	init(builder: URLBuilder) {
		self.builder = builder
	}
	
	func execute() -> Promise<[MovieSearchResult]> {
		return Promise<URL>(in: .userInitiated) { (fulfill, fail, _) in
			fulfill(try self.builder.build())
		}.then { (url) -> Promise<Data> in
			return URLSessionHelper.shared.get(from: url)
		}.then { (result) -> DefaultMoiveSearchResults in
			return try self.parse(result)
		}.then { (result) -> Promise<[DefaultMoiveSearchResults]> in
			guard let totalPages = result.totalPages, totalPages > 1 else {
				return Promise<[DefaultMoiveSearchResults]>(resolved: [result])
			}
			var requests: [Promise<DefaultMoiveSearchResults>] = []
			requests.append(Promise<DefaultMoiveSearchResults>(resolved: result))
			for page in 2...totalPages {
				requests.append(self.results(with: self.builder, forPage: page))
			}
			
			return all(requests)
		}.then { (results) -> Promise<[MovieSearchResult]> in
			var merged: [MovieSearchResult] = []
			for pagedResult in results {
				merged.append(contentsOf: pagedResult.searchResults)
			}
			return Promise<[MovieSearchResult]>(resolved: merged)
		}
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
}
