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
    
    var mute: Bool = true
    let buttons = Buttons()
    let background = Background()
    let music = Sound()
    
    
    override init(size: CGSize) {
        super.init(size: size)
        buttons.scene = self
        
        //Set up background
        background.scene = self
        backgroundColor = SKColor.black
        background.createParallax()
        
        //Set up background music
        self.addChild(music.menuSceneBackgroundSound)
        music.menuSceneBackgroundSound.autoplayLooped = true

        buttons.addSoundButton(position: CGPoint(x: size.width/2, y: size.height/4))
        buttons.addInstructionButton()
        buttons.addStartButton()
        buttons.soundBtn.size = CGSize(width: 60, height: 60)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: scene!)
            if buttons.startBtn.contains(location){
                self.scene?.run(music.buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.scene?.view?.presentScene(scene, transition: reveal)
            } else if buttons.instructBtn.contains(location) {
                self.scene?.run(music.buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = InstructionsScene(size: size)
                self.scene?.view?.presentScene(scene, transition: reveal)
            }
            else if buttons.soundBtn.contains(location) {
                if mute {
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                    mute = false
                    music.menuSceneBackgroundSound.run(SKAction.stop())
                } else {
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                    mute = true
                    music.menuSceneBackgroundSound.run(SKAction.play())
                }
            }
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
