//
//  Projectile.swift
//  BeatBoom
//
//  Created by Bruno Cardoso Ambrosio on 27/02/20.
//  Copyright © 2020 Victoria Andressa Faria. All rights reserved.
//

import SceneKit

class Projectile: SCNNode {
    
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
    func addAnimation(movement: SCNAction) {
        //        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5.0)
        let hoverUp = SCNAction.moveBy(x: 0, y: 0, z: 0.05, duration: 1)
        let hoverDown = SCNAction.moveBy(x: 0, y: 0, z: -0.05, duration: 1)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let moveAndHover = SCNAction.group([movement,hoverSequence])
        let repeatForever = SCNAction.repeatForever(moveAndHover)
        node.runAction(repeatForever)
    }
    
    init(_ node: SCNNode, _ direction: UISwipeGestureRecognizer.Direction = .right) {
        self.node = node
        self.direction = direction
        super.init()
        genMaterial()
    }
    
    fileprivate func genMaterial() {
        let newMaterial = SCNMaterial()
        switch direction {
        case .right:
            newMaterial.diffuse.contents = UIColor.red
            break
        case .left:
            newMaterial.diffuse.contents = UIColor.green
            break
        case .up:
            newMaterial.diffuse.contents = UIColor.yellow
            break
        case .down:
            newMaterial.diffuse.contents = UIColor.blue
            break
        default:
            break
        }
        node.geometry?.materials = [newMaterial]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func == (lhs:Projectile, rhs:Projectile) -> Bool {
        return lhs.node.isEqual(rhs.node) && lhs.direction == rhs.direction
    }
    
}
