//
//  ControlerCollectionViewCell.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 12.05.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

protocol ControllerCellDelegate {
	func actionTriggered(action: PI4HomeService.PIShutterAction)
}

class ControlerCollectionViewCell: UICollectionViewCell {

	var delegate: ControllerCellDelegate?
	
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
		self.isUserInteractionEnabled = enabled
		[upArrowButton, downArrowButton, stopArrowButton].forEach{$0?.alpha = enabled ? 1.0 : 0.5 }
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
