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
        clickLabel.fontColor = .orange
        clickLabel.fontSize = 15
        clickLabel.fontName = "Avenir"
        clickLabel.text = String("All the Elevations: ") + String(describing: floor(bird.position.y - (ledge.position.y + 10)))
        cameraNode.addChild(clickLabel)
    }
    
    //Set up maximum elevation counter in upper right corner
    func createMaxElevationLabel(){
        maxElevationLabel.horizontalAlignmentMode = .right
        maxElevationLabel.position = CGPoint(x: size.width / 2.35, y: size.height/2.55)
        maxElevationLabel.fontColor = .red
        maxElevationLabel.fontSize = 15
        maxElevationLabel.fontName = "Avenir"
        maxElevationLabel.text = String("Max Elevation: ") + String(describing: floor(maxAltitude))
        cameraNode.addChild(maxElevationLabel)
    }
    
    //Creates the restart button
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart1")
        restartBtn.size = CGSize(width: 50, height: 50)
            //THIS MAY BE WRONG POSITION
        restartBtn.position = CGPoint(x: -size.width/2.4, y: size.height/2.25)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        cameraNode.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
    }
    
    //Creates the pause button
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause1")
        pauseBtn.size = CGSize(width:50, height:50)
            //THIS MAY BE WRONG POSITION
        pauseBtn.position = CGPoint(x: -size.width/3.7, y: size.height/2.25)
        pauseBtn.zPosition = 6
        pauseBtn.setScale(0)
        cameraNode.addChild(pauseBtn)
        pauseBtn.run(SKAction.scale(to: 1.0, duration: 0.0))
    }
}

