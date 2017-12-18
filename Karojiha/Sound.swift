//
//  Sound.swift
//  Karojiha
//
//  Created by Jina Park on 12/14/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class Sound {
    
    /*
       Fly sounds created from Kai Heen, Jina Park, and Hannah Gray. All other sound effects and music taken from freesfx.co.uk.
    */
    public let dyingSound = SKAction.playSoundFileNamed("slide_whistle_down.mp3", waitForCompletion: true)
    public let backgroundSound = SKAudioNode(fileNamed: "city_pulse.mp3")
    public let buttonPressSound = SKAction.playSoundFileNamed("single_bubbleEDIT.wav", waitForCompletion: true)
    public let beeHitSound = SKAction.playSoundFileNamed("wet_gooey_liquid_splat.mp3", waitForCompletion: true)
    public let powerUpSound = SKAction.playSoundFileNamed("powerUpNoise.wav", waitForCompletion: true)
    public let fly2Sound = SKAction.playSoundFileNamed("fly2.wav", waitForCompletion: true)
    public let fly1Sound = SKAction.playSoundFileNamed("fly1.wav", waitForCompletion: true)
    public let menuSceneBackgroundSound = SKAudioNode(fileNamed: "clear_skies.mp3")
    public let backgroundSound1 = SKAudioNode(fileNamed: "opening_day.mp3")
    public let restartButtonSound = SKAction.playSoundFileNamed("slide_whistle_up.mp3", waitForCompletion: true)
    static var sound = true
    var scene: SKScene?
    
    //If sound is muted, stop playing sound. If not, play sound.
    func switchSound() {
        if Sound.sound == true {
            Sound.sound = false
        } else {
            Sound.sound = true
        }
    }
    
    //Returns true if the sound is on and returns false if the sound is off
    func checkForSound() -> Bool {
        if Sound.sound == true{
            return true
        }
        return false
    }
    
    //Plays the sound effect when sound is not muted
    func playSoundEffect(file: SKAction){
        if Sound.sound == true {
           scene?.run(file)
        }
    }
    
    //When sound is muted, stop playing any sound/music. Switch music files depending on scene.
    func switchBGMusic(file: SKAudioNode) {
        if Sound.sound == false {
            file.run(SKAction.stop())
        } else if file.inParentHierarchy(scene!) == false {
            scene?.addChild(file)
        } else {
            file.run(SKAction.play())
        }
    }
    
    //Start and loop the background music when sound is not muted
    func beginBGMusic(file: SKAudioNode) {
        file.autoplayLooped = true
        if Sound.sound == true {
            scene?.addChild(file)
        } else {
            scene?.removeFromParent()
        }
    }
}
