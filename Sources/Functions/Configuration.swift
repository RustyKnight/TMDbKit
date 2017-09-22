//
//  Configuration.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

// GET /configuration
// https://api.themoviedb.org/3/configuration?api_key=...

public protocol Images {
	var baseURL: String {get}
	var secureBaseURL: String {get}
	var backdropSizes: [String] {get}
	var logoSizes: [String] {get}
	var posterSizes: [String] {get}
	var profileSizes: [String] {get}
	var stillSizes: [String] {get}
}

public protocol Configuration {
	var images: Images {get}
	var changeKeys: [String] {get}
}
