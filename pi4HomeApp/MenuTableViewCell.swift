//
//  MenuTableCellViewTableViewCell.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 08.05.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

	
	@IBOutlet weak var menuImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
		
        // Initialization code
    }

	func configure(menuItem:MenuItem) {
		titleLabel.text = menuItem.title
		menuImageView.image = menuItem.image
	}

}
