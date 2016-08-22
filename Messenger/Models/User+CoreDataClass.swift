//
//  User+CoreDataClass.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/16/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject {

	private static var currentUser: User?
	
	public static func getCurrentUser() -> User {
		return currentUser!
	}
	
	public static func setCurrentUser(user: User) {
		
		if currentUser == .none {
			currentUser = user
		}
	}
	
	func isSame(user: User) -> Bool {
		return self.id == user.id
	}
}
