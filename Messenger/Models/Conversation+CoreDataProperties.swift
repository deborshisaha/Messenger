//
//  Conversation+CoreDataProperties.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/21/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation");
    }

    @NSManaged public var id: String?
    @NSManaged public var friend: User?
    @NSManaged public var messages: NSSet?
    @NSManaged public var lastMessage: Message?

}

// MARK: Generated accessors for messages
extension Conversation {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
