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

public protocol Adutable {
	var isAdult: Bool {get}
}

public protocol OptionalAdutable: Adutable {
	var isAdult: Bool? {get}
}

public typealias MediaSearchResult = Identifiable & BackgroundPath & PosterPath & Genreable & Popular & Votable

public protocol MovieSearchResult: MediaSearchResult {
	var title: String {get}
	var originalTitle: String {get}
	var releaseDate: Date {get}
	var hasVideo: Bool {get}
}

public protocol OptionalMovieSearchResult: MovieSearchResult, OptionalAdutable {
	var title: String? {get}
	var originalTitle: String? {get}
	var releaseDate: Date? {get}
	var hasVideo: Bool? {get}
}

public typealias CollectionSearchResult = Identifiable & BackgroundPath & PosterPath & Namable

public typealias KeywordSearchResult = Identifiable & Namable

public protocol PeopleSearchResult: Identifiable, Popular, Votable, ProfilePath, Namable, Adutable {
	typealias KnowForMedia = OptionalMovieSearchResult & OptionalTVSearchResult
	var knownFor: [KnowForMedia] {get}
}

public protocol OptionalPeopleSearchResult: PeopleSearchResult {
	var knownFor: [KnowForMedia]? {get}
}

public protocol TVSearchResult: MediaSearchResult, Namable {
	var firstAirDate: Date {get}
	var originalCountry: Country {get}
	var originalName: String {get}
}

public protocol OptionalTVSearchResult: TVSearchResult, OptionalNamable {
	var firstAirDate: Date? {get}
	var originalCountry: Country? {get}
	var originalName: String? {get}
}

public enum MediaType: String {
	case movie = "movie"
	case tv = "tv"
	case person = "person"
}

public protocol MediaTypeSearchable {
	var mediaType: MediaType {get}
}

typealias MultiSearchResult = OptionalMovieSearchResult & OptionalTVSearchResult & OptionalPeopleSearchResult & MediaTypeSearchable

public extension TMDb {
  
  public func search(forMovie query: String,
                     language: Language = .english + .unitedStatesOfAmerica,
                     page: Int = 1,
                     includeAdult: Bool = false,
                     region: Country? = nil,
                     year: Int? = nil,
                     primaryReleaseYear: String? = nil) {
    
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
