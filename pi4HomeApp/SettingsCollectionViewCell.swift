//
//  SettingsCollectionViewCell.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 12.05.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var soonLabel: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		
		soonLabel.transform = CGAffineTransform(rotationAngle: -30 * CGFloat.pi / 180)
	}
	
}
