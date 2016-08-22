//
//  ChatRoomController.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/17/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import UIKit
import CoreData

class ChatRoomController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

	private let cellId = "cellId"
	
	lazy var sendButton: UIButton = {
		let button = UIButton()
		button.setTitle("Send", for: UIControlState.normal)
		button.setTitleColor(UIColor.init(red: 0, green: 137/255, blue: 249/255, alpha: 1), for: UIControlState.normal)
		button.setTitleColor(UIColor.init(red: 0, green: 137/255, blue: 249/255, alpha: 0.5), for: UIControlState.highlighted)
		button.addTarget(self, action: #selector(onSendButtonClick), for: UIControlEvents.touchUpInside)
		return button
	}()
	
	func onSendButtonClick() {
		
		let delegate = UIApplication.shared.delegate as? AppDelegate
		
		if let context = delegate?.managedObjectContext {
			let message = Message.create(context)
			message.createdTime = NSDate()
			message.text = inputTextField.text
			message.conversation = self.conversation
			message.owner = User.getCurrentUser()
			self.conversation?.lastMessage = message

			do {
				try(context.save())
				self.inputTextField.text = nil
			} catch let err {
				print(err)
			}
		}
	}
	
	func onReceiveMessage() {
		
		let delegate = UIApplication.shared.delegate as? AppDelegate
		
		if let context = delegate?.managedObjectContext {
			let message = Message.create(context)
			message.createdTime = NSDate()
			message.text = "123"
			message.conversation = self.conversation
			message.owner = self.conversation?.friend
			
			let message1 = Message.create(context)
			message1.createdTime = NSDate()
			message1.text = "345"
			message1.conversation = self.conversation
			message1.owner = self.conversation?.friend
			
			self.conversation?.lastMessage = message1

			do {
				try(context.save())
			} catch let err {
				print(err)
			}
		}
	}
	
	var blockOperations = [BlockOperation]()
	
	private let inputTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Type here..."
		textField.textColor = UIColor.darkGray
		textField.backgroundColor = UIColor.white

		return textField
	}()
	
	lazy var fetchResultsController: NSFetchedResultsController<Message> = {
		
		let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key:"createdTime", ascending:true)]
		fetchRequest.predicate = NSPredicate.init(format: "conversation.id = %@", self.conversation!.id!)
		let delegate = UIApplication.shared.delegate as! AppDelegate
		let context = delegate.managedObjectContext
		let frc = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self
		return frc
	}()

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		if type == .insert {
			
			blockOperations.append(BlockOperation.init(block: {
				// Block operation
				self.tableView.insertRows(at: [newIndexPath!], with: .bottom)
			}))
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

	private let tableView: UITableView = {
		let tableView = UITableView(frame: CGRect.zero, style: .grouped)
		return tableView
	}()
	
	private let sendMessageContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		return view
	}()
	
	private var sendMessageViewBottomConstraint: NSLayoutConstraint?
	private var tableViewBottomConstraint: NSLayoutConstraint?
	private let sendMessageViewHeight:CGFloat = 40
	private let textSize:CGFloat = 16
	private let cornerRadius:CGFloat = 15

	private func setupSendMessageView () {
		sendMessageContainerView.addSubview(inputTextField)
		sendMessageContainerView.addSubview(sendButton)
		
		sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: textSize)
		
		sendMessageContainerView.addConstraintsWithVisualFormat(format: "H:|-8-[v0]-4-[v1]-8-|", options: NSLayoutFormatOptions(), views: inputTextField, sendButton)
		sendMessageContainerView.addConstraintsWithVisualFormat(format: "V:|-1-[v0]|", options: NSLayoutFormatOptions(), views: inputTextField)
		sendMessageContainerView.addConstraintsWithVisualFormat(format: "V:|-1-[v0]|", options: NSLayoutFormatOptions(), views: sendButton)
	}
	
	//var messages: [Message]?
	
	var conversation: Conversation? {
		didSet {
			navigationItem.title = conversation?.friend?.name
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		tabBarController?.tabBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(true)
		tabBarController?.tabBar.isHidden = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		do {
			try fetchResultsController.performFetch()
			print (fetchResultsController.sections?[0].objects?.count)
		} catch  let err {
			print (err)
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(onReceiveMessage))
		
		view.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorColor = UIColor.clear
		tableView.backgroundColor = UIColor.white
		tableView.contentInset = UIEdgeInsetsMake(-35, 0, -60, 0)
		tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
		tableView.estimatedRowHeight = 100
		
		tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -50, 0)
		
		view.addSubview(tableView)
		view.addSubview(sendMessageContainerView)
		
		view.addConstraintsWithVisualFormat(format: "H:|[v0]|", options: NSLayoutFormatOptions(), views: tableView)
		view.addConstraintsWithVisualFormat(format: "V:|[v0]", options: NSLayoutFormatOptions(), views: tableView)
		
		view.addConstraintsWithVisualFormat(format: "H:|[v0]|", options: NSLayoutFormatOptions(), views: sendMessageContainerView)
		view.addConstraintsWithVisualFormat(format: "V:[v0(\(sendMessageViewHeight))]", options: NSLayoutFormatOptions(), views: sendMessageContainerView)
		
		sendMessageViewBottomConstraint = NSLayoutConstraint(item: sendMessageContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(sendMessageViewBottomConstraint!)
		
		tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -(sendMessageViewHeight + 1))
		view.addConstraint(tableViewBottomConstraint!)
		
		view.bringSubview(toFront: sendMessageContainerView)
		
		setupSendMessageView()
		
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	func handleKeyboardNotification(notification: NSNotification) {
		
		if let userInfo = notification.userInfo {
			let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.cgRectValue
			let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
			
			let animationDuration = ((userInfo[UIKeyboardAnimationDurationUserInfoKey]) as! NSNumber).floatValue
			let animationOptions = ((userInfo[UIKeyboardAnimationCurveUserInfoKey]) as! NSNumber).uintValue
			
			self.sendMessageViewBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
			self.tableViewBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height-(sendMessageViewHeight + 1) : -(sendMessageViewHeight + 1)
			
			UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0,
			               options: UIViewAnimationOptions(rawValue: animationOptions),
			               animations: {
				self.view.layoutIfNeeded()
				}, completion: { (complete) in
				
					let count = self.fetchResultsController.sections?[0].objects?.count
					let indexPath:IndexPath = IndexPath.init(row: count! - 1, section: 0)
					self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.none, animated: true)
			})
		}
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let count = fetchResultsController.sections?[0].objects?.count {
			return count
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
		
		let message = fetchResultsController.object(at: indexPath)

		if let messageText = message.text {
			cell.messageTextView.text = messageText
			let frame = estimatedFrame(text: messageText)
			
			let width = frame.width < 12 ? 15 : frame.width
			let height = ((frame.height + 8) < (2 * cornerRadius) ) ? frame.height + ((2 * cornerRadius) - (frame.height + 8)): frame.height

			if (message.owner?.isSame(user: User.getCurrentUser()))! {
				
				// outgoing
				cell.messageTextView.backgroundColor = UIColor.init(red: 0, green: 137/255, blue: 249/255, alpha: 1)
				cell.messageTextView.textColor = UIColor.white
				cell.profileImageView.isHidden = true
				cell.messageTextView.frame = CGRect.init(x: view.frame.width - width - 16 - 8, y: 8, width: width + 16, height: height + 8)
			} else {
				
				// Incoming
				cell.profileImageView.isHidden = false
				cell.profileImageView.image = UIImage.init(named: (message.owner?.profileImageURL)!)
				cell.messageTextView.textColor = UIColor.black
				cell.messageTextView.frame = CGRect.init(x: 46, y: 8, width: frame.width + 16, height: height + 8)
			}
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let message = fetchResultsController.object(at: indexPath)

		if let text = message.text {
			return (estimatedFrame(text: text).height + 16)
		}
		
		return 0
	}
	
	private func estimatedFrame(text: String) -> CGRect {
		let size = CGSize.init(width: 260, height: 1000)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: textSize)], context: nil)
		return estimatedFrame
	}
}
