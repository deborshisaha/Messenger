//
//  ConversationsController.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/14/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import UIKit
import CoreData

class ConversationsController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	private let cellId = "cellId"
	private var conversations:[Conversation]?
	
	var blockOperations = [BlockOperation]()

	lazy var fetchResultsController: NSFetchedResultsController<Conversation> = {
		
		let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key:"lastMessage.createdTime", ascending:false)]
		fetchRequest.predicate = NSPredicate.init(format: "lastMessage != nil")
		let delegate = UIApplication.shared.delegate as! AppDelegate
		let context = delegate.managedObjectContext
		let frc = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self
		return frc
	}()
	
	private  func clearData() {
		let delegate = UIApplication.shared.delegate as? AppDelegate
		
		if let context = delegate?.managedObjectContext {
			
			do {

				let entityNames = ["Conversation", "Message", "User"]

				for entityName in entityNames {
					let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

					let objects = try(context.fetch(fetchRequest))

					for object in objects {
						context.delete(object)
					}
				}
				
				try(context.save())

			} catch let err {
				print(err)
			}
		}
	}

	private func logInUser() {
		
		let delegate = UIApplication.shared.delegate as? AppDelegate
		
		if let context = delegate?.managedObjectContext {
			let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
			user.name = "Grizzly Bear"
			user.profileImageURL = "grizzly_bear"
			user.id = NSUUID().uuidString
			User.setCurrentUser(user: user)
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		if type == .insert {
			
			blockOperations.append(BlockOperation.init(block: {
				// Block operation
				self.tableView.insertRows(at: [newIndexPath!], with: .bottom)
			}))
		} else if type == .move {
			self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
			self.tableView.reloadRows(at: [newIndexPath!], with: .none)
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
		
		for operation in self.blockOperations {
			operation.start()
		}
		
		tableView.endUpdates()
		
		let count = self.fetchResultsController.sections?[0].objects?.count
		let indexPath:IndexPath = IndexPath.init(row: count! - 1, section: 0)
		self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.none, animated: true)
	}

	private func setupData() {

		clearData()

		logInUser()

		let delegate = UIApplication.shared.delegate as? AppDelegate
		
		if let context = delegate?.managedObjectContext {
			let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
			user.name = "Dolphin"
			user.profileImageURL = "dolphin"
			user.id = NSUUID().uuidString
			
			let user2 = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
			user2.name = "Killer Whale"
			user2.profileImageURL = "killer_whale"
			user2.id = NSUUID().uuidString

			let conversation = createConversationWith(user: user, context: context)
			conversation.addToMessages(createMessageWith(text: "Pellentesque habitant morbi?", user: user, conversation: conversation, minutesAgo: 3, context: context))
			conversation.addToMessages(createMessageWith(text: "Nam sollicitudin tellus quis interdum hendrerit. Pellentesque habitant morbi tristique senectus et netus.", user: user, conversation: conversation, minutesAgo: 2, context: context))
			
			let conversation2 = createConversationWith(user: user2, context: context)
			conversation2.addToMessages(createMessageWith(text: "Nulla facilisi!!??", user: user2, conversation: conversation2, minutesAgo: 60 * 24 * 10, context: context))
			conversation2.addToMessages(createMessageWith(text: "Morbi sodales et diam vitae consequat!", user: user2, conversation: conversation2, minutesAgo: 60 * 24 * 9, context: context))
			conversation2.addToMessages(createMessageWith(text: "Sed ligula tellus, efficitur ut risus id, imperdiet lacinia eros. Phasellus in turpis lorem. Sed posuere non lacus nec convallis. Morbi sodales et diam vitae consequat. Praesent a aliquam tellus. Nulla facilisi. Quisque sit amet ante odio. Pellentesque eget luctus orci. Proin leo neque, placerat eu elementum eget, feugiat sed.", user: user2, conversation: conversation2, minutesAgo: 60 * 24 * 8, context: context))
			
			conversation2.addToMessages(createMessageWith(text: "Thanks :)", user: User.getCurrentUser(), conversation: conversation2, minutesAgo: 60 * 24 * 7.5, context: context))
			
			do {
				try(context.save())
			} catch let err {
				print(err)
			}
		}
	}
	
	private func createConversationWith(user: User, context: NSManagedObjectContext) -> Conversation {
		let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as! Conversation
		conversation.friend = user
		conversation.id = NSUUID().uuidString
		
		return conversation
	}

	private func createMessageWith(text: String, user: User, conversation: Conversation, minutesAgo: Double, context: NSManagedObjectContext) -> Message {
		let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
		message.text = text
		message.conversation = conversation
		message.createdTime = NSDate().addingTimeInterval(-minutesAgo * 60)
		message.seen = true
		message.owner = user
		message.id = NSUUID().uuidString
		conversation.lastMessage = message

		return message
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		do {
			try fetchResultsController.performFetch()
		} catch let err {
			print (err)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupData()
		
		self.title = "Recent"

		// Do any additional setup after loading the view, typically from a nib.
		tableView?.register(ConversationCell.self, forCellReuseIdentifier: cellId)
		
		tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
		tableView.separatorInset = UIEdgeInsetsMake(0, self.view.frame.width, 0, 0)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ConversationCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier:cellId) as! ConversationCell

		let conversation = fetchResultsController.object(at: indexPath)
		
		if let message = conversation.lastMessage {
			
			cell.friendsNameLabel.text = message.conversation?.friend?.name
			
			if User.getCurrentUser().isSame(user: message.owner!) {
				cell.messageLabel.text = String.init(format: "You: \(message.text!)")
			} else {
				cell.messageLabel.text = message.text
			}
				
			cell.profileImageView.image = UIImage(named: (message.conversation?.friend?.profileImageURL!)!)
			cell.messageStatusView.image = UIImage(named: (message.conversation?.friend?.profileImageURL!)!)

			if let date = message.createdTime {
				
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "h:mm a"
				
				let secondsInDay: Double = 60*60*24
				
				let timeElapsed = NSDate().timeIntervalSince(date as Date)
				
				if timeElapsed > 7*secondsInDay {
					dateFormatter.dateFormat = "MM/dd/yy"
				} else if timeElapsed > secondsInDay {
					dateFormatter.dateFormat = "EEE"
				}
				
				cell.timeLabel.text = dateFormatter.string(from: date as Date)
			}
		}
		
		return cell
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if let count = fetchResultsController.sections?[section].objects?.count {
			return count
		}
		
		return 0
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 90
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let conversation = fetchResultsController.object(at: indexPath)
		
		let chatRoomController = ChatRoomController()
		chatRoomController.conversation = conversation
		navigationController?.pushViewController(chatRoomController, animated: true)
	}
}
