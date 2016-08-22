//
//  MessageCell.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/17/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import UIKit

class MessageCell: BaseCell {

	let profileImageView : UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 15
		imageView.layer.masksToBounds = true
		imageView.backgroundColor = UIColor.red
		return imageView
	}()
	
	let messageTextView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.systemFont(ofSize: 16)
		textView.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
		textView.layer.cornerRadius = 15
		textView.layer.masksToBounds = true
		textView.contentInset = UIEdgeInsetsMake(-4, 2, 4, 8)
		textView.isEditable = false
		textView.isScrollEnabled = false
		return textView
	}()
	
	override func setUp() {
		
		selectionStyle = .none
		
		//backgroundColor = UIColor.clear
		addSubview(messageTextView)
		addSubview(profileImageView)
		
		addConstraintsWithVisualFormat(format: "H:|-8-[v0(30)]|", options: NSLayoutFormatOptions(), views: profileImageView)
		addConstraintsWithVisualFormat(format: "V:[v0(30)]|", options: NSLayoutFormatOptions(), views: profileImageView)
	}
	
}

class BaseCell: UITableViewCell {
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setUp()
	}
	
	func setUp() {
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
