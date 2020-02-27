//
//  ViewController.swift
//  BeatBoom
//
//  Created by Victoria Andressa S. M. Faria on 20/02/20.
//  Copyright © 2020 Victoria Andressa Faria. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SpriteKit


class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func swipeHandler(_ sender: Any) {
        guard let gestureRecognizer = sender as? UISwipeGestureRecognizer else {return}
        var projectiles: [Projectile] = []
        spawnPoints.forEach { (spawnPoint) in
            projectiles.append(contentsOf:  spawnPoint.childNodes.compactMap { (node) -> Projectile? in
                return Projectile(node)
            })
        }
        projectiles.forEach { (element) in
            print("direction: \(element.direction) \n swipeDirection: \(gestureRecognizer.direction)  \n  isInPlayzone: \(element.isInsidePlayzone)")
            if element.direction == gestureRecognizer.direction {
                element.node.removeFromParentNode()
            }
        }
        
//        switch gestureRecognizer.direction {
//        case .right:
//
//            print("swipe right")
//            break
//        case .left:
//            projectiles.forEach { (element) in
//                if element.direction == .left {
//                    element.node.removeFromParentNode()
//                }
//            }
//            print("swipe left")
//            break
//        case .up:
//            projectiles.forEach { (element) in
//                if element.direction == .up {
//                    element.node.removeFromParentNode()
//                }
//            }
//            print("swipe up")
//            break
//        case .down:
//            projectiles.forEach { (element) in
//                if element.direction == .down {
//                    element.node.removeFromParentNode()
//                }
//            }
//            print("swipe down")
//            break
//        default:
//            break
//        }
    }
    
    var spawnPoints: [SCNNode] = []
    var projectiles: [SCNNode] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.scene = setupGame()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            self.pushProjectile()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupGame() -> SCNScene {
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/world.scn")!
        
        scene.physicsWorld.contactDelegate = self
        guard let spawnWall = scene.rootNode.childNode(withName: "spawnWall reference", recursively: false) else { fatalError("SPAWN WALL NÃO ENCONTRADA") }
        spawnPoints = (spawnWall.childNodes.flatMap { (node) -> [SCNNode] in
            return node.childNodes
        })
        
        //        let hud = SKScene(fileNamed: "HUD.sks")
        //        sceneView.overlaySKScene = hud
        setupProjectiles()
        
        return scene
    }
    
    private func setupProjectiles() {
        if let squareScene = SCNScene(named: "art.scnassets/Projectiles/square.scn"),
            let square =  squareScene.rootNode.childNode(withName: "square", recursively: true){
            
            projectiles.append(square)
        }
        
        if let sphereScene = SCNScene(named: "art.scnassets/Projectiles/sphere.scn"),
            let sphere =  sphereScene.rootNode.childNode(withName: "sphere", recursively: true){
            projectiles.append(sphere)
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        var collisionType = 0
        var objectA: SCNNode! // projectiles
        var objectB: SCNNode! // playzone and killzone
        
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if nodeA.physicsBody?.categoryBitMask == CollisionCategory.projectilesCategory
            && nodeB.physicsBody?.categoryBitMask == CollisionCategory.killzoneCategory {
            objectA = nodeA
            collisionType = 1
        } else if nodeB.physicsBody?.categoryBitMask == CollisionCategory.projectilesCategory
            && nodeA.physicsBody?.categoryBitMask == CollisionCategory.killzoneCategory {
            objectA = nodeB
            collisionType = 1
        }else if nodeA.physicsBody?.categoryBitMask == CollisionCategory.projectilesCategory
            && nodeB.physicsBody?.categoryBitMask == CollisionCategory.playZoneCategory {
            objectA = nodeA
            collisionType = 2
        } else if nodeB.physicsBody?.categoryBitMask == CollisionCategory.projectilesCategory
            && nodeA.physicsBody?.categoryBitMask == CollisionCategory.playZoneCategory {
            objectA = nodeB
            collisionType = 2
        }
        
        switch collisionType {
        case 1:
            objectA.removeFromParentNode()
            break
        case 2:
            guard let projectile = objectA as? Projectile else {return}
            projectile.isInsidePlayzone = true
            break
        default:
            break
        }
    }
    
    func pushProjectile() {
        let spawnPointsCount = spawnPoints.count
        let chooseSpawnPointIndex = Int.random(in: 0..<spawnPointsCount)
        let spawnPoint = spawnPoints[chooseSpawnPointIndex]
        
        let projectile = createProjectile()
        
        // recuperando o nó da killzone no mundo
        guard let killzone = sceneView.scene.rootNode.childNode(withName: "killzone reference", recursively: false)  else { return }
        projectile.node.worldPosition = killzone.worldPosition
        
        spawnPoint.addChildNode(projectile.node)
        
        let velocity = killzone.position.z*1.5
        
        let nodeDirection = SCNVector3(killzone.position.x, killzone.position.y, velocity)
        projectile.node.physicsBody?.applyForce(nodeDirection, asImpulse: true)
        
        
        
    }
    
    func createProjectile() -> Projectile  {
        
        let node = projectiles[Int.random(in: 0..<projectiles.count)].clone()
        node.scale = SCNVector3(0.5, 0.5, 0.5)
        node.name = "projectile"
        
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        
        node.physicsBody?.categoryBitMask = CollisionCategory.projectilesCategory
        node.physicsBody?.contactTestBitMask = CollisionCategory.playZoneCategory | CollisionCategory.killzoneCategory
        node.physicsBody?.collisionBitMask = 0
        let projectile = Projectile(node)
        
        return projectile
    }
    
    
}
