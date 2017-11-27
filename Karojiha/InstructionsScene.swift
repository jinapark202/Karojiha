//
//  InstructionsScene.swift
//  Karojiha
//
//  Created by Hannah Gray  on 11/25/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit

class InstructionsScene: SKScene, SKPhysicsContactDelegate{
    override init(size: CGSize){

        super.init(size: size)
        
        let message = "How to Play"
        instructionsLabel.text = message
        instructionsLabel.fontSize = 30
        instructionsLabel.fontColor = SKColor.white
        instructionsLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(instructionsLabel)
        instructionsLabel.run(SKAction.scale(to: 1.0, duration: 0.0))
        
        let message1 = "Tap the screen to make the bird fly up. Then "
        instructionsLabel.text = message1
        instructionsLabel.fontSize = 30
        instructionsLabel.fontColor = SKColor.white
        instructionsLabel.position = CGPoint(x: size.width/2, y: size.height/2.2)
        addChild(instructionsLabel)
        instructionsLabel.run(SKAction.scale(to: 1.0, duration: 0.0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
