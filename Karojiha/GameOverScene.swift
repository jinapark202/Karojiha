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
    
    let background = Background()
    let music = Sound()
    
    let homeBtn = Button(position: CGPoint(x: 5, y: 5), imageName: "homeButtonSmallSquare", size: CGSize(width: 50, height: 50))
    let soundBtn = Button(position: CGPoint(x: 5, y: 5), imageName: "soundButtonSmallSquare", size: CGSize(width: 50, height: 50))
    let restartBtn = Button(position: CGPoint(x: 5, y: 5), imageName: "restartButton_400", size: CGSize(width: 225, height: 225))
    
    init(size: CGSize, score: Int, fliesCount: Int) {
        
        super.init(size: size)
        music.scene = self
        
        //Set up background
        background.scene = self
        backgroundColor = SKColor.black
        background.createParallax()
        
        music.beginBGMusic(file: music.backgroundSound1)
        
        if music.checkForSound() == false {
            soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
        }

        restartBtn.position = CGPoint(x: size.width/2, y: size.height/2.6)
        homeBtn.position =  CGPoint(x: size.width/10, y: size.height/1.05)
        soundBtn.position = CGPoint(x: size.width/10, y: size.height/1.17)
        
        restartBtn.addToScene(parentScene: self)
        homeBtn.addToScene(parentScene: self)
        soundBtn.addToScene(parentScene: self)
        
        let highScoreDefault = UserDefaults.standard
        var highScore = highScoreDefault.integer(forKey: "highScore")
        
        //Label for new high score
        let newHighScoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        newHighScoreLabel.text = "(New High Score)"
        newHighScoreLabel.fontSize = 15
        newHighScoreLabel.fontColor = SKColor.green
        newHighScoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.65)
        newHighScoreLabel.zPosition = 10
        
        // If score is higher than highScore, change highScore to current score.
        if (score > highScore) {
            highScore = score
            highScoreDefault.setValue(highScore, forKey: "highScore")
            highScoreDefault.synchronize()
            addChild(newHighScoreLabel)
        }

        //Creates game over label
        let message = "Game Over"
        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
        gameOverLabel.text = message
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/1.4)
        gameOverLabel.zPosition = 10
        addChild(gameOverLabel)
        
        //Creates score label from the past game.
        let scoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        scoreLabel.text = "Current Elevation: \(score) ft"
        scoreLabel.fontSize = 23
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.55)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        //Creates label for highest score.
        let highScoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        highScoreLabel.fontSize = 25
        highScoreLabel.text = "Record: \(highScore) ft"
        highScoreLabel.fontColor = SKColor.orange
        highScoreLabel.position = CGPoint(x: size.width/2, y: size.height/9)
        highScoreLabel.zPosition = 10
        addChild(highScoreLabel)
    }
    
    //Takes you back to the GameScene when you touch the restart button.
    //Responds to the user's touches. Checks for contact with all buttons and provides subsequent action.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if restartBtn.contains(location) {
                music.playSoundEffect(file: music.restartButtonSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: size)
                self.view?.presentScene(gameScene, transition: reveal)
            } else if homeBtn.contains(location) {
                music.playSoundEffect(file: music.buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition: reveal)
            } else if soundBtn.contains(location) {
                music.switchSound()
                music.playSoundEffect(file: music.buttonPressSound)
                music.switchBGMusic(file: music.backgroundSound1)
                if music.checkForSound() == true {
                    soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                } else {
                    soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                }
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

