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
    
    let background = Background()
    let music = Sound()
    
    let instructionBtn: Button
    let startBtn: Button
    let soundBtn: Button

    
    override init(size: CGSize) {
        instructionBtn = Button(position: CGPoint(x: 5, y: 5), imageName: "instructionsButton_400", size: CGSize(width: 200, height: 27))
        startBtn = Button(position: CGPoint(x: 5, y: 5), imageName: "startButtonCentered_400", size: CGSize(width: 250, height: 125))
        soundBtn = Button(position: CGPoint(x: 5, y: 5), imageName: "soundButtonSmallSquare", size: CGSize(width: 60, height: 60))
        
        
        super.init(size: size)
        instructionBtn.position = CGPoint(x: size.width/2, y: size.height/2.2)
        startBtn.position = CGPoint(x: size.width/2, y: size.height/1.5)
        soundBtn.position = CGPoint(x: size.width/2, y: size.height/4)
        

        instructionBtn.addToScene(parentScene: self)
        startBtn.addToScene(parentScene: self)
        soundBtn.addToScene(parentScene: self)

        music.scene = self
        
        //Set up background
        background.scene = self
        backgroundColor = SKColor.black
        background.createParallax()
        
        //Set up background music
        music.beginBGMusic(file: music.menuSceneBackgroundSound)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: scene!)
            if startBtn.contains(location){
                music.playSoundEffect(file: music.buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.scene?.view?.presentScene(scene, transition: reveal)
            } else if instructionBtn.contains(location) {
                music.playSoundEffect(file: music.buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = InstructionsScene(size: size)
                self.scene?.view?.presentScene(scene, transition: reveal)
            }
            else if soundBtn.contains(location) {
                music.switchSound()
                music.playSoundEffect(file: music.buttonPressSound)
                music.switchBGMusic(file: music.menuSceneBackgroundSound)
                if music.checkForSound() == false{
                    soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                } else {
                    soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                }
            }
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
