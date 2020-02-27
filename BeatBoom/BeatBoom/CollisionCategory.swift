//
//  CollisionCategory.swift
//  BeatBoom
//
//  Created by Victoria Andressa S. M. Faria on 20/02/20.
//  Copyright © 2020 Victoria Andressa Faria. All rights reserved.
//

import Foundation

//struct CollisionCategory: OptionSet {
//
//    let rawValue: Int
//    static let projectilesCategory = CollisionCategory(rawValue: 1)
//    static let playZoneCategory = CollisionCategory(rawValue: 4)
//    static let killzoneCategory = CollisionCategory(rawValue: 8)
//}


public struct CollisionCategory  {
    static let none: Int = 0
    static let projectilesCategory: Int =              0b1 // 1
    static let playZoneCategory: Int =               0b10 // 2
    static let killzoneCategory: Int =              0b100 // 4
    static let playerFinger: Int =             0b1000 // 8
//    static let tree2: UInt32 =           0b10000 // 16
//    static let men: UInt32 =            0b100000 //32
//    static let background: UInt32 =    0b1000000 // 64
//    static let ground: UInt32 =       0b10000000 // 128
//    static let killzone: UInt32 =    0b100000000
}
