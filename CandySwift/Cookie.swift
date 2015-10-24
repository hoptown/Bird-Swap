//
//  Cookie.swift
//  CandySwift
//
//  Created by Max on 28/07/14.
//  Copyright (c) 2014 MaxHype. All rights reserved.
//

import SpriteKit

class Cookie: Printable, Hashable {
	var column: Int
	var row: Int
	let cookieType: CookieType
	var sprite: SKSpriteNode?

	init(column: Int, row: Int, cookieType: CookieType) {
		self.column = column
		self.row = row
		self.cookieType = cookieType
	}

	var description: String {
		return "type:\(cookieType) square:(\(column),\(row))"
	}

	var hashValue: Int {
		return row*10 + column
	}
}

enum CookieType: Int, Printable {
	case Unknown = 0, Cookie1, Cookie2, Croissant, Cupcake, Donut, Eclair, Macaroon, Pie, Poptart1, Poptart2, Starcookie1, Starcookie2

	var spriteName: String {
		let spriteNames = [
            "bird01",
            "bird02",
            "bird03",
            "bird04",
            "bird05",
            "bird06",
            "bird07",
            "bird08",
            "bird09",
            "bird10",
            "bird11",
            "bird12"
		]
        
		return spriteNames[rawValue - 1]
	}
	
    //LL
    /*var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }*/
    
	static func random() -> CookieType {
		return CookieType(rawValue: Int(arc4random_uniform(12)) + 1)!
	}
	
	static func random(subset: [Int]) -> CookieType {
		return CookieType(rawValue: subset[Int(arc4random_uniform(UInt32(subset.count)))])!
        //LL fromRaw(subset[Int(arc4random_uniform(UInt32(subset.count)))])!
	}

	var description: String {
		return spriteName
	}
}

func ==(lhs: Cookie, rhs: Cookie) -> Bool {
	return lhs.column == rhs.column && lhs.row == rhs.row
}
