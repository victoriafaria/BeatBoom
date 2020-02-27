//
//  Projectile.swift
//  BeatBoom
//
//  Created by Bruno Cardoso Ambrosio on 27/02/20.
//  Copyright © 2020 Victoria Andressa Faria. All rights reserved.
//

import SceneKit

class Projectile {
    
    init(_ node: SCNNode, _ direction: UISwipeGestureRecognizer.Direction = .right) {
        self.node = node
        self.direction = direction
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
}
