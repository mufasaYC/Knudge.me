//
//  File.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 06/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import Foundation

struct AirBalloon {
	
	var question: String!
	var answer: String
	var options: [String]!
	var level: Int!
	var id: Int!
	
	init() {
		question = ""
		answer = ""
		options = ["","",""]
		level = 0
		id = 0
	}
	
	init(dictionary: NSDictionary) {
		question = dictionary["word"] as? String ?? ""
		answer = dictionary["answer"] as? String ?? ""
		options = dictionary["options"] as? [String] ?? ["","",""]
		level = dictionary["level"] as? Int ?? 0
		id = dictionary["id"] as? Int ?? 0
	}
	
}

