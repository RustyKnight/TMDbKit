//
//  File.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

// GET /genre/movie/list
// GET /genre/tv/list
// GET /genre/{genre_id}/movies
// https://api.themoviedb.org/3/genre/movie/list?api_key=...&language=en-US

public protocol Genre {
	var id: Int {get}
	var name: String {get}
}

// This may only be an internal requirement for parsing
public protocol Genres {
  var genres: [Genre] {get}
}
