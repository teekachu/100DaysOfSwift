//
//  GameScene.swift
//  Pro_11_ REDO
//
//  Created by Ting Becker on 7/3/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var life = 5
    var balls = [String]()
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet{
            if editingMode {
                editLabel?.text = "Let's Play"
            } else {
                editLabel?.text = "Edit Layout"
            }
        }
    }
    var scoreLabel: SKLabelNode!
    var scores = 5 {
        didSet{
            scoreLabel.text = "Life: \(scores)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384) // where the center is
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        balls += ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        //adding bouncer below
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        //adding base below
        makeBase(at: CGPoint(x: 128, y: 0), isGood: true)
        makeBase(at: CGPoint(x: 384, y: 0), isGood: false)
        makeBase(at: CGPoint(x: 640, y: 0), isGood: true)
        makeBase(at: CGPoint(x: 896, y: 0), isGood: false)
        
        //create Label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Life: 5"
        scoreLabel.position = CGPoint(x: 980, y: 700)
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Let's Play"
        editLabel.position = CGPoint(x: 80, y: 700)
        editLabel.horizontalAlignmentMode = .left
        addChild(editLabel)
        
    }
    
    func makeObstacles(){
        for _ in 1...18{
            
            let size = CGSize(width: Int.random(in: 30...80), height: 15)
            let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
            box.zRotation = CGFloat.random(in: 0...3)
            box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
            box.physicsBody?.isDynamic = false
            
            let frame = CGPoint(x: Int.random(in: 1...15) * 90, y: Int.random(in: 2...9) * 100)
            box.position = frame
            box.name = "box"
            
            addChild(box)
            
        }
    }
    //    func makeDotObstacle(at position: CGPoint){
    //        let size = CGSize(width: 15, height: 15)
    //        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
    //        box.zRotation = CGFloat.random(in: 0...3)
    //        box.position = position
    //        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
    //        box.physicsBody?.isDynamic = false
    //        addChild(box)
    //    }
    
    
    func makeBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(bouncer.size.width / 2))
        bouncer.position = position
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeBase(at position: CGPoint, isGood: Bool){
        var base : SKSpriteNode
        var glow: SKSpriteNode
        
        if isGood{
            base = SKSpriteNode(imageNamed: "slotBaseGood")
            glow = SKSpriteNode(imageNamed: "slotGlowGood")
            base.name = "good" //footnote 2
        } else {
            base = SKSpriteNode(imageNamed: "slotBaseBad")
            glow = SKSpriteNode(imageNamed: "slotGlowBad")
            base.name = "bad" //footnote 2
        }
        
        base.position = position
        glow.position = position
        
        //footnote 1
        base.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(base.size.width / 2))
        base.physicsBody?.isDynamic = false
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinforever = SKAction.repeatForever(spin)
        glow.run(spinforever)
        
        addChild(base)
        addChild(glow)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode){
        if object.name == "good"{
            scores += 1
            life += 1
            destroy(ball: ball)
        } else if object.name == "bad"{
            scores -= 1
            life -= 1
            destroy(ball: ball)
        } else if object.name == "box"{
            object.removeFromParent()
        }
    }
    
    func destroy(ball: SKNode){
        if let fire = SKEmitterNode(fileNamed: "FireParticles.sks"){
            fire.position = ball.position
            addChild(fire)
        }
        ball.removeFromParent()
    }

    //reWrite of didBegin to unwrap. original below
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball"{
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball"{
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    
    //checking both names of object to see which one is the ball
    //below is the original, but to avoid multiple collisions, we rewrite:
    // forceUnwrapped once, but if ball bounces around and report collision, we already destroyed ball so force unWrap will crash app
    
    //    func didBegin(_ contact: SKPhysicsContact){
    //        if contact.bodyA.node?.name == "ball"{
    //            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)} else if contact.bodyB.node?.name == "ball" { collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
    //        }
    //    }`
    
    //everytime a touch happens
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            if objects.contains(editLabel){
                editingMode.toggle()
            } else {
                if editingMode{
                    //create obstacles
                    makeObstacles()
                } else {
                    if scores > 0{
                        let ball = SKSpriteNode(imageNamed: "\(balls[0])")
                        balls.shuffle()
                        ball.position = CGPoint(x: location.x, y: 700)
                        //                    ball.position = location - saying to drop ball wherever the user touches
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
                        //setting contact and collision bitMask - tell me about all collisions
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        ball.physicsBody?.restitution = 0.5
                        ball.name = "ball" //footnote 2
                        addChild(ball)
                    
//                        if life == 0 {
//                            alert()
//                        }
                    }
                }
            }
        }
    }
    
//    func alert(){
//        let ac = UIAlertController(title: "Out of life ", message: "You have used all the balls", preferredStyle: .alert)
//        let action = UIAlertAction(title: "okay", style: .default)
//        ac.addAction(action)
//        view?.window?.rootViewController?.present(ac, animated: true)
//    }
    
}

//Footnotes:
//1. Add rectangle physics to our slots.
//2. Name the slots so we know which is which, then name the balls too.
//3. Make our scene the contact delegate of the physics world – this means, "tell us when contact occurs between two bodies."
//4. Create a method that handles contacts and does something appropriate.
