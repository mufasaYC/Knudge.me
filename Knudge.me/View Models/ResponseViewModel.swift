//
//  ResponseViewModel.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 07/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import Foundation

class ResponseViewModel {
	
	private var responses = [Response]()
	
	var rawDictionary = NSDictionary()
	
	var numberOfRows: Int! {
		return responses.count
	}
	
	func word(at index: Int) -> String {
		return responses[index].word ?? ""
	}
	
	func solution(at index: Int) -> String {
		return responses[index].solution ?? ""
	}
	
	func isCorrect(at index: Int) -> String {
		return responses[index].isCorrect ?? ""
	}
	
	var reload: Box<Bool?> = Box(nil)
	
	func parseResponses(dict: NSDictionary) {
		rawDictionary = dict
		guard let p = dict["payload"] as? NSDictionary else { return }
		guard let content = p["content_review"] as? [NSDictionary] else { return }
		for i in content {
			let r = Response(dict: i)
			responses.append(r)
		}
		
		reload.value = true
		
	}
	
}

struct Response {
	
	var word: String!
	var solution: String!
	var isCorrect: String!
	
	init(dict: NSDictionary) {
		word = dict["question"] as? String ?? ""
		solution = (dict["solution"] as? String ?? "").replacingOccurrences(of: "<b>Meaning</b>: ", with: "")
		isCorrect = String(describing: dict["is_correct"] as? Bool ?? false)
	}
	
}
