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

public protocol MovieSearchResult: Identifiable {
	var voteCount: Int {get}
	var video: Bool {get}
	var voteAverage: Double {get}
	var title: String {get}
	var popularity: Double {get}
	var posterPath: String {get}
	var originalLanguage: Language {get}
	var originalTitle: String {get}
	var generes: [Int] {get}
	var backdropPath: String {get}
	var adult: Bool {get}
	var overview: String {get}
	var releaseDate: Date {get}
}

struct MovieSearchResults {
	var page: Int
	var totalResults: Int
	var totalPages: Int
	var results: [MovieSearchResult]
}

public protocol CompanySearchResult: Identifiable {
  var logoPath: String? {get}
  var name: String {get}
}

struct CompanySearchResults {
	var page: Int?
	var totalPages: Int?
	var totalResults: Int?
	var results: [CompanySearchResult]
}

public extension TMDb {
  
  public func search(for query: String,
                     language: Language = .english,
                     page: Int = 1,
                     includeAdult: Bool = false,
                     region: String? = nil,
                     year: Int? = nil,
                     primaryReleaseYear: String? = nil) {
    
  }

}
