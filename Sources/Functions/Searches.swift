//
//  Searches.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation
import Hydra
import HydraKit

// GET /search/company
// GET /search/collection
// GET /search/keyword
// GET /search/movie
// GET /search/multi
// GET /search/person
// GET /search/tv

// MARK: External API

public protocol PosterPath {
	var posterPath: String? {get}
}

public protocol BackgroundPath {
	var backdropPath: String? {get}
}

public protocol ProfilePath {
	var profilePath: String? {get}
}

public protocol Popular {
	var popularity: Double {get}
}

public protocol Votable {
	var voteAverage: Double {get}
	var voteCount: Int {get}
}

public protocol Namable {
	var name: String {get}
}

public protocol OptionalNamable {
	var name: String? {get}
}

public protocol Overviewable {
	var overview: String {get}
}

public protocol Genreable {
	var genres: [Int] {get}
}

public protocol CompanySearchResult: Identifiable, Namable {
	var logoPath: String? {get}
}

public protocol OriginalLanguage {
	var originalLanguage: Language {get}
}

public protocol AdultResult {
	var isAdult: Bool {get}
}

public protocol OptionalAdultResult: AdultResult {
	var isAdult: Bool? {get}
}

public typealias MediaSearchResult = Identifiable & BackgroundPath & PosterPath & Genreable & Popular & Votable

public protocol MovieSearchResult: MediaSearchResult {
	var title: String {get}
	var originalTitle: String {get}
	var releaseDate: Date? {get}
	var hasVideo: Bool {get}
}

public typealias CollectionSearchResult = Identifiable & BackgroundPath & PosterPath & Namable

public typealias KeywordSearchResult = Identifiable & Namable

public protocol KnownFor {
	var movies: [MovieSearchResult] {get}
	var tv: [MovieSearchResult] {get}
}

public protocol PeopleSearchResult: Identifiable, Popular, Votable, ProfilePath, Namable, AdultResult {
	var knownFor: [KnownFor] {get}
}

public protocol TVSearchResult: MediaSearchResult, Namable {
	var firstAirDate: Date {get}
	var originalCountry: Country {get}
	var originalName: String {get}
}

public protocol MultiSearchResults {
	var movies: [MovieSearchResult] {get}
	var tv: [TVSearchResult] {get}
	var people: [PeopleSearchResult] {get}
}

// MARK: Internal API

// The intention is to use the Swing 4 JSON decoding support, this how ever
// will require generating a lot of "useless" information depending on what
// is been retrieved. Instead of exposing that to the caller, the API will
// make use of the internal API structures to build the information
// from the raw results, it will then tranform the results more useful
// strctures based on the type of information which was retrieved, making
// the process much simpler for external callers

enum MediaType: String {
	case movie = "movie"
	case tv = "tv"
	case person = "person"
}

protocol MediaTypeSearchable {
	var mediaType: MediaType {get}
}

protocol OptionalMovieSearchResult: MovieSearchResult, OptionalAdultResult {
	var title: String? {get}
	var originalTitle: String? {get}
	var releaseDate: Date? {get}
	var hasVideo: Bool? {get}
}

typealias OptionalKnowForMedia = OptionalMovieSearchResult & OptionalTVSearchResult & MediaTypeSearchable

protocol OptionalPeopleSearchResult: Identifiable, Popular, Votable, ProfilePath, Namable, AdultResult {
	var knownFor: [OptionalKnowForMedia]? {get}
}

protocol OptionalTVSearchResult: TVSearchResult, OptionalNamable {
	var firstAirDate: Date? {get}
	var originalCountry: Country? {get}
	var originalName: String? {get}
}

typealias MultiSearchResult = OptionalMovieSearchResult & OptionalTVSearchResult & OptionalPeopleSearchResult & MediaTypeSearchable

protocol SearchResults {
	associatedtype SearchResult
	var searchResults: [SearchResult] {get}
	var page: Int? {get}
	var totalPages: Int? {get}
	var totalResults: Int? {get}
}

