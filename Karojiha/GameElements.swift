//
//  GameElements.swift
//  Karojiha
//
//  Created by Jina Park on 10/11/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import SpriteKit


extension GameScene{
    
    //Create the bird
    func createBird() -> SKSpriteNode {
        //Set the size and position of the bird
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird1"))
        bird.size = CGSize(width: 70, height: 70)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        //Define the bird to be a SKPhysicsBody object.
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        
        //Set the bird to be affected by gravity.
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    //Set up click counter in upper right corner
    func createClickLabel(){
        clickLabel.horizontalAlignmentMode = .right
        clickLabel.position = CGPoint(x: size.width / 2.35, y: size.height / 2.35)
        clickLabel.fontColor = .white
        clickLabel.fontSize = 15
        clickLabel.fontName = "Avenir"
        clickLabel.text = String("Clicks: ") + String(counter)
        cameraNode.addChild(clickLabel)
    }
    
    //Creates the restart button
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width: 50, height: 50)
        restartBtn.position = CGPoint(x: self.frame.width / 10, y: self.frame.height / 7)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    //Creates the pause button
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:70, height:70)
        pauseBtn.position = CGPoint(x: self.frame.width / 10, y: self.frame.height / 20)
        pauseBtn.zPosition = 6
        pauseBtn.setScale(0)
        self.addChild(pauseBtn)
        pauseBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
}

