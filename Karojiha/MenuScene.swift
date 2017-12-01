//
//  MenuScene.swift
//  Karojiha
//
//  Created by Hannah Gray  on 11/19/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate {
    
    let instructionsLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    let playLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    let startBtn = SKSpriteNode(imageNamed: "startButtonCentered_400")
    
    //Sound effects and music taken from freesfx.co.uk
    let buttonPressSound = SKAction.playSoundFileNamed("single_bubbleEDIT.wav", waitForCompletion: true)
    
    override init(size: CGSize) {
        super.init(size: size)
    
        startBtn.size = CGSize(width: 250, height: 125)
        startBtn.position = CGPoint(x: size.width/2, y: size.height/1.5)
        startBtn.zPosition = 6
        startBtn.setScale(0)
        addChild(startBtn)
        startBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
    
        let message = "Instructions"
        instructionsLabel.text = message
        instructionsLabel.fontSize = 30
        instructionsLabel.fontColor = SKColor.yellow
        instructionsLabel.position = CGPoint(x: size.width/2, y: size.height/2.2)
        addChild(instructionsLabel)
        instructionsLabel.run(SKAction.scale(to: 1.0, duration: 0.0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if startBtn.contains(location){
                run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
            if instructionsLabel.contains(location){
                run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = InstructionsScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
