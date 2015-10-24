//
//  Swap.swift
//  CandySwift
//
//  Created by Max on 28/07/14.
//  Copyright (c) 2014 MaxHype. All rights reserved.
//

class Swap: Printable, Hashable {
	var cookieA: Cookie
	var cookieB: Cookie

	init(cookieA: Cookie, cookieB: Cookie) {
		self.cookieA = cookieA
		self.cookieB = cookieB
	}

	var description: String {
		return "swap \(cookieA) with \(cookieB)"
	}

	var hashValue: Int {
		return cookieA.hashValue ^ cookieB.hashValue
	}
}

func ==(lhs: Swap, rhs: Swap) -> Bool {
	return (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB) ||
				 (lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
}
