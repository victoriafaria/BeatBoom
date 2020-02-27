//
//  Projectile.swift
//  BeatBoom
//
//  Created by Bruno Cardoso Ambrosio on 27/02/20.
//  Copyright © 2020 Victoria Andressa Faria. All rights reserved.
//

import SceneKit

class Projectile: SCNNode {
    
    init(_ node: SCNNode, _ direction: UISwipeGestureRecognizer.Direction = .right) {
        self.node = node
        self.direction = direction
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var node: SCNNode
    var direction: UISwipeGestureRecognizer.Direction
    
    var isInsidePlayzone: Bool = false {
        didSet {
//            outOfPlayzoneTimer()
        }
    }
    
   fileprivate func outOfPlayzoneTimer() {
        if isInsidePlayzone == true {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                self.isInsidePlayzone = false
            }
        }
    }
    
    static func == (lhs:Projectile, rhs:Projectile) -> Bool {
        return lhs.node.isEqual(rhs.node) && lhs.direction == rhs.direction
    }
}
