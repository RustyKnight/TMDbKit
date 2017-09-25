//
//  URLBuilder.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 25/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

public enum URLBuilderError: Error {
	case invalidURL
}

class URLBuilder {
	let baseURL: String
	
	var parameters: [String: String] = [:]
	
	init(baseURL: String, parameters: [String:String]? = nil) {
		self.baseURL = baseURL
		guard let parameters = parameters else {
			return
		}
		for entry in parameters {
			self.parameters[entry.key] = entry.value
		}
	}
	
	func copy() -> URLBuilder {
		return URLBuilder(baseURL: baseURL, parameters: parameters)
	}
	
	func build() throws -> URL {
		var queryItems: [URLQueryItem] = []
		for entry in parameters {
			queryItems.append(URLQueryItem(name: entry.key, value: entry.value))
		}
		
		guard var components = URLComponents(string: baseURL) else {
			throw URLBuilderError.invalidURL
		}
		components.queryItems = queryItems
		guard let url = components.url else {
			throw URLBuilderError.invalidURL
		}
		return url
	}
	
	func with(parameter key: String, value: String) -> URLBuilder {
		parameters[key] = value
		return self
	}

	func with(parameter key: String, value: Bool) -> URLBuilder {
		return with(parameter: key, value: value ? "true" : "false")
	}

	func with(parameter key: String, value: Int) -> URLBuilder {
		return with(parameter: key, value: String(value))
	}

	func with(parameter key: String, value: Language) -> URLBuilder {
		return with(parameter: key, value: value.description)
	}

	func with(parameter key: String, value: Country) -> URLBuilder {
		return with(parameter: key, value: value.code2)
	}

	func with(parameter key: String, value: String?) -> URLBuilder {
		guard let value = value else {
			return self
		}
		return with(parameter: key, value: value)
	}
	
	func with(parameter key: String, value: Bool?) -> URLBuilder {
		guard let value = value else {
			return self
		}
		return with(parameter: key, value: value ? "true" : "false")
	}
	
	func with(parameter key: String, value: Int?) -> URLBuilder {
		guard let value = value else {
			return self
		}
		return with(parameter: key, value: String(value))
	}

	func with(parameter key: String, value: Language?) -> URLBuilder {
		guard let value = value else {
			return self
		}
		return with(parameter: key, value: value)
	}

	func with(parameter key: String, value: Country?) -> URLBuilder {
		guard let value = value else {
			return self
		}
		return with(parameter: key, value: value)
	}
}
