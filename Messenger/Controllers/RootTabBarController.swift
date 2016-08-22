//
//  PrimaryTabBarController.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/17/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

	override func viewDidLoad() {
		let conversationsController = ConversationsController(style: .grouped)
		let recentMessagesNavController = UINavigationController.init(rootViewController: conversationsController)
		recentMessagesNavController.tabBarItem.title = "Recent"
		recentMessagesNavController.tabBarItem.image = UIImage.init(named: "recent")
		
		viewControllers = [recentMessagesNavController,
		                   createDummyControllerWithTitle(title: "Calls", imageName: "calls"),
		                   createDummyControllerWithTitle(title: "Groups", imageName: "groups"),
		                   createDummyControllerWithTitle(title: "People", imageName: "people"),
		                   createDummyControllerWithTitle(title: "Settings", imageName: "settings")]
	}
	
	private func createDummyControllerWithTitle (title: String, imageName: String) -> UINavigationController {
		let viewController = UIViewController()
		let navController =  UINavigationController.init(rootViewController: viewController)
		navController.tabBarItem.title = title
		navController.tabBarItem.image = UIImage.init(named: imageName)
		
		return navController
	}
}
