//
//  BuildingNode.swift
//  Project 29
//
//  Created by Tee Becker on 10/8/20.
//

import SpriteKit
import CoreGraphics
import UIKit

class BuildingNode: SKSpriteNode {
    
    var currentImage: UIImage!
    
    // setUp() will do the basic work required to make building / its texture and physics
    func setUp(){
        name = "building"
        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    

    
    
    // configurephysics() will set up per-pixel physics for the sprite's current texture
    func configurePhysics(){
        
    }
    
    
    // drawBuilding() will do the core graphics rendering of a building, and return it as a UIimage.
    func drawBuilding(size: ){
        
    }
    
}
