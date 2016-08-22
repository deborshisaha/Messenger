//
//  ConversationCell.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/15/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import UIKit

class ConversationCell : UITableViewCell {
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: true)
		backgroundColor = (isHighlighted ? UIColor.init(red: 0, green: 134/255, blue: 249/255, alpha: 1): UIColor.white)
		friendsNameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
		messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.gray
		timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.gray
	}
	
	// Profile image View
	let profileImageView : UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = 30
		return imageView
	}()
	
	// Message status
	let messageStatusView : UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = 7
		return imageView
	}()
	
	let containerView : UIView = {
		let view = UIView()
		return view
	}()
	
	let friendsNameLabel : UILabel = {
		let label = UILabel()
		label.text = "Deborshi Saha"
		label.font = UIFont.systemFont(ofSize: 16.0)
		return label
	}()
	
	let messageLabel : UILabel = {
		let label = UILabel()
		label.text = "These app should look fantastic. Let's hope we can build one"
		label.textColor = UIColor.gray
		label.font = UIFont.systemFont(ofSize: 14)
		return label
	}()
	
	let timeLabel : UILabel = {
		let label = UILabel()
		label.text = "10:10 am"
		label.textColor = UIColor.gray
		label.font = UIFont.systemFont(ofSize: 14)
		label.textAlignment = .right
		return label
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		// Set up the view
		setup()
		
		
	}
	
	func setup () {
		profileImageView.image = UIImage(named: "placeholder")
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		
		// Add the profile image view
		addSubview(profileImageView)
		
		// Add the container
		addSubview(containerView)
		
		addConstraintsWithVisualFormat(format:"H:|-16-[v0(60)]-16-[v1]-16-|", options: NSLayoutFormatOptions(), views: profileImageView, containerView)
		addConstraintsWithVisualFormat(format:"V:[v0(60)]", options: NSLayoutFormatOptions(), views: profileImageView)
		addConstraintsWithVisualFormat(format:"V:[v0(42)]", options: NSLayoutFormatOptions(), views: containerView)
		
		addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
		
		setupContainerView()
		
		selectionStyle = .none
	}
	
	func setupContainerView () {
		
		containerView.addSubview(friendsNameLabel)
		containerView.addSubview(timeLabel)
		containerView.addSubview(messageLabel)
		containerView.addSubview(messageStatusView)
		
		messageStatusView.image = UIImage(named:"placeholder")
		
		containerView.addConstraintsWithVisualFormat(format: "H:|[v0]-4-[v1(80)]|", options: [.alignAllCenterY], views: friendsNameLabel, timeLabel)
		containerView.addConstraintsWithVisualFormat(format: "H:|[v0]-4-[v1(80)]|", options:  NSLayoutFormatOptions(), views: friendsNameLabel, timeLabel)
		containerView.addConstraintsWithVisualFormat(format: "H:|[v0]-8-[v1(14)]|", options: [.alignAllCenterY], views: messageLabel, messageStatusView)
		containerView.addConstraintsWithVisualFormat(format: "V:|[v0]-[v1(16)]|", options: NSLayoutFormatOptions(), views: friendsNameLabel, messageLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
