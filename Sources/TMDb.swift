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

let baseURL = "https://api.themoviedb.org/3"

public protocol Identifiable {
  var id: Int {get}
}

public class TMDb {
  public static var shared: TMDb = TMDb()
  
  public var apiKey: String?
  public var readAccessToken: String?
  
  fileprivate init() {
  }
}

