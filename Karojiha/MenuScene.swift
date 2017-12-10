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
    let soundBtn = SKSpriteNode(imageNamed: "soundButtonSmallSquare")
    var mute: Bool = true
    
    //Sound effects and music taken from freesfx.co.uk
    let backgroundSound = SKAudioNode(fileNamed: "clear_skies.mp3")
    let buttonPressSound = SKAction.playSoundFileNamed("single_bubbleEDIT.wav", waitForCompletion: true)
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.addChild(backgroundSound)
        backgroundSound.autoplayLooped = true
        
        //Changed background to be black
        backgroundColor = SKColor.black
    
        startBtn.size = CGSize(width: 250, height: 125)
        startBtn.position = CGPoint(x: size.width/2, y: size.height/1.5)
        startBtn.zPosition = 10
        startBtn.setScale(0)
        addChild(startBtn)
        startBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
    
        let message = "Instructions"
        instructionsLabel.text = message
        instructionsLabel.fontSize = 30
        instructionsLabel.fontColor = SKColor.yellow
        instructionsLabel.position = CGPoint(x: size.width/2, y: size.height/2.2)
        instructionsLabel.zPosition = 10
        addChild(instructionsLabel)
        instructionsLabel.run(SKAction.scale(to: 1.0, duration: 0.0))
        
        soundBtn.size = CGSize(width: 50, height: 50)
        soundBtn.position = CGPoint(x: size.width/2, y: size.height/4)
        soundBtn.zPosition = 20
        addChild(soundBtn)
        
        //Implements endless scrolling stars background
        let backgroundTexture = SKTexture(imageNamed: "testStarsBg")
        
        for i in 0 ... 6 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = 0
            background.anchorPoint = CGPoint.zero
            background.xScale = size.width/background.size.width
            background.position = CGPoint(x: 0, y: (backgroundTexture.size().height * CGFloat(i) - CGFloat(1 * i)))
            addChild(background)
            
            let moveUp = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveUp, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if startBtn.contains(location){
                run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            } else if instructionsLabel.contains(location) {
                run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = InstructionsScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            } else if soundBtn.contains(location) {
                if mute {
                    soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                    mute = false
                    backgroundSound.run(SKAction.stop())
                } else {
                    soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                    mute = true
                    backgroundSound.run(SKAction.play())
                }
            }
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
