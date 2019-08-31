//
//  PI4HomeService.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 14.04.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

extension Notification.Name {
	
}

class PI4HomeService {

	static let sharedInstance:PI4HomeService = PI4HomeService()
	
//	static let AvailabilityCheckFinishedNotificationName = Notification.Name("AvailabilityCheckFinished")
//	static let AvailabilityCheckStartedNotificationName = Notification.Name("AvailabilityCheckStarted")
//
	static let WillFireRequestNotificationName = Notification.Name("WillFireRequestNotificationName")
	static let DidReceivedResponseNotificationName = Notification.Name("DidReceivedResponseNotification")
	
	let baseURL = URL(string: "http://192.168.2.108:8989")!
	
	enum PIShutterAction:String {
		case open = "/open"
		case close = "/close"
		case stop = "/stop"
	}
	
	typealias RequestCompletion = (_ success:Bool,_ msg:String)->()
	
	typealias Response = (success:Bool, msg:String)
	
	func checkIfAvailable(_ completion: RequestCompletion? = nil ) {
		self.sendGETRequestToRelativeURL(relativeURLPathString: "", completion: completion)
	}
	
	func executeShutterAction(action:PIShutterAction,_ completion:@escaping RequestCompletion) {
		self.sendGETRequestToRelativeURL(relativeURLPathString: action.rawValue, completion: completion)
	}
	
	private func sendGETRequestToRelativeURL(relativeURLPathString:String, completion: RequestCompletion?) {
		let url = baseURL.appendingPathComponent(relativeURLPathString)
		
		NotificationCenter.default.post(name: PI4HomeService.WillFireRequestNotificationName , object: nil)
		
		let concatedCompletion = { (success:Bool, msg:String) in
			completion?(success,msg)
			DispatchQueue.main.async {
				NotificationCenter.default.post(name: PI4HomeService.DidReceivedResponseNotificationName , object: nil, userInfo: ["response": Response(success, msg)])
			}
		}
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			if let error = error {
				concatedCompletion(false,"Ein unbekannter Fehler ist aufgetreten! \(error)")
				return
			}
			
			guard
				let data = data,
				let message = String(data: data,encoding: .utf8)
			else {
				concatedCompletion(false,"Ein unbekannter Fehler ist aufgetreten!")
				return
			}
			
			DispatchQueue.main.async {
				concatedCompletion(true, message)
			}
			
		}.resume()
	}
	
}
