//
//  GameScene.swift
//  Project 26
//
//  Created by Tee Becker on 10/2/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var level = 1
    var player : SKSpriteNode!
    
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
        
        loadLevel()
        
        // must create player after loading level, else it appears BEHIND the vortex and other level objects.
        createPlayer()
        
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
                
                let eachPosition = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x"{
                    // load wall
                    
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = eachPosition
                    node.name = "block"
                    
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic = false // walls should be fixed and not move
                    
                    addChild(node)
                    
                } else if letter == "v"{
                    // load vortex
                    
                    let node = SKSpriteNode(imageNamed: "vortex")
                    node.name = "vortex"
                    node.position = eachPosition
                    
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1))) //vortex should rotate for as long as the game last.
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
                    node.physicsBody?.isDynamic = false // vortex should be fixed and not move
                    
                    node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                    node.physicsBody?.collisionBitMask = 0 // we don't want it to bounce off eachother
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue // NOTIFY when player and vortex touch
                    
                    addChild(node)
                    
                } else if letter == "s"{
                    // load  star
                    
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
                    
                } else if letter == "f"{
                    // load finish
                    
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
                    
                } else if letter == " "{
                    // empty space, do nothing
                    print("emptySpace)")
                    
                } else{
                    print("unable to load: \(letter) to file ")
                    
                }
            }
        }
    }
    
    
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        <#code#>
    //    }
    //
    //    override func update(_ currentTime: TimeInterval) {
    //        // Called before each frame is rendered
    //    }
}



