//
//  GameScene.swift
//  fireWorksD70
//
//  Created by Ting Becker on 8/11/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameTimer: Timer!
    var fireworks = [SKNode]()
    
    var scoreLabel: SKLabelNode!
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var numberOfLaunch = 0
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode()
        scoreLabel.fontName = "chalkduster"
        scoreLabel.position = CGPoint(x: self.size.width - 30, y: self.size.height - 30)
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    @objc func launchFireworks(){
        
        let movementAmount: CGFloat = 1800
        let leftEdge = -22
        let bottomEdge = -22
        let rightEdge = 1024 + 22
        
        switch Int.random(in: 0...3){
        case 0: //fire 5 straight up
            createFireWorks(xMovement: 0, x: 512, y: bottomEdge)
            createFireWorks(xMovement: 0, x: 512-100, y: bottomEdge)
            createFireWorks(xMovement: 0, x: 512-200, y: bottomEdge)
            createFireWorks(xMovement: 0, x: 512+100, y: bottomEdge)
            createFireWorks(xMovement: 0, x: 512+200, y: bottomEdge)
        case 1: //fire 5 in a fan
            createFireWorks(xMovement: 0, x: 512, y: bottomEdge)
            createFireWorks(xMovement: -200, x: 512-200, y: bottomEdge)
            createFireWorks(xMovement: -100, x: 512-100, y: bottomEdge)
            createFireWorks(xMovement: 100, x: 100, y: bottomEdge)
            createFireWorks(xMovement: 200, x: 200, y: bottomEdge)
        case 2: //fire 5 from left to right
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFireWorks(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3: // right to left
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFireWorks(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default: break
            
        }
        
        numberOfLaunch += 1
    }
    
    func createFireWorks(xMovement: CGFloat, x: Int, y: Int){
        // accept x movement speed of firework, x & y position for creation
        
        //1. create SKNode to act as firework container
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        //2. create rocket spriteNode, call it "firework", adjust colorBlendFactor so we can color it, add to container node
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1 // low performance cost, "1" = use new color exclusively
        firework.name = "firework"
        node.addChild(firework) // don't forget the node.addchild because we are adding these to each node
        
        
        //3. give firework sprite node random colors
        switch Int.random(in: 0...2){
        case 0:
            firework.color = .green
        case 1:
            firework.color = .magenta
        case 2:
            firework.color = .yellow
        default: break
        }
        
        //4. create UIBezierPath to represent the movement of firework
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        //5. tell container node to follow path. turn itself if needed
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        //follow takes a CGPath as its first parameter and makes the node move along that path
        // 4 parameters:
        // which path is relevant to node's current position
        // if any coordinate in path should be adjusted to take into account the node's position
        // should rotate itself or not
        // speed
        node.run(move)
        
        //6. create particles behind rocket
        if let emitter = SKEmitterNode(fileNamed: "fuse"){
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        //7. add firework to fireworks array
        fireworks.append(node)
        addChild(node)
    }
    
    //to explode one firework
    func explode(firework: SKNode){
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        
        firework.removeFromParent()
    }
    
    func explodeFirework(){
        //loop through each firework in the fireworks array, find the selected ones, call explode on them.
        
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed(){
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else{continue}
            
            if firework.name == "selected"{
                //destroy this firework
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        //score
        switch numExploded{
        case 0:
            score += 200
        case 1:
            score += 400
        case 2:
            score += 800
        case 3:
            score += 2000
        case 4:
            score += 3000
        default:
            score += 4000
            
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouched(touches)
    }
    
    func checkTouched(_ touches: Set<UITouch>){
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        //we use for case let, instead of saying "for node in nodesAtPoint"
        //type cast this as SKSpriteNode
        for case let node as SKSpriteNode in nodesAtPoint{
            //originally we named the nodes firework, so this is just to make sure that still applies
            guard node.name == "firework" else {return}
            
            //insert inner loop here to do something
            //loop will go through all firework in array, find the firework image inside ( array holds container node and each container node holds the firework image and spark emitter )
            for parent in fireworks{
                guard let firework = parent.children.first as? SKSpriteNode else{
                    return
                }
                
                if firework.name == "selected" && firework.color != node.color{
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            //change node name to selected and colorBlend to be white
            node.name = "selected"
            node.colorBlendFactor = 0
        }
        
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouched(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for (index, firework) in fireworks.enumerated().reversed(){
            if firework.position.y > 900{
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
        
        if numberOfLaunch == 6{
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.zPosition = 1
            gameOver.blendMode = .replace
            gameOver.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            addChild(gameOver)
            
            gameTimer?.invalidate()
        }
    }
    
}
