//
//  PI4HomeService.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 14.04.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSH

extension Notification.Name {
	
}

class PI4HomeService {

	static let sharedInstance:PI4HomeService = PI4HomeService()
	
	static let AvailabilityCheckFinishedNotificationName = Notification.Name("AvailabilityCheckFinished")
	static let AvailabilityCheckStartedNotificationName = Notification.Name("AvailabilityCheckStarted")
	let baseURL = URL(string: "http://192.168.2.108:8989")!
	
	enum PIShutterAction:String {
		case open = "/open"
		case close = "/close"
		case stop = "/stop"
	}
	
	typealias RequestCompletion = (Bool,String)->()
	
	typealias Response = (success:Bool, msg:String)
	
	func checkIfAvailable() {
		NotificationCenter.default.post(name: PI4HomeService.AvailabilityCheckStartedNotificationName , object: nil)
		self.sendGETRequestToRelativeURL(relativeURLPathString: "", completion: { (success,msg) in
			DispatchQueue.main.async {
				
				NotificationCenter.default.post(name: PI4HomeService.AvailabilityCheckFinishedNotificationName , object: nil, userInfo: ["response": Response(success, msg)])
			}
		})
	}
	
	func executeShutterAction(action:PIShutterAction,_ completion:@escaping RequestCompletion) {
		self.sendGETRequestToRelativeURL(relativeURLPathString: action.rawValue, completion: completion)
	}
	
	func sendGETRequestToRelativeURL(relativeURLPathString:String, completion:@escaping RequestCompletion) {
		let url = baseURL.appendingPathComponent(relativeURLPathString)
		
		Alamofire.request(url).responseString { (responseData) in
			DispatchQueue.main.async {
				if let value = responseData.value {
					completion(true,value)
				} else {
					guard let errorMessage = responseData.error?.localizedDescription else {
						completion(false,"Ein unbekannter Fehler ist aufgetreten!")
						return
					}
					
					completion(false,errorMessage)
				}
			}
			
		}
	}
	
}
