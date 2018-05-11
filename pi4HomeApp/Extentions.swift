//
//  Extentions.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 11.05.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

extension Bundle {
	func versionString() -> String {
		if let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
			return versionString
		}
		
		return "--"
	}
}

