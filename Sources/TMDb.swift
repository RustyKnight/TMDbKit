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

public protocol Named {
	var name: String { get }
}

public protocol Command: Named {
}

public struct QueryParameter: Named {
	public let name: String
	
	init(name: String) {
		self.name = name
	}
}

public struct SearchCommand: Command {
	public let name: String
	
	init(name: String) {
		self.name = name
	}
}

public struct QueryParameters {
	static let apiKeyParameter = QueryParameter(name: "api_key")
	static let language = QueryParameter(name: "language")
	static let query = QueryParameter(name: "query")
	static let page = QueryParameter(name: "page")
	static let includeAdultContent = QueryParameter(name: "include_adult")
	static let region = QueryParameter(name: "region")
	static let year = QueryParameter(name: "year")
	static let primaryReleaseYear = QueryParameter(name: "primary_release_year")
}

public struct Commands {
}

public class TMDb {
  public static var shared: TMDb = TMDb()

	private let baseURL = "https://api.themoviedb.org"

  public var apiKey: String?
  public var readAccessToken: String?
	
  fileprivate init() {
  }
	
	func build(version: APIVersion = .three,
						 command: Command,
						 language: Language? = nil,
						 includeAdultContent: Bool = false,
						 region: Country? = nil) -> URLBuilder {
		let builder = URLBuilder(baseURL: "\(baseURL)/\(version)\(command.name)")
			.with(parameter: QueryParameters.apiKeyParameter,
						value: apiKey ?? "")
		
		if let language = language {
			_ = builder.with(parameter: QueryParameters.language, value: language.code)
		}
		_ = builder.with(parameter: QueryParameters.includeAdultContent, value: includeAdultContent)
		if let region = region {
			_ = builder.with(parameter: QueryParameters.region, value: region)
		}
		
		return builder
	}
}

