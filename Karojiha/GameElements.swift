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
        clickLabel.position = CGPoint(x: size.width/2.35, y: size.height/2.35)
        clickLabel.fontColor = .white
        clickLabel.fontSize = 15
        clickLabel.fontName = "Avenir"
        clickLabel.text = String("Clicks: ") + String(counter)
        cameraNode.addChild(clickLabel)
    }
}

