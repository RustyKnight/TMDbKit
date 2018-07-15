//
//  URLBuilder+Parameter.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 15/7/18.
//  Copyright © 2018 TMDb. All rights reserved.
//

import Foundation

public extension URLBuilder {
	
	public func with(parameter key: QueryParameter, value: String) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}

	public func with(parameter key: QueryParameter, value: Bool) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}
	
	public func with(parameter key: QueryParameter, value: Int) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}
	
	public func with(parameter key: QueryParameter, value: Language) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}
	
	public func with(parameter key: QueryParameter, value: Country) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}
	
	public func with(parameter key: QueryParameter, value: String?) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}
	
	public func with(parameter key: QueryParameter, value: Bool?) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}
	
	public func with(parameter key: QueryParameter, value: Int?) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}
	
	public func with(parameter key: QueryParameter, value: Language?) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}
	
	public func with(parameter key: QueryParameter, value: Country?) -> URLBuilder {
		return with(parameter: key.name, value: value)
	}

}
