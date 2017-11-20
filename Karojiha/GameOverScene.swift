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
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        var score = Int(GameScene.maxAltitude / 10)
        var highScore = 0
        
        var highScoreDefault = UserDefaults.standard
        
        if (highScoreDefault.value(forKey: "highScore") != nil) {
            highScore = highScoreDefault.value(forKey: "highScore") as! NSInteger!
        }
        
        if (score > highScore) {
            highScore = score
            
            var HighScoreDefault = UserDefaults.standard
            highScoreDefault.setValue(highScore, forKey: "highScore")
            highScoreDefault.synchronize()
            
        }
        
        
        //Creates the restart button
        var restartBtn = SKSpriteNode()
        restartBtn = SKSpriteNode(imageNamed: "restart2")
        restartBtn.size = CGSize(width: 200, height: 200)
        restartBtn.position = CGPoint(x: size.width/2, y: size.height/2.5)
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
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/1.5)
        addChild(scoreLabel)
        
        
        //Creates label for highest score.
        let highScoreLabel = SKLabelNode(fontNamed: "Avenir-Light")
        highScoreLabel.fontSize = 25
        highScoreLabel.text = "Record: \(highScore) ft"
        highScoreLabel.fontColor = SKColor.orange
        highScoreLabel.position = CGPoint(x: size.width/2, y: size.height/6.5)
        addChild(highScoreLabel)
        
        func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches{
                let location = touch.location(in: self)
                if restartBtn.contains(location){
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameScene = GameScene()
                    self.view?.presentScene(gameScene, transition: reveal)
                }
            }
        }
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                let scene = GameScene(size: size)
                self.view?.presentScene(scene)
            }
            ]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

