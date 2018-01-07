//
//  ResultViewModel.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 07/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import Foundation

class ResultViewModel {
	
	private(set) var score: String!
	private(set) var userHighestScore: String!
	private(set) var gameHighestScore: String!
	private(set) var correct: String!
	private(set) var duration: String!
	private(set) var rawDictionary = NSDictionary()
	
	
	var isSet: Box<Bool> = Box(false)
	
	func setValues(dict: NSDictionary?) {
		rawDictionary = dict ?? NSDictionary()
		guard let d = dict else { return }
		guard let p = d["payload"] as? NSDictionary else { return }
		score = String(describing: p["score"] as? Int ?? 0)
		userHighestScore = String(describing: p["user_highest_score"] as? Int ?? 0)
		gameHighestScore =  String(describing: p["game_highest_score"] as? Int ?? 0)
		duration =  String(describing: p["time_elapsed"] as? Int ?? 0) + " secs"
		correct = String(describing: p["correctly_attempted"] as? Int ?? 0)
		isSet.value =  true
	}
	
}
