//
//  Box.swift
//  Knudge.me
//
//  Created by Mustafa Yusuf on 07/01/18.
//  Copyright © 2018 Mustafa Yusuf. All rights reserved.
//

import Foundation

class Box<T> {
	
	typealias Listener = (T) -> Void
	var listener: Listener?
	
	var value: T {
		didSet {
			listener?(value)
		}
	}
	
	init(_ value: T) {
		self.value = value
	}
	
	func bind(listener: Listener?) {
		self.listener = listener
		listener?(value)
	}
	
}
