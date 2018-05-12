//
//  MenuItemFactory.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 08.05.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

class MenuItemFactory: Any {

	static let sharedInstance = MenuItemFactory()
	
	fileprivate init() {}
	
	func getMenuItems() -> [MenuItem] {
		let refreshItem = MenuItem(title: "Refresh Connection" , image: #imageLiteral(resourceName: "Compound Path_1"), {
			PI4HomeService.sharedInstance.checkIfAvailable()
		})
		
		let settingsItem = MenuItem(title: "Settings", image: #imageLiteral(resourceName: "Compound Path_2")) {
			
		}
		
		return [refreshItem, settingsItem]
	}
	
}

class MenuItem {
	
	init(title:String, height:CGFloat = 70, image:UIImage = #imageLiteral(resourceName: "point"), _ action:@escaping ()->()) {
		self.title = title
		self.action = action
		self.height = height
		self.image = image
	}
	
	var title:String = ""
	var action:()->()
	var closeMenuAfterAction:Bool = true
	var height:CGFloat = 0
	var image:UIImage = #imageLiteral(resourceName: "point")
}
