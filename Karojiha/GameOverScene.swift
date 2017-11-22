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
    
    let restartBtn = SKSpriteNode(imageNamed: "restart2")

    init(size: CGSize, score: Int, wormCount: Int) {
        
        super.init(size: size)
        
        let highScoreDefault = UserDefaults.standard
        var highScore = highScoreDefault.integer(forKey: "highScore")
        
        //Label for new high score
        let newHighScoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        newHighScoreLabel.text = "(New High Score)"
        newHighScoreLabel.fontSize = 10
        newHighScoreLabel.fontColor = SKColor.green
        newHighScoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.45)
        
        
        // If score is higher than highScore, change highScore to current score.
        if (score > highScore) {
            highScore = score
            highScoreDefault.setValue(highScore, forKey: "highScore")
            highScoreDefault.synchronize()
            addChild(newHighScoreLabel)
        }
        
        //Creates the restart button
        restartBtn.size = CGSize(width: 200, height: 200)
        restartBtn.position = CGPoint(x: size.width/2, y: size.height/2.2)
        addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.0))

        backgroundColor = SKColor.black
        
        //Creates game over label
        let message = "Game Over"
        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
        gameOverLabel.text = message
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/1.25)
        addChild(gameOverLabel)
        
        //Creates score label from the past game.
        let scoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        scoreLabel.text = "Current Elevation: \(score) ft"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.4)
        addChild(scoreLabel)
        
        //Creates worm label for the number of worms eaten in the last game.
        let wormLabel = SKLabelNode(fontNamed: "Avenir-Light")
        wormLabel.text = "Worms Eaten: \(wormCount)"
        wormLabel.fontSize = 20
        wormLabel.fontColor = SKColor.lightGray
        wormLabel.position = CGPoint(x: size.width/2, y: size.height/1.55)
        addChild(wormLabel)
        
        
        //Creates label for highest score.
        let highScoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        highScoreLabel.fontSize = 25
        highScoreLabel.text = "Record: \(highScore) ft"
        highScoreLabel.fontColor = SKColor.orange
        highScoreLabel.position = CGPoint(x: size.width/2, y: size.height/6.5)
        addChild(highScoreLabel)
    }
    
    //Takes you back to the GameScene when you touch the restart button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if restartBtn.contains(location){
                let reveal = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: size)
                self.view?.presentScene(gameScene, transition: reveal)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

