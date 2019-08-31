//
//  MenuViewController.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 08.05.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let menuItems = MenuItemFactory.sharedInstance.getMenuItems()
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var transparentView: UIView!
	@IBOutlet weak var menuMainView: UIView!
	@IBOutlet weak var versionLabel: UILabel!
	
	fileprivate let animationDuration = 0.3
	
	override func viewDidLoad() {
        super.viewDidLoad()
		transparentView.alpha = 0
		menuMainView.transform = CGAffineTransform(translationX: -self.menuMainView.frame.width, y: 0)
		tableView.dataSource = self
		tableView.delegate = self
		transparentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transparentViewTapped)))
		view.bringSubviewToFront(menuMainView)
		
		versionLabel.text = "Version \(Bundle.main.versionString())"
    }
	
	override func viewDidAppear(_ animated: Bool) {
		UIView.animate(withDuration: animationDuration, animations: {
			self.transparentView.alpha = 0.6
			self.menuMainView.transform = CGAffineTransform.identity
			self.menuMainView.layer.shadowColor = UIColor.black.cgColor
			self.menuMainView.layer.shadowRadius = 25;
			self.menuMainView.layer.shadowOffset = CGSize(width: 10, height: 20);
			self.menuMainView.layer.shadowOpacity = 0.6;
		})
	}
	
	
	@objc func transparentViewTapped() {
		self.dismiss(animated: true)
	}
	
	override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
		guard flag == true else {
			super.dismiss(animated: false, completion: completion)
			return
		}
		UIView.animate(withDuration: animationDuration, animations: {
			self.transparentView.alpha = 0
			self.menuMainView.transform = CGAffineTransform(translationX: -self.menuMainView.frame.width, y: 0)
			self.menuMainView.layer.shadowOpacity = 0.0;
		}) { (success) in
			self.dismiss(animated: false, completion: nil)
		}
	}
	
	//MARK: - TableView DataSource

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 10
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return menuItems.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuTableViewCell {
			cell.configure(menuItem: menuItems[indexPath.section])
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let currentMenuItem = menuItems[indexPath.section]
		currentMenuItem.action()
		if currentMenuItem.closeMenuAfterAction {
			self.dismiss(animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return menuItems[indexPath.item].height
	}

}
