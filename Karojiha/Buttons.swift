//
//  Buttons.swift
//  Karojiha
//
//  Created by Kai Heen on 12/15/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit


class Buttons {
    
    var size = CGSize.zero
    weak var scene: SKScene? {
        didSet {
            self.size = scene?.size ?? CGSize.zero
        }
    }
   
    let soundBtn = SKSpriteNode(imageNamed: "soundButtonSmallSquare")
    let homeBtn = SKSpriteNode(imageNamed: "homeButtonSmallSquare")
    
    
    //GameScene only
    let pauseBtn = SKSpriteNode(imageNamed: "pauseButtonSmallSquare")

    //MenuScene only
    let instructBtn = SKSpriteNode(imageNamed: "instructionsButton_400")
    let startBtn = SKSpriteNode(imageNamed: "startButtonCentered_400")
    
    //GameOverScene only
    let restartBtn = SKSpriteNode(imageNamed: "restartButton_400")

    
    func addSoundButton(position: CGPoint) {
        soundBtn.size = CGSize(width: 50, height: 50)
        soundBtn.position = position
        soundBtn.zPosition = 20
        scene?.addChild(soundBtn)
    }
    
    func addHomeButton(position: CGPoint) {
        homeBtn.size = CGSize(width: 50, height: 50)
        homeBtn.position = position
        homeBtn.zPosition = 10
        scene?.addChild(homeBtn)
    }
    

    func createPauseButton() {
        pauseBtn.size = CGSize(width: 50, height: 50)
        pauseBtn.position = CGPoint(x: -size.width/2.5, y: size.height/2.85)
        pauseBtn.zPosition = 6
    }
    
    func addInstructionButton() {
        instructBtn.size = CGSize(width: 200, height: 27)
        instructBtn.position = CGPoint(x: size.width/2, y: size.height/2.2)
        instructBtn.zPosition = 10
        scene?.addChild(instructBtn)
    }
    
    func addStartButton() {
        startBtn.size = CGSize(width: 250, height: 125)
        startBtn.position = CGPoint(x: size.width/2, y: size.height/1.5)
        startBtn.zPosition = 10
        scene?.addChild(startBtn)
    }

    func addRestartButton() {
        restartBtn.size = CGSize(width: 225, height: 225)
        restartBtn.position = CGPoint(x: size.width/2, y: size.height/2.6)
        restartBtn.zPosition = 10
        scene?.addChild(restartBtn)
    }
}
