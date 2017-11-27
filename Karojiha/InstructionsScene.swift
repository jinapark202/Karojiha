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
    
    override init(size: CGSize){
        super.init(size: size)
        
        homeBtn.size = CGSize(width: 50, height: 50)
        homeBtn.position = CGPoint(x: -3 * homeBtn.size.width, y: size.height/2.25)
        homeBtn.zPosition = 6
        homeBtn.setScale(0)
        addChild(homeBtn)
        homeBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
        
        let title = "How to Play"
        titleLabel.text = title
        titleLabel.fontSize = 60
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/1.5)
        addChild(titleLabel)
        titleLabel.run(SKAction.scale(to: 1.0, duration: 0.0))

        let step1 = "Tap anywhere on the screen to make the bird flap it’s wings and move up the screen."
        stepsLabel.text = step1
        stepsLabel.fontSize = 25
        stepsLabel.fontColor = SKColor.white
        stepsLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(stepsLabel)
        stepsLabel.run(SKAction.scale(to: 1.0, duration: 0.0))
        
        //for the future...
//        let step2 = "Catch dragonflies to gain power ups and keep going for longer"
//        let step3 = "But be careful—gravity is trying to pull you down the more times you flap your       wings."
//        let step4 = "Try to fly as high as you can into space. You are an explorer into outer space. It’s the last new frontier!"
    }
    
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
