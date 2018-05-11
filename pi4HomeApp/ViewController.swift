//
//  ViewController.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 14.04.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var upButton: UIButton!
	@IBOutlet weak var downButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var menuButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setButtons(enabled: false)
		
		UIApplication.shared.statusBarStyle = .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		weak var weakSelf = self
		PI4HomeService.sharedInstance.isAvailable { (success, value) in
			if (success) {
				weakSelf?.setButtons(enabled: true)
			}
			weakSelf?.infoLabel.text = value
		}
	}

	func setButtons(enabled:Bool) {
		upButton.isEnabled = enabled
		downButton.isEnabled = enabled
		stopButton.isEnabled = enabled
	}
	
	@IBAction func upButtonTapped(_ sender: Any) {
		weak var weakSelf = self
		PI4HomeService.sharedInstance.executeShutterAction(action: .open) { (success, msg) in
			weakSelf?.infoLabel.text = msg
		}
	}
	
	@IBAction func stopButtonTapped(_ sender: Any) {
		weak var weakSelf = self
		PI4HomeService.sharedInstance.executeShutterAction(action: .stop) { (success, msg) in
			weakSelf?.infoLabel.text = msg
		}
	}
	
	@IBAction func downButtonTapped(_ sender: Any) {
		weak var weakSelf = self
		PI4HomeService.sharedInstance.executeShutterAction(action: .close) { (success, msg) in
			weakSelf?.infoLabel.text = msg
		}
	}

	@IBAction func menuButtonTapped(_ sender: Any) {
		let menuViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController")
		menuViewController.modalPresentationStyle = .overCurrentContext
		self.present(menuViewController, animated: false, completion: nil)
	}
}
