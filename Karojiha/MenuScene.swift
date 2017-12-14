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
    
    let playLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    let startBtn = SKSpriteNode(imageNamed: "startButtonCentered_400")
    let instructBtn = SKSpriteNode(imageNamed: "instructionsButton_400")
    let soundBtn = SKSpriteNode(imageNamed: "soundButtonSmallSquare")
    var mute: Bool = true
    
    let background = Background()
    
    //Sound effects and music taken from freesfx.co.uk
    let backgroundSound = SKAudioNode(fileNamed: "clear_skies.mp3")
    let buttonPressSound = SKAction.playSoundFileNamed("single_bubbleEDIT.wav", waitForCompletion: true)
    
    override init(size: CGSize) {
        super.init(size: size)
        
        //Set up background
        background.scene = self
        backgroundColor = SKColor.black
        background.createParallax()
        
        //Set up background music
        self.addChild(backgroundSound)
        backgroundSound.autoplayLooped = true
    
        //Set up start button
        startBtn.size = CGSize(width: 250, height: 125)
        startBtn.position = CGPoint(x: size.width/2, y: size.height/1.5)
        startBtn.zPosition = 10
        startBtn.setScale(0)
        addChild(startBtn)
        startBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
    
        //Set up instructions label
        instructBtn.size = CGSize(width: 200, height: 27)
        instructBtn.position = CGPoint(x: size.width/2, y: size.height/2.2)
        instructBtn.zPosition = 10
        startBtn.setScale(0)
        addChild(instructBtn)
        instructBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
        
        //Set up sound button
        soundBtn.size = CGSize(width: 60, height: 60)
        soundBtn.position = CGPoint(x: size.width/2, y: size.height/4)
        soundBtn.zPosition = 20
        addChild(soundBtn)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if startBtn.contains(location){
                run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            } else if instructBtn.contains(location) {
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
