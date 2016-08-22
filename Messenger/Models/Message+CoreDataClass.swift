//
//  Message+CoreDataClass.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/17/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import Foundation
import CoreData


public class Message: NSManagedObject {

	static func create(_ context:NSManagedObjectContext )-> Message {
		let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
		return message
	}
}
