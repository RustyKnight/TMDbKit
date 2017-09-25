//
//  Searches.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

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
	var releaseDate: Date {get}
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
		case totalPages = "total_page"
		case totalResults = "total_results"
		case searchResults = "results"
	}

	var page: Int?
	var totalPages: Int?
	var totalResults: Int?
	var searchResults: [DefaultMovieSearchResult]
}

struct DefaultMovieSearchResult: MovieSearchResult, Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case backdropPath = "backdrop_path"
		case genres = "genre_ids"
		case title
		case originalTitle = "original_title"
		case releaseDate = "release_date"
		case hasVideo = "video"
		case popularity
		case posterPath = "poster_path"
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}
	
	var id: Int
	var backdropPath: String?
	var genres: [Int]
	var title: String
	var originalTitle: String
	var releaseDate: Date
	var hasVideo: Bool
	var popularity: Double
	var posterPath: String?
	var voteAverage: Double
	var voteCount: Int
}

fileprivate enum SearchPath: String, CustomStringConvertible {
	case movies = "/search/movie"
	
	var description: String {
		return rawValue
	}
}

public extension TMDb {
	
  public func search(forMovie query: String,
                     language: Language = .english + .unitedStatesOfAmerica,
                     page: Int = 1,
                     includeAdult: Bool = false,
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
		let url = try makeURL(version: APIVersion.three, path: SearchPath.movies.description)
			.with(parameter: Parameters.language, value: language)
			.with(parameter: Parameters.query, value: query)
			.with(parameter: Parameters.page, value: page)
			.with(parameter: Parameters.includeAdult, value: includeAdult)
			.with(parameter: Parameters.region, value: region)
			.with(parameter: Parameters.year, value: year)
			.with(parameter: Parameters.primaryReleaseYear, value: primaryReleaseYear).build()
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
