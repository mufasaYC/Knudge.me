//
//  ResultViewController.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 07/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

	var viewModel = ResultViewModel()
	
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	@IBOutlet weak var correctLabel: UILabel!
	@IBOutlet weak var gameBestScore: UILabel!
	@IBOutlet weak var userBestScore: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel.isSet.bind(listener: { [weak self] _ in
			
			self?.initialiseLabels()
			
		})
    }
	
	func initialiseLabels() {
		scoreLabel.text = viewModel.score
		durationLabel.text = viewModel.duration
		correctLabel.text = viewModel.correct
		gameBestScore.text = viewModel.gameHighestScore
		userBestScore.text = viewModel.userHighestScore
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let d = segue.destination as?
			ResponseViewController else { return }
		
		d.viewModel.parseResponses(dict: viewModel.rawDictionary)
		
	}

}
