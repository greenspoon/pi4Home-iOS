//
//  ControlerCollectionViewCell.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 12.05.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

protocol ControlerDelegate {
	func actionTriggered(action: PI4HomeService.PIShutterAction)
}

class ControlerCollectionViewCell: UICollectionViewCell {

	var delegate: ControlerDelegate?
	
	@IBOutlet weak var upArrowButton: UIButton!
	@IBOutlet weak var stopArrowButton: UIButton!
	@IBOutlet weak var downArrowButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func configure(model: PageModel) {
		setButtons(enabled: model.controlsEnabled)
	}
	
	private func setButtons(enabled:Bool) {
		upArrowButton.isEnabled = enabled
		downArrowButton.isEnabled = enabled
		stopArrowButton.isEnabled = enabled
	}
	
	@IBAction func upArrowButtonTapped(_ sender: Any) {
		delegate?.actionTriggered(action: .open)
	}
	
	@IBAction func stopArrowButtonTapped(_ sender: Any) {
		delegate?.actionTriggered(action: .stop)
	}
	
	@IBAction func downArrowButtonTapped(_ sender: Any) {
		delegate?.actionTriggered(action: .close)
	}
	
}
