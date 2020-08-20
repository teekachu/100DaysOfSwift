//
//  GameScene.swift
//  Proj17
//
//  Created by Ting Becker on 7/29/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0{
        didSet{
            scoreLabel.text = "Score:\(timeInterval)"
        }
    }
    let possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var gameTimer: Timer?
    var timeInterval:Double = 1
    var enemyAmount = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield.sks")
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        //        player = SKSpriteNode(imageNamed: "player")
        //        player.position = CGPoint(x: 100, y: 384)
        //        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        //        player.physicsBody?.contactTestBitMask = 1
        //        addChild(player)
        
        addPlayer()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.color = .white
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0) // SPACE doesn't have gravity
        physicsWorld.contactDelegate = self
        
        //timer is responsible for running code after period of time pass, either once or repeatedly
//        gameTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    func addPlayer(){
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
    }
    
    @objc func createEnemy(){
        
        guard let enemy = possibleEnemies.randomElement() else {return}
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        enemyAmount += 1
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        //Linear Damping controls how much the Physics Body or Constraint resists translation
        //Angular Damping controls how much they resist rotating.
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        if enemyAmount % 20 == 0 {
            timeInterval -= 0.1
            gameTimer?.invalidate()
            
            gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
        
        if isGameOver == true{
            sprite.removeFromParent()
            
            let KO = SKSpriteNode(imageNamed: "gameOver")
            KO.position = CGPoint(x: 512, y: 384 )
            addChild(KO)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children{
            if node.position.x < -300{
                node.removeFromParent()
            }
        }
        if !isGameOver{
            score += 1
        }
        
        
    }
    
    //touchesMoved is called when an existing touch changes position( finger stayed on screen)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            var location = touch.location(in: self)
            
            if location.y < 100{
                location.y = 100
            } else if location.y > 668{
                location.y = 668
            }
            
            player.position = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        super.touchesMoved(touches, with: event)
        
        if let touch : UITouch = touches.first!{
            _ = touch.location(in: self)
        } else {
            print("you can not cheat")
            return
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let emitter = SKEmitterNode(fileNamed: "explosion")!
        emitter.position = player.position
        addChild(emitter)
        
        player.removeFromParent()
        isGameOver = true
        
    }
    
    
    
    
    
}
