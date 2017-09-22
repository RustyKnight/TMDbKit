//
//  Jobs.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

// GET /job/list
// https://api.themoviedb.org/3/job/list?api_key=...

public protocol Job {
	var deparment: String {get}
	var list: [String] {get}
}

public protocol Jobs {
	var jobs: [Job] {get}
}
