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
    
    //Sound effects and music taken from freesfx.co.uk
    let backgroundSound = SKAudioNode(fileNamed: "clear_skies.mp3")
    let buttonPressSound = SKAction.playSoundFileNamed("single_bubbleEDIT.wav", waitForCompletion: true)
    
    override init(size: CGSize) {
        super.init(size: size)
        buttons.scene = self
        
        //Set up background
        background.scene = self
        backgroundColor = SKColor.black
        background.createParallax()
        
        //Set up background music
        self.addChild(backgroundSound)
        backgroundSound.autoplayLooped = true

    
        buttons.addSoundButton(position: CGPoint(x: size.width/2, y: size.height/4))
        buttons.addInstructionButton()
        buttons.addStartButton()
        buttons.soundBtn.size = CGSize(width: 60, height: 60)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: scene!)
            if buttons.startBtn.contains(location){
                self.scene?.run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.scene?.view?.presentScene(scene, transition: reveal)
            } else if buttons.instructBtn.contains(location) {
                self.scene?.run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = InstructionsScene(size: size)
                self.scene?.view?.presentScene(scene, transition: reveal)
            }
            else if buttons.soundBtn.contains(location) {
                if mute {
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                    mute = false
                    backgroundSound.run(SKAction.stop())
                } else {
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
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
