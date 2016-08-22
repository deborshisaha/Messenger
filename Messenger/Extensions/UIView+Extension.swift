//
//  UIView+Extension.swift
//  Messenger
//
//  Created by Deborshi Saha on 8/17/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

import UIKit

extension UIView {
	
	func addConstraintsWithVisualFormat(format: String, options: NSLayoutFormatOptions, views: UIView...) {
		
		var viewDictionary = [String:UIView] ()
		
		for (index, view) in views.enumerated() {
			let key = "v\(index)"
			viewDictionary[key] = view
			view.translatesAutoresizingMaskIntoConstraints = false
		}
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: nil, views: viewDictionary))
	}
}
