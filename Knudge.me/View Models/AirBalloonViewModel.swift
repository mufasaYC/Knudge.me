//
//  HotAirBalloonViewModel.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 05/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import Foundation
import UIKit

enum GameStatus {
	case notLoaded, start, ended, result, error
}

class AirBalloonViewModel {

	private var game = [AirBalloon]()
	private var attemptRecord = [[String: Any]]()
	private var result: NSDictionary?
	
	var totalQuestions: Int?
	var durationPerQuestion: Int?
	var title: String?
	var description: String?
	var errorMessage: String?
	
	var gameStatus: Box<GameStatus> = Box(.notLoaded)
	
	func question() -> String? {
		return game.first?.question
	}
	
	func options() -> [String] {
		return game.first?.options ?? ["","",""]
	}
	
	func gameResult() -> NSDictionary? {
		return result
	}
	
	func check(answer: String?, timeTaken: Double) -> String {
		let isAttempted = answer == nil ? false : true
		let correctAnswer = game.first?.answer
		let isCorrect = (answer ?? "").lowercased() == game.first?.answer.lowercased() ? true : false
		let attempt = ["id": game.first?.id ?? "", "response": answer ?? "", "time_taken": timeTaken, "is_attempted": isAttempted, "is_correct": isCorrect, "level": game.first?.level ?? ""] as [String : Any]
		attemptRecord.append(attempt)
		if !isCorrect {
			submit()
			return correctAnswer ?? ""
		}
		checkGameStatus()
		return correctAnswer ?? ""
	}
	
	private func checkGameStatus() {
		game.removeFirst()
		if game.isEmpty {
			gameStatus.value = .ended
			submit()
		}
	}
}

//MARK:- Fetching

extension AirBalloonViewModel {
	
	func fetch()  {
		let r = GameRoutes()
		r.airBalloon(sessionToken: "", completionHandler: { [weak self] dict, errMsg in
			
			if errMsg != nil {
				//ERROR
				self?.errorMessage = errMsg ?? "Encountered an error"
				self?.gameStatus.value = .error
				return
			}
			
			if let x = dict {
				if let payload = x["payload"] as? NSDictionary {
					self?.title = payload["title"] as? String
					self?.description = payload["description"] as? String
					self?.durationPerQuestion = payload["per_question_duration"] as? Int
					self?.totalQuestions = payload["total_questions"] as? Int
					
					if let y = payload["game"] as? [NSDictionary] {
						for i in y {
							let m = AirBalloon(dictionary: i)
							self?.game.append(m)
						}
					}
				}
			}
			self?.gameStatus.value = .start
		})
	}
	
}

//MARK:- Submitting Response

extension AirBalloonViewModel {
	
	func submit() {
		//did not understand game won scenario, so i kept it false
		let r = GameRoutes()
		r.airBalloonResult(sessionToken: "", gameData: attemptRecord, totalQuestions: totalQuestions!, perQuestionDuration: durationPerQuestion!, gameWon: false, completionHandler: { [weak self] dict, errMsg in
			
			if errMsg != nil {
				//ERROR
				self?.errorMessage = errMsg ?? "Encountered an error"
				self?.gameStatus.value = .error
				return
			}
			
			self?.result = dict
			self?.gameStatus.value = .result
			
		})
	}
	
}
