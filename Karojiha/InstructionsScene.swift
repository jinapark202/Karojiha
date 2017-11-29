//
//  InstructionsScene.swift
//  Karojiha
//
//  Created by Hannah Gray  on 11/25/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class InstructionsScene: SKScene, SKPhysicsContactDelegate{
    let titleLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    let stepsLabel = SKLabelNode(fontNamed: "Avenir-Light")
    let homeBtn = SKSpriteNode(imageNamed: "homeButtonSmallSquare")
    let instructions = SKSpriteNode(imageNamed: "instructions")

    override init(size: CGSize){
        super.init(size: size)
        
        homeBtn.size = CGSize(width: 50, height: 50)
        homeBtn.position = CGPoint(x: size.width/10, y: size.height/1.07)
        homeBtn.zPosition = 6
        homeBtn.setScale(0)
        addChild(homeBtn)
        homeBtn.run(SKAction.scale(to: 1.0, duration: 0.0))

        let titleLabel = SKLabelNode(fontNamed: "Avenir-Light")
        titleLabel.text = "How to Play"
        titleLabel.fontSize = 50
        titleLabel.fontColor = SKColor.gray
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/1.45)
        addChild(titleLabel)
        titleLabel.run(SKAction.scale(to: 1.0, duration: 0.0))
    
        
        instructions.size = CGSize(width: size.width/1.05, height: 200)
        instructions.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(instructions)
        instructions.run(SKAction.scale(to: 1.0, duration: 0.0))
        
    }
    
    // Return to the home page if the home button is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if homeBtn.contains(location) {
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
