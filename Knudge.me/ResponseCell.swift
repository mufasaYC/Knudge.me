//
//  ResponseCell.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 07/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import UIKit

class ResponseCell: UITableViewCell {

	@IBOutlet weak var isCorrectLabel: UILabel!
	@IBOutlet weak var meaningLabel: UILabel!
	@IBOutlet weak var wordLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
