//
//  GameElements.swift
//  Karojiha
//
//  Created by Jina Park on 10/11/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import SpriteKit


extension GameScene{
    func createBird() -> SKSpriteNode {
        //create a sprite node called “bird” and assign it a texture named “bird1”.
        //set position
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird1"))
        bird.size = CGSize(width: 70, height: 70)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        //In order to behave like a real world physics body, the bird has to be a SKPhysicsBody object.
        //Define the bird to behave like a ball of radius of half of its width.
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        
        
        /* Here you set the bird to be affected by gravity. The bird will be pushed upward when you touch the screen and then will come down itself.*/
        
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
}

