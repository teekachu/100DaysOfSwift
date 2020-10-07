//
//  GameScene.swift
//  Project 26
//
//  Created by Tee Becker on 10/2/20.
//

import CoreMotion
import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var level = 1
    var player : SKSpriteNode!
    var motionManager: CMMotionManager! // start collecting accelerometer information
    
    var eachPosition: CGPoint!
    
    // For simulator Testing
    var lastTouchPosition: CGPoint?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var isGameOver = false
    
    // MARK: game symbol notes
    //1. load the level from textfile, split by line where each line becomes row of level data in game screen.
    // space - empty
    // x - wall
    // v - vortex
    // s - star
    // f - finish
    
    // MARK: Bitmasks
    
    // categoryBitmask - (defining the type of object for considering collisions) : EVERYNODE to reference in collision or contactBitmask must have a CATEGORY attached.
    
    // collisionBitmask - (what category of object this node should collide with) : Collision without contact - will bounce off eachother but NOT NOTIFIED
    
    // contactTestBitmask - (which collision we want to be notified about) : will NOT bounce off eachother but WILL BE NOTIFIED.
    
    enum CollisionTypes: UInt32 {
        case player = 1
        case wall = 2
        case star = 4
        case vortex = 8
        case finish = 16
    }
    
    override func didMove(to view: SKView) {
        
        // add background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // add Label
        scoreLabel = SKLabelNode(fontNamed: "chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        loadLevel()
        
        // must create player after loading level, else it appears BEHIND the vortex and other level objects.
        createPlayer()
        physicsWorld.gravity = .zero // because player will have ipad almost flat
        
        // instructs CMMotionManager to start collecting updates we can read later
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsWorld.contactDelegate = self
    }
    
    func createPlayer(){
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = -1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.allowsRotation = false // does not turn
        player.physicsBody?.linearDamping = 0.5 // slows down velocity
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.finish.rawValue | CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue  //NOTIFY when player and vortex,star or finish touch.
        addChild(player)
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // assigning nodes
        
        guard let nodeA = contact.bodyA.node else{return}
        guard let nodeB = contact.bodyB.node else{return}
        
        if nodeA == player{
            playerCollided(with: nodeB)
        } else if nodeB == player{
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode){
        
        if node.name == "vortex"{
            player.physicsBody?.isDynamic = false //player gets sucked in and no longer able to move
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {[weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star"{
            node.removeFromParent()
            score += 1
            
        } else if node.name == "finish"{
            // next level
        }
    }
    
    func loadLevel(){
        guard let url = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("unable to locate level(level).txt")}
        
        guard let levelString = try? String(contentsOf: url) else{
            fatalError("unable to load into Strings")
        }
        
        
        let lines = levelString.components(separatedBy: "\n")
        
        //MARK: for-loop to load each
        
        //why reversed
        for (row,line) in lines.reversed().enumerated(){
            for (column,letter) in line.enumerated(){
                
                eachPosition = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x"{
                    // load wall
                    loadWall()
                    
                    //                    let node = SKSpriteNode(imageNamed: "block")
                    //                    node.name = "block"
                    //                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    //                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    //                    node.physicsBody?.isDynamic = false // walls should be fixed and not move
                    //                    node.position = eachPosition
                    //                    addChild(node)
                    
                    
                } else if letter == "v"{
                    // load vortex
                    loadVortex()
                    
                    //                    let node = SKSpriteNode(imageNamed: "vortex")
                    //                    node.name = "vortex"
                    //                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1))) //vortex should rotate for as long as the game last.
                    //                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
                    //                    node.physicsBody?.isDynamic = false // vortex should be fixed and not move
                    //
                    //                    node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                    //                    node.physicsBody?.collisionBitMask = 0 // we don't want it to bounce off eachother
                    //                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue // NOTIFY when player and vortex touch
                    //                    node.position = eachPosition
                    //                    addChild(node)
                    
                    
                } else if letter == "s"{
                    // load  star
                    loadStar()
                    
                    //                    let node = SKSpriteNode(imageNamed: "star")
                    //                    node.name = "star"
                    //
                    //                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
                    //                    node.physicsBody?.isDynamic = false
                    //
                    //                    node.physicsBody?.categoryBitMask = CollisionTypes.star
                    //                        .rawValue
                    //                    node.physicsBody?.collisionBitMask = 0
                    //                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    //                    node.position = eachPosition
                    //                    addChild(node)
                    //
                    
                } else if letter == "f"{
                    // load finish
                    loadFinish()
                    
                    //                    let node = SKSpriteNode(imageNamed: "finish")
                    //                    node.name = "finish"
                    //
                    //                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
                    //                    node.physicsBody?.isDynamic = false
                    //
                    //                    node.physicsBody?.categoryBitMask = CollisionTypes.finish
                    //                        .rawValue
                    //                    node.physicsBody?.collisionBitMask = 0
                    //                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    //                    node.position = eachPosition
                    //                    addChild(node)
                    
                    
                } else if letter == " "{
                    // empty space, do nothing
                    print("emptySpace)")
                    
                } else{
                    print("unable to load: \(letter) to file ")
                    
                }
            }
        }
    }
    
    
    
    func loadWall(){
        
        let node = SKSpriteNode(imageNamed: "block")
        node.name = "block"
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false // walls should be fixed and not move
        node.position = eachPosition
        addChild(node)
    }
    
    func loadVortex(){
        
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1))) //vortex should rotate for as long as the game last.
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false // vortex should be fixed and not move
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.collisionBitMask = 0 // we don't want it to bounce off eachother
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue // NOTIFY when player and vortex touch
        node.position = eachPosition
        addChild(node)
    }
    
    func loadStar(){
        
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star
            .rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.position = eachPosition
        addChild(node)
        
    }
    
    func loadFinish(){
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish
            .rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.position = eachPosition
        addChild(node)
        
    }
    
    
    
    // MARK: simulator testing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        // only keep updating if the game is not over 
        guard isGameOver == false else{return}
        
        // Called before each frame is rendered
        // chekcs to see what the current tilt data is
        
        // MARK: special compiler instructions:  #if targetEnvironment(simulator) / #else / #endif
        // basically if else for the different testing environment ( simulator or actual device)
        // simulator Testing portion:
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition{
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        
        // device Testing portion:
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50) // device on landscape, so x and y need to be flipped.
        }
        
        #endif
    }
    
    
    
    
    
    
    
    
}
