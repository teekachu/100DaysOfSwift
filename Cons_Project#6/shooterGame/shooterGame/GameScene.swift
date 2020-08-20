//
//  GameScene.swift
//  shooterGame
//
//  Created by Ting Becker on 8/3/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    var gameTimer: Timer?
    var isGameOver = false
    var whiteGhost: SKSpriteNode!
    var numberOfGhost = 0
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "Haunted")
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = -1
        background.blendMode = .replace
        background.position = CGPoint(x: 1024/2, y: 768/2)
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 10, y: 740)
        gameScore.horizontalAlignmentMode = .left
        //        gameScore.fontSize = 30
        addChild(gameScore)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(Double.random(in: 0.85...1.2)), target: self, selector: #selector(makeGhost), userInfo: nil, repeats: true) //makes 3 ghosts per 1 second with 0.35 second each
    }
    
    @objc func makeGhost(at position: CGPoint){
        whiteGhost = SKSpriteNode(imageNamed: "ghost")
        whiteGhost.name = "whiteGhostNode"
        addChild(whiteGhost)
        numberOfGhost += 1
        
        
        whiteGhost.xScale = CGFloat(Double.random(in: 0.2...0.52))
        whiteGhost.yScale = whiteGhost.xScale
        whiteGhost.position = CGPoint(x: -100, y: Int.random(in: 50...700))
        
        whiteGhost.physicsBody = SKPhysicsBody(texture: whiteGhost.texture!, size: whiteGhost.size)
        whiteGhost.physicsBody?.categoryBitMask = 1
        whiteGhost.physicsBody?.velocity = CGVector(dx: Int.random(in: 200 ... 430), dy: 0)
        whiteGhost.physicsBody?.angularVelocity = 0.03 //angle it will turn when it moves
        whiteGhost.physicsBody?.linearDamping = 0
        whiteGhost.physicsBody?.angularDamping = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes{
            if node.name == "whiteGhostNode" {
                let hideGhost = node
                //add effects
                if let smokeParticle = SKEmitterNode(fileNamed: "smoked.sks"){
                    smokeParticle.position = hideGhost.position
                    addChild(smokeParticle)
                    smokeParticle.advanceSimulationTime(0.1)
                }
                
                hideGhost.removeFromParent()
                print("i hit a ghost")
                score += 1
            } else {
                //do nothing
                return
            }
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        guard let touch = touches.first else{
//            print("I touched the screen")
//            return
//        }
//        
//        let touchLocation = touch.location(in: self)
//        //        let touchNode = nodes(at: touchLocation)
//        if whiteGhost.contains(touchLocation){
//            whiteGhost.removeFromParent()
//            print("killed a ghost")
//        }
//    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children{
            if node.position.x > 1100{
                node.removeFromParent()
            }
        }
        
        if numberOfGhost >= 30{
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.zPosition = 1
            gameOver.blendMode = .replace
            gameOver.position = CGPoint(x: 1024/2, y: 768/2)
            addChild(gameOver)
            
            gameTimer?.invalidate()
        }
        
    }
}
