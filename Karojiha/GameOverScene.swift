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
    
    //Sound effects and music taken from freesfx.co.uk
    let backgroundSound = SKAudioNode(fileNamed: "opening_day.mp3")
    let buttonClickSound = SKAction.playSoundFileNamed("slide_whistle_up.mp3", waitForCompletion: true)

    init(size: CGSize, score: Int, wormCount: Int) {
        
        super.init(size: size)
        
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
        homeBtn.position = CGPoint(x: homeBtn.size.width, y: size.height - homeBtn.size.height)
        homeBtn.zPosition = 10
        addChild(homeBtn)
        homeBtn.run(SKAction.scale(to: 1.0, duration: 0.0))

        backgroundColor = SKColor.black
        
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
        
        //Creates worm label for the number of worms eaten in the last game.
        let wormLabel = SKLabelNode(fontNamed: "Avenir-Light")
        wormLabel.text = "Worms Eaten: \(wormCount)"
        wormLabel.fontSize = 20
        wormLabel.fontColor = SKColor.lightGray
        wormLabel.position = CGPoint(x: size.width/2, y: size.height/1.6)
        wormLabel.zPosition = 10
        addChild(wormLabel)
        
        
        //Creates label for highest score.
        let highScoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        highScoreLabel.fontSize = 25
        highScoreLabel.text = "Record: \(highScore) ft"
        highScoreLabel.fontColor = SKColor.orange
        highScoreLabel.position = CGPoint(x: size.width/2, y: size.height/8)
        highScoreLabel.zPosition = 10
        addChild(highScoreLabel)
        
        
        //Implements endless scrolling stars background
        let backgroundTexture = SKTexture(imageNamed: "testStarsBg")
        
        for i in 0 ... 6 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = 0
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: 0, y: (backgroundTexture.size().height * CGFloat(i) - CGFloat(1 * i)))
            addChild(background)
            
            let moveUp = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveUp, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
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
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

