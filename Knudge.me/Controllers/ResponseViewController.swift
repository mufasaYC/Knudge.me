//
//  ResponseTableViewController.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 07/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ResponseViewController: UIViewController {

	var viewModel = ResponseViewModel()
	
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.estimatedRowHeight = 200
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.reloadData()
		
		viewModel.reload.bind(listener: { [unowned self] reload in
			self.tableView.reloadData()
		})
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let d = segue.destination as? ResultViewController else { return }
		d.viewModel.setValues(dict: viewModel.rawDictionary)
	}

}

extension ResponseViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResponseCell
		cell.wordLabel.text = viewModel.word(at: indexPath.row)
		cell.isCorrectLabel.text = viewModel.isCorrect(at: indexPath.row)
		cell.meaningLabel.text = viewModel.solution(at: indexPath.row)
		return cell
	}
	
}
