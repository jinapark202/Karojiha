//
//  GameOverScene.swift
//  Karojiha
//
//  Created by Jina Park on 11/17/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene, SKPhysicsContactDelegate {
    
    let restartBtn = SKSpriteNode(imageNamed: "restartButton_400")
    let homeBtn = SKSpriteNode(imageNamed: "homeButtonSmallSquare")
    let soundBtn = SKSpriteNode(imageNamed: "soundButtonSmallSquare")

    let background = Background()
    
    var sound: Bool = true
    
    //Sound effects and music taken from freesfx.co.uk
    let backgroundSound = SKAudioNode(fileNamed: "opening_day.mp3")
    let buttonClickSound = SKAction.playSoundFileNamed("slide_whistle_up.mp3", waitForCompletion: true)
    
    
    init(size: CGSize, score: Int, fliesCount: Int) {
        
        super.init(size: size)
        
        //Set up background
        background.scene = self
        backgroundColor = SKColor.black
        background.createParallax()

        let highScoreDefault = UserDefaults.standard
        var highScore = highScoreDefault.integer(forKey: "highScore")
        
        //Adds and loops the background sound
        self.addChild(backgroundSound)
        backgroundSound.autoplayLooped = true
        
        //Label for new high score
        let newHighScoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        newHighScoreLabel.text = "(New High Score)"
        newHighScoreLabel.fontSize = 13
        newHighScoreLabel.fontColor = SKColor.green
        newHighScoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.5)
        newHighScoreLabel.zPosition = 10
        
        
        // If score is higher than highScore, change highScore to current score.
        if (score > highScore) {
            highScore = score
            highScoreDefault.setValue(highScore, forKey: "highScore")
            highScoreDefault.synchronize()
            addChild(newHighScoreLabel)
        }
        
    
        //Sets up the restart button
        restartBtn.size = CGSize(width: 225, height: 225)
        restartBtn.position = CGPoint(x: size.width/2, y: size.height/2.45)
        restartBtn.zPosition = 10
        addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
        
        //Sets up the home button
        homeBtn.size = CGSize(width: 50, height: 50)
        homeBtn.position = CGPoint(x: size.width/10, y: size.height/1.05)
        homeBtn.zPosition = 10
        addChild(homeBtn)
        homeBtn.run(SKAction.scale(to: 1.0, duration: 0.0))

        soundBtn.size = CGSize(width: 50, height: 50)
        soundBtn.position = CGPoint(x: size.width/3.8, y: size.height/1.05)
        soundBtn.zPosition = 6
        soundBtn.setScale(0)
        addChild(soundBtn)
        soundBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
        
        //Creates game over label
        let message = "Game Over"
        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
        gameOverLabel.text = message
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/1.3)
        gameOverLabel.zPosition = 10
        addChild(gameOverLabel)
        
        //Creates score label from the past game.
        let scoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        scoreLabel.text = "Current Elevation: \(score) ft"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.43)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        //Creates label for highest score.
        let highScoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        highScoreLabel.fontSize = 25
        highScoreLabel.text = "Record: \(highScore) ft"
        highScoreLabel.fontColor = SKColor.orange
        highScoreLabel.position = CGPoint(x: size.width/2, y: size.height/8)
        highScoreLabel.zPosition = 10
        addChild(highScoreLabel)

    }
    
    //Takes you back to the GameScene when you touch the restart button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if restartBtn.contains(location) {
                run(buttonClickSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: size)
                self.view?.presentScene(gameScene, transition: reveal)
            } else if homeBtn.contains(location) {
                run(buttonClickSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            } else if soundBtn.contains(location) {
                if sound {
                    soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                    sound = false
                    backgroundSound.run(SKAction.stop())
                } else {
                    soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                    sound = true
                    backgroundSound.run(SKAction.play())
                }
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

