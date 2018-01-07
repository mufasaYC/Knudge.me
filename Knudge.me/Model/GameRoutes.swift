//
//  Routes.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 06/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import Foundation
import Alamofire

struct GameRoutes {
	
	func airBalloon(sessionToken: String, completionHandler: @escaping (NSDictionary?, String?) -> ()) {
		
		let url = "http://test.knudge.me/api/v1/games/air_balloon?user_id=23&app_version=1.0.1&platform=android&device_id=abcd&session_token=\(sessionToken1)"
		
		Alamofire.request(url, method: .get).responseJSON { res in

			switch res.result {
			case .success(let value):
				if res.response?.statusCode == 200 || res.response?.statusCode == 201 {
					print(value as? NSDictionary ?? "NOTHING")
					completionHandler(value as? NSDictionary, nil)
				} else if res.response?.statusCode == 401 {
					if let dict = value as? NSDictionary {
						print(dict["message"] as? String ?? "Not a valud user.")
						completionHandler(nil, dict["message"] as? String ?? "Not a valud user.")
					}
				} else {
					if let dict = value as? NSDictionary {
						print(dict["message"] as? String ?? "The team has been notified, we will fix the bug soon!")
						completionHandler(nil, dict["message"] as? String ?? "The team has been notified, we will fix the bug soon!")
					}
				}
			case .failure(let error):
				print("Status Code : ", res.response?.statusCode ?? "Unknown")
				print(error)
				completionHandler(nil, "Error with status code - "+String(describing: res.response?.statusCode))
			}
		}
		
	}
	
	
	func airBalloonResult(sessionToken: String, gameData: [[String: Any]], totalQuestions: Int, perQuestionDuration: Int, gameWon: Bool, completionHandler: @escaping (NSDictionary?, String?) -> ()) {
		
		let parameters = ["user_id": "23", "app_version": "1.0.1", "platform": "android", "device_id": "abcd", "session_token": sessionToken1, "game_data":
			gameData, "total_questions": totalQuestions, "per_question_duration": perQuestionDuration, "game_won": gameWon] as [String: Any]
		
		
		let headers = ["Content-Type": "application/json"]
		
		print(parameters)
		
		Alamofire.request("http://test.knudge.me/api/v1/games/air_balloon", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { res in
			switch res.result {
			case .success(let value):
				if res.response?.statusCode == 200 || res.response?.statusCode == 201 {
					completionHandler(value as? NSDictionary, nil)
				} else {
					print("Status Code : ", res.response?.statusCode ?? "Unknown")
					if let dict = value as? NSDictionary {
						print(dict["message"] as? String ?? "The team has been notified, we will fix the bug soon!")
						completionHandler(nil, dict["message"] as? String ?? "The team has been notified, we will fix the bug soon!")
					}
				}
			case .failure(let error):
				print("Status Code : ", res.response?.statusCode ?? "Unknown")
				print(error)
				completionHandler(nil, "Error with status code - "+String(describing: res.response?.statusCode))
			}
		}
		
	}
	
}
















let sessionToken1 = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjFkYjAxNzVkMWM1ZjQ1YTlkZGEyNzlmYzkxYjY3YTEzOGJjMjA1NTUifQ.eyJhenAiOiI5NjM3NDA5NTMxNDMtdjVvYmFkZmRhcnRrbGE3bDZzbjlpdWVsbm5lbDVsdXEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI5NjM3NDA5NTMxNDMtaG85Y3FuZmhvZXU5bmJobWI0ODM0amE2MW1tdmI3ZXIuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTgwMjI0NjE5ODEzNjIzMjA3MjciLCJoZCI6ImtudWRnZS5tZSIsImVtYWlsIjoicHVzaHByYWpAa251ZGdlLm1lIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImlzcyI6ImFjY291bnRzLmdvb2dsZS5jb20iLCJpYXQiOjE1MTUwNjE4NzEsImV4cCI6MTUxNTA2NTQ3MX0.TsH5fAXyXxQ8FMzN-apHAk8HmLZghmM6O2156WU9J_qlQt-EgnHAxw_C1BjDaijEu1EgnecKkM_UrLbq8pbZlELU4xcsu_FjZ2aX3CAX1K3_tWE9YkG9O1BaAS2Ukq2t2JtsAffAXmf2Oo8qbo9aIW129MAF1rLELRhdCE__YR9xR58s8itDd7eStxKpvi5HSajh_teIfyqlijT6nYGurEZHosrCuYb8phcKeg3TR5OP1h5d97D3IY8ti2quHuU-8eiVPniT5jGOEZkzVaG39oukQr_Yn1HnM4iNF2UIqrnzrAyxtlR-C6_v4-bj6mV6KMoyL-N4Vdlpc5B1xaNVWw"
