//
//  GameScene.swift
//  Project14
//
//  Created by Ting Becker on 7/21/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var slots = [WhackSlot]()
    var popUpTime = 0.80
    var numberOfRounds = 0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 10, y: 10)
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        for i in 0 ... 4 {
            createSlot(at: CGPoint(x: 100 + (i*170), y: 410))
        }
        for i in 0 ... 3 {
            createSlot(at: CGPoint(x: 180 + (i*170), y: 320))
        }
        for i in 0 ... 4 {
            createSlot(at: CGPoint(x: 100 + (i*170), y: 230))
        }
        for i in 0 ... 3 {
            createSlot(at: CGPoint(x: 180 + (i*170), y: 140))
        }
        
        // right when game start, we want to call createPenguins once after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            [weak self] in
            self?.createPenguins()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //doing the hitting,
        //what did the user hit and corresponding action
        if let touch = touches.first { //find any touch
            let location = touch.location(in: self) // where was the touch
            let tappedNodes = nodes(at: location) // which node did the touch hit
            
            for node in tappedNodes{
                //typecast node into WhackSlot
                
                if node.name == "good" {
                    // they shouldn't have whacked this penguin
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.isVisible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.hit()
                    score -= 3
                    
                    run(SKAction.playSoundFileNamed("byefelicia.mp3", waitForCompletion:false))
                } else if node.name == "bad" {
                    // they should have whacked this one
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.isVisible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.charNode.xScale = 0.65
                    whackSlot.charNode.yScale = 0.65
                    
                    if let emitter = SKEmitterNode(fileNamed:"smoke.sks"){
                        emitter.position = whackSlot.position
                        addChild(emitter)
                        emitter.advanceSimulationTime(1)
                    }

                    whackSlot.hit()
                    score += 1
                    
                    run(SKAction.playSoundFileNamed("ouch.mp3", waitForCompletion:false))
                }
                
                //                guard let whackSlot = node.parent?.parent as? WhackSlot else {continue}
                //                if !whackSlot.isVisible {continue} // if its not visible, do nothing and move on
                //                if !whackSlot.isHit {continue} //if its not hit, do nothing and move on
                //                whackSlot.hit()  // calls whathappens when hit ()
                //
                //                if node.name == "good"{
                //                    // minus points
                //                    score -= 3
                //                    run(SKAction.playSoundFileNamed("byefelicia.mp3", waitForCompletion: false))
                //                } else if node.name == "bad" {
                //                    // add points
                //                    whackSlot.charNode.xScale = 0.65
                //                    whackSlot.charNode.yScale = 0.65
                //                    score += 1
                //                    run(SKAction.playSoundFileNamed("ouch.mp3", waitForCompletion: false))
                //                }
            }
        }
    }
    
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.createWhackSlot(at: position) // to make slots at the position and call it above
        addChild(slot)
        slots.append(slot)
    }
    
    func createPenguins(){
        
        numberOfRounds += 1
        
        if numberOfRounds >= 30{
            for slot in slots{
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            run(SKAction.playSoundFileNamed("gameOver.mp3", waitForCompletion: true))
            
            return // get out of this function, and leave game
        }
        
        popUpTime *= 0.991 // slowly decreate popup time to increase game difficulty
        //create penguins randomly
        
        slots.shuffle()
        slots[0].show(basedOn: popUpTime) // show penguin after hiding for a period of time
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(basedOn: popUpTime)
        }
        if Int.random(in: 0...12) > 7 {
            slots[2].show(basedOn: popUpTime)
        }
        if Int.random(in: 0...12) > 10 {
            slots[3].show(basedOn: popUpTime)
        }
        if Int.random(in: 0...12) > 11 {
            slots[4].show(basedOn: popUpTime)
        }
        
        let minDelay = popUpTime / 2.5
        let maxDelay = popUpTime * 2.5
        let delay = Double.random(in: minDelay...maxDelay)
        
        //call createPenguins again based on random delayTime
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            [weak self] in
            self?.createPenguins()
        }
    }
    
    
    
}
