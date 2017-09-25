//
//  TMDb.swift
//  TMDb
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

/*
v3 API Key: ...
API Read Access Token (v4): ...
example: https://api.themoviedb.org/3/movie/550?api_key=...
*/

public protocol Identifiable {
  var id: Int {get}
}

enum APIVersion: String, CustomDebugStringConvertible {
	case three = "3"
	
	var debugDescription: String {
		return rawValue
	}
}

public class TMDb {
  public static var shared: TMDb = TMDb()

	private let baseURL = "https://api.themoviedb.org/3"

  public var apiKey: String?
  public var readAccessToken: String?
	
	struct Parameters {
		static let apiKeyParameter: String = "api_key"
		static let language: String = "language"
		static let query: String = "query"
		static let page: String = "page"
		static let includeAdult: String = "include_adult"
		static let region: String = "region"
		static let year: String = "year"
		static let primaryReleaseYear: String = "primary_release_year"
	}
  
  fileprivate init() {
  }
	
	func makeURL(version: APIVersion = .three, path: String) -> URLBuilder {
		return URLBuilder(baseURL: "\(baseURL)/\(version)/\(path)").with(parameter: Parameters.apiKeyParameter, value: apiKey ?? "")
	}
}

