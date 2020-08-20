//
//  WhackSlot.swift
//  Project14
//
//  Created by Ting Becker on 7/21/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    //this slot should contain the hole, the mask on top of hole, and the penguins in mask
    var charNode: SKSpriteNode!
    
    var isVisible = false //can I hit it
    var isHit = false     //have I hit it
    
    
    func createWhackSlot(at position: CGPoint){
        self.position = position
        
        let holeSprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(holeSprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15) // right on top of each hole for where penguins would pop out
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        // basically with this masknode, anything INSIDE the mask can be seen and OUTSIDE is invisible.
        // this cropNode ONLY crops node that are INSIDE of it.
        //        let charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90) // below each hole
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
        
    }
    
    func show(basedOn hideTime: Double){  //Will be called by viewController repeatedly , based on POP-UP-TIME and HIDE-TIME
        //if invisible, show penguin
        //if penguin is available to be hit
        //decide which kind of penguin to show (good/bad)
        
        if isVisible == true {return}
        
        charNode.run(SKAction.moveBy(x: 0, y: 85, duration: 0.03))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "good"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "bad"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.0)){
            [weak self] in
            self?.hide()
        }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
    }
    
    func hide(){ //basically we want to hide it after a while the penguin is show, so we call from show
        if isVisible == false {return}
        
        charNode.run(SKAction.moveBy(x: 0, y: -85, duration: 0.03))
        isVisible = false
    }
    
    func hit(){ // what happens when hit - animation, delay, hide, then show again
        isHit = true
            
        let delay = SKAction.wait(forDuration: 0.25)
        let hidden = SKAction.moveBy(x: 0, y: -85, duration: 0.5)
        let notVisible = SKAction.run {
            [weak self] in
            self?.isVisible = false
        }
        
        charNode.run(SKAction.sequence([delay, hidden, notVisible]))
        
    }
    
}
