//
//  KeyWords.swift
//  TMDb-iOS
//
//  Created by Shane Whitehead on 22/9/17.
//  Copyright © 2017 TMDb. All rights reserved.
//

import Foundation

// GET /keyword/{keyword_id}
// GET /keyword/{keyword_id}/movies

public protocol Keyword {
	var id: Int {get}
	var name: String {get}
}
