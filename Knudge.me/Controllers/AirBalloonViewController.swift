//
//  ViewController.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 05/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet var answerButtons: [UIButton]!
	
	var viewModel = AirBalloonViewModel()
	var imageView = UIImageView()
	var backgroundImageView = UIImageView()
	var animator: UIViewPropertyAnimator!
	var animatorBackground: UIViewPropertyAnimator!
	var time = Date().timeIntervalSince1970
	
	@IBOutlet weak var gameDescLabel: UILabel!
	@IBOutlet weak var gameTitleLabel: UILabel!
	@IBOutlet weak var startView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		backgroundImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		backgroundImageView.image = UIImage(named: "bg")
		backgroundImageView.contentMode = .bottom
		view.addSubview(backgroundImageView)
		imageView.frame = CGRect(x: 16, y: 0, width: 100, height: 100)
		imageView.image = UIImage(named: "hotAirBalloon")
		imageView.contentMode = .scaleAspectFit
		view.addSubview(imageView)
		view.sendSubview(toBack: imageView)
		view.sendSubview(toBack: backgroundImageView)
		
		animatorBackground = UIViewPropertyAnimator(duration: TimeInterval((viewModel.durationPerQuestion ?? 5) * (viewModel.totalQuestions ?? 10)), curve: .linear, animations: { [weak self] in
			let offsetY = 2000 - UIScreen.main.bounds.height
			self?.backgroundImageView.frame = CGRect(x: CGFloat(0), y: offsetY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
		})
		
		//listen to response of fetch request
		viewModel.gameStatus.bind(listener: { [unowned self] status in
			if status == .start {
				self.gameTitleLabel.text = self.viewModel.title ?? ""
				self.gameDescLabel.text = self.viewModel.description ?? ""
			} else if status == .ended {
				self.result()
			} else if status == .error {
				self.displayAlert(title: "Error", message: self.viewModel.errorMessage ?? "")
			}
		})
		//fetch data
		viewModel.fetch()
	}

	@IBAction func answerAction(_ sender: UIButton) {
		animator.pauseAnimation()
		let answer = viewModel.check(answer: sender.currentTitle ?? "", timeTaken: (Date().timeIntervalSince1970 - time))
		
		for i in answerButtons {
			i.isUserInteractionEnabled = false
			if i.currentTitle ?? "" == answer {
				i.backgroundColor = .green
			}
		}
		//if incorrect, end the game
		if sender.currentTitle ?? "" != answer {
			sender.backgroundColor = .red
			endGame()
			return
		}
		
		//reverse the air balloon to the very start
		//takes the background image higher
		animator.isReversed = true
		animator.addCompletion({ [weak self] completion in
			self?.animatorBackground.pauseAnimation()
			self?.nextQuestion()
		})
		animatorBackground.startAnimation()
		animator.startAnimation()
	}
	
	@IBAction func startGameButton(_ sender: UIButton) {
		//check if error in fetching game
		if viewModel.gameStatus.value == .error {
			displayAlert(title: "Error", message: "Could not start game, try later")
			return
		}
		//wait for game to be loaded prior to removing the welcome page
		if viewModel.gameStatus.value == .notLoaded {
			viewModel.gameStatus.bind(listener: { [weak self] status in
				if status == .start {
					self?.startGameButton(sender)
				}
			})
			return
		}
		//remove the welcome view and start the game
		startView.removeFromSuperview()
		viewModel.gameStatus.bind(listener: { [weak self] status in
			if status == .start {
				self?.nextQuestion()
			}
		})
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let d = segue.destination as? ResultViewController {
			if let result = viewModel.gameResult() {
				d.viewModel.setValues(dict: result)
			}
		}
	}
	
}

extension ViewController {
	
	func nextQuestion() {
		//if questions are over, display result
		if  viewModel.question() == nil {
			result()
			return
		}
		
		//enabling buttons and setting up text
		for i in answerButtons {
			i.isUserInteractionEnabled = true
			i.backgroundColor = UIColor(white: 0, alpha: 0.4)
		}
		
		questionLabel.text = viewModel.question()
		let options = viewModel.options()
		answerButtons[0].setTitle(options[0], for: .normal)
		answerButtons[1].setTitle(options[1], for: .normal)
		answerButtons[2].setTitle(options[2], for: .normal)
		answerButtons[0].setTitle(options[0], for: .selected)
		answerButtons[1].setTitle(options[1], for: .selected)
		answerButtons[2].setTitle(options[2], for: .selected)
		
		animator = UIViewPropertyAnimator(duration: TimeInterval(viewModel.durationPerQuestion ?? 5), curve: .linear, animations: { [weak self] in
			self?.imageView.frame = CGRect(x: 16, y: UIScreen.main.bounds.height, width: 100, height: 100)
		})
		
		animator.addCompletion({ [weak self] animatingPosition in
			if animatingPosition == UIViewAnimatingPosition.end {
				_ = self?.viewModel.check(answer: nil, timeTaken: Double(self?.viewModel.durationPerQuestion ?? 5))
				self?.endGame()
			}
		})
		time = Date().timeIntervalSince1970
		animator.startAnimation()
		
	}
	
	func endGame() {
		animator.stopAnimation(true)
		animatorBackground.stopAnimation(true)
		//speeded drop animation
		animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: { [weak self] in
			self?.imageView.frame = CGRect(x: 16, y: UIScreen.main.bounds.height, width: 100, height: 100)
		})
		animator.startAnimation()
		animator.addCompletion( { [weak self] completion in
			self?.result()
		})
		
	}
	
	func result() {
		let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
		activity.backgroundColor = UIColor(white: 0, alpha: 0.75)
		activity.activityIndicatorViewStyle = .whiteLarge
		activity.startAnimating()
		view.addSubview(activity)
		view.bringSubview(toFront: activity)
		viewModel.gameStatus.bind(listener: { [weak self] status in
			if status == .result {
				self?.performSegue(withIdentifier: "result", sender: self)
			} else if status == .error {
				self?.performSegue(withIdentifier: "result", sender: nil)
			}
		})
	}
	
}

