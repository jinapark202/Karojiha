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
}
