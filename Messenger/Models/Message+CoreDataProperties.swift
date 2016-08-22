//
//  Message+CoreDataProperties.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/17/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import Foundation
import CoreData

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var createdTime: NSDate?
    @NSManaged public var seen: Bool
    @NSManaged public var text: String?
    @NSManaged public var id: String?
    @NSManaged public var conversation: Conversation?
    @NSManaged public var owner: User?

}
