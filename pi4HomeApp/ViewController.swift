//
//  ViewController.swift
//  pi4HomeApp
//
//  Created by Josef Grinspun on 14.04.18.
//  Copyright © 2018 Biting Bit. All rights reserved.
//

import UIKit

struct PageModel {
	let pageName:String
	var controlsEnabled:Bool
}

class ContainerCellPageFactory {
	
	static let ControlsPageIndex = 0
	static let SettingsPageIndex = 1
	
	static func getPageModels() -> [PageModel] {
		return [PageModel(pageName: "ControllsPage", controlsEnabled: true),
				PageModel(pageName: "SettingsPage", controlsEnabled: true)]
	}
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ControlerDelegate {
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	@IBOutlet weak var upButton: UIButton!
	@IBOutlet weak var downButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var menuButton: UIButton!
	
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var pages = ContainerCellPageFactory.getPageModels()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		pages[ContainerCellPageFactory.ControlsPageIndex].controlsEnabled = false
		activityIndicator.isHidden = true

		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.isPagingEnabled = true
		pageControl.numberOfPages = pages.count
		UIApplication.shared.statusBarStyle = .lightContent
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.showsVerticalScrollIndicator = false
		
		NotificationCenter.default.addObserver(self, selector: #selector(availabilityCheckFinished), name: PI4HomeService.AvailabilityCheckFinishedNotificationName, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(availabilityCheckStarted), name: PI4HomeService.AvailabilityCheckStartedNotificationName, object: nil)
		PI4HomeService.sharedInstance.checkIfAvailable()
	}

	@IBAction func menuButtonTapped(_ sender: Any) {
		let menuViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController")
		menuViewController.modalPresentationStyle = .overCurrentContext
		self.present(menuViewController, animated: false, completion: nil)
	}
	
	//MARK: - CollectionViewDelegate's
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch indexPath.item {
		case ContainerCellPageFactory.ControlsPageIndex:
			let controlPageModel = pages[ContainerCellPageFactory.ControlsPageIndex]
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: controlPageModel.pageName, for: indexPath) as! ControlerCollectionViewCell
			cell.delegate = self
			cell.configure(model: controlPageModel)
			return cell
		case ContainerCellPageFactory.SettingsPageIndex:
			let settingsPageModel = pages[ContainerCellPageFactory.SettingsPageIndex]
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingsPageModel.pageName, for: indexPath) as! SettingsCollectionViewCell
			return cell
		default:
			return UICollectionViewCell()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	//MARK: - ScrollViewDelegate
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let xOffset = targetContentOffset.pointee.x
		pageControl.currentPage = Int(xOffset / collectionView.frame.width)
	}
	
	//MARK: - Notification Handling
	
	@objc private func availabilityCheckStarted(notification: Notification) {
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		infoLabel.isHidden = true
	}
	
	@objc private func availabilityCheckFinished(notification: Notification) {
		guard let response = notification.userInfo?["response"] as? PI4HomeService.Response else {return}
		
		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
		infoLabel.isHidden = false
		if (response.success) {
			pages[ContainerCellPageFactory.ControlsPageIndex].controlsEnabled = true
			collectionView.reloadData()
		}
		infoLabel.text = response.msg
	}
	
	func actionTriggered(action: PI4HomeService.PIShutterAction) {
		weak var weakSelf = self
		PI4HomeService.sharedInstance.executeShutterAction(action: action) { (success, msg) in
			weakSelf?.infoLabel.text = msg
		}
	}

	
}
