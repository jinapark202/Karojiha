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
    
  
    let buttons = Buttons()
    let background = Background()
    let music = Sound()
    
    
    override init(size: CGSize) {
        super.init(size: size)
        buttons.scene = self
        music.scene = self
        
        //Set up background
        background.scene = self
        backgroundColor = SKColor.black
        background.createParallax()
        
        //Set up background music
        music.beginBGMusic(file: music.menuSceneBackgroundSound)
      
        buttons.addSoundButton(position: CGPoint(x: size.width/2, y: size.height/4))
        buttons.addInstructionButton()
        buttons.addStartButton()
        buttons.soundBtn.size = CGSize(width: 60, height: 60)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: scene!)
            if buttons.startBtn.contains(location){
                music.playSoundEffect(file: music.buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.scene?.view?.presentScene(scene, transition: reveal)
            } else if buttons.instructBtn.contains(location) {
                music.playSoundEffect(file: music.buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = InstructionsScene(size: size)
                self.scene?.view?.presentScene(scene, transition: reveal)
            }
            else if buttons.soundBtn.contains(location) {
                music.switchSound()
                music.playSoundEffect(file: music.buttonPressSound)
                music.switchBGMusic(file: music.menuSceneBackgroundSound)
                if music.checkForSound() == false{
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                } else {
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                }
            }
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