protocol MovieSearchResults: SearchResults where SearchResult == MovieSearchResult {
}

struct DefaultMoiveSearchResults: SearchResults, Decodable {
	typealias SearchResult = DefaultMovieSearchResult
	
	enum CodingKeys: String, CodingKey {
		case page
		case totalPages = "total_pages"
		case totalResults = "total_results"
		case searchResults = "results"
	}

	var page: Int?
	var totalPages: Int?
	var totalResults: Int?
	var searchResults: [DefaultMovieSearchResult]
}

struct DefaultMovieSearchResult: MovieSearchResult, Decodable {
	
	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case backdropPath = "backdrop_path"
		case genres = "genre_ids"
		case title = "title"
		case originalTitle = "original_title"
		case releaseDate = "release_date"
		case hasVideo = "video"
		case popularity = "popularity"
		case posterPath = "poster_path"
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}
	
	var id: Int
	var backdropPath: String?
	var posterPath: String?
	var releaseDate: Date?
	var genres: [Int]
	var title: String
	var originalTitle: String
	var hasVideo: Bool
	var popularity: Double
	var voteAverage: Double
	var voteCount: Int
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		
		if container.contains(.backdropPath) {
			backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
		}
		if container.contains(.posterPath) {
			posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
		}
		title = try container.decode(String.self, forKey: .title)
		originalTitle = try container.decode(String.self, forKey: .originalTitle)
		hasVideo = try container.decode(Bool.self, forKey: .hasVideo)
		popularity = try container.decode(Double.self, forKey: .popularity)
		voteAverage = try container.decode(Double.self, forKey: .voteAverage)
		voteCount = try container.decode(Int.self, forKey: .voteCount)
		genres = try container.decode([Int].self, forKey: .genres)
		
		if container.contains(.releaseDate) {
			let dateString = try container.decode(String.self, forKey: .releaseDate)
			if let date = DefaultMovieSearchResult.dateFormatter.date(from: dateString) {
				releaseDate = date
			} else {
				releaseDate = nil
			}
		} else {
			releaseDate = nil
		}
	}
}

//fileprivate enum SearchPath: String, CustomStringConvertible {
//	case movies = "/search/movie"
//
//	var description: String {
//		return rawValue
//	}
//}

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
                     page: Int = 1,
                     includeAdultContent: Bool = false,
                     region: Country? = nil,
                     year: Int? = nil,
                     primaryReleaseYear: String? = nil) throws {
    // Make URL
		// &api_key
		// &language
		// &query
		// &page
		// &include_adult
		// &region
		// &year
		// &primary_release_year
		let url = try build(version: APIVersion.three,
												command: Commands.Search.movies,
												language: language,
												includeAdultContent: includeAdultContent,
												region: region)
			.with(parameter: QueryParameters.query, value: query)
			.with(parameter: QueryParameters.page, value: page)
			.with(parameter: QueryParameters.year, value: year)
			.with(parameter: QueryParameters.primaryReleaseYear, value: primaryReleaseYear).build()
		
  }

	public func search(forCompanies query: String,
	                   page: Int = 1) {
		
	}

	public func search(forCollections query: String,
	                   language: Language = .english + .unitedStatesOfAmerica,
	                   page: Int = 1) {
		
	}

	public func search(forKeywords query: String,
	                   page: Int = 1) {
		
	}

	public func multiSearch(query: String,
	                        language: Language = .english + .unitedStatesOfAmerica,
	                        page: Int = 1,
	                        includeAdult: Bool = false,
	                        region: Country? = nil) {

	}
	
	public func search(forPeople query: String,
	                        language: Language = .english + .unitedStatesOfAmerica,
	                        page: Int = 1,
	                        includeAdult: Bool = false,
	                        region: Country? = nil) {
		
	}
	
	public func search(forTV query: String,
	                   language: Language = .english + .unitedStatesOfAmerica,
	                   page: Int = 1,
	                   firstAirDateYear: Int? = nil) {
		
	}
}
