//
//  GameElements.swift
//  Karojiha
//
//  Created by Jina Park on 10/11/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import SpriteKit


//Extension of Game Scene
extension GameScene{
    
    //Source:http://sweettutos.com/2017/03/09/build-your-own-flappy-bird-game-with-swift-3-and-spritekit/
    func createBird() -> SKSpriteNode {
        
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird_1"))
        
        let birdBody = SKPhysicsBody(circleOfRadius: 30)
        birdBody.mass = 0.4
        birdBody.categoryBitMask = PhysicsCategory.Player
        birdBody.collisionBitMask = 1
        
        bird.size = CGSize(width: 150, height: 110)
        bird.position = CGPoint(x: self.frame.midX, y: 15)
        bird.zPosition = 6
        bird.name = "bird"
        
        //Define the bird to be a SKPhysicsBody object.
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 0
        bird.physicsBody?.restitution = 0
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.Fly
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.Bee
        bird.physicsBody?.usesPreciseCollisionDetection = true
        bird.physicsBody = birdBody
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        
        return bird
    }

    
    func createFly() {
        
        let fly = SKSpriteNode(imageNamed: "dragonfly.png")
        
        // Determine where to spawn the worm along the Y axis
        let actualY = bird.position.y + size.height/1.5
        fly.position = CGPoint(x: random(min:10, max: size.width - 10), y: actualY)
        fly.zPosition = 5
        
        fly.physicsBody = SKPhysicsBody(rectangleOf: fly.size)
        fly.physicsBody?.isDynamic = true
        fly.physicsBody?.affectedByGravity = false
        fly.physicsBody?.allowsRotation = false
        fly.physicsBody?.categoryBitMask = PhysicsCategory.Fly
        fly.physicsBody?.collisionBitMask = PhysicsCategory.Fly
        fly.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        fly.physicsBody?.velocity = CGVector(dx: random(min: -100, max: 100), dy: random(min: -50, max: -100))
        
        self.addChild(fly)
        
        let wait = SKAction.wait(forDuration: 7)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([wait, remove])
        fly.run(sequence)
    }

    
    func createBee() {
        
        let bee = SKSpriteNode(imageNamed: "outlinedBee_200.png")
        let actualY = bird.position.y + size.height/1.5
        
        bee.size = CGSize(width: 30, height: 30)
        bee.position = CGPoint(x: random(min:10, max: size.width - 10), y: actualY)
        bee.zPosition = 5
        
        bee.physicsBody = SKPhysicsBody(rectangleOf: bee.size)
        bee.physicsBody?.isDynamic = true
        bee.physicsBody?.affectedByGravity = false
        bee.physicsBody?.allowsRotation = false
        bee.physicsBody?.categoryBitMask = PhysicsCategory.Bee
        bee.physicsBody?.collisionBitMask = PhysicsCategory.Bee
        bee.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        bee.physicsBody?.velocity = CGVector(dx: random(min: -250, max: 250), dy: random(min: -100, max: -400))
        
        self.addChild(bee)
        let wait = SKAction.wait(forDuration: 7)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([wait, remove])
        bee.run(sequence)
    }
    
    
    func createElevationLabel(){
        elevationLabel.horizontalAlignmentMode = .right
        elevationLabel.position = CGPoint(x: size.width/2.35, y: size.height/2.25)
        elevationLabel.fontColor = .orange
        elevationLabel.fontSize = 20
        elevationLabel.zPosition = 6
        elevationLabel.fontName = "Avenir-BlackOblique"
        elevationLabel.text = String(describing:
            Int((bird.position.y) - 10)) + String(" ft")
        cameraNode.addChild(elevationLabel)
    }
    
    //Instruction label in game scene that disappears once game starts
    func createEncouragingLabel(){
        encouragingLabel.text = "Tap the screen to fly!"
        encouragingLabel.fontName = "AvenirNextCondensed-DemiBold"
        encouragingLabel.fontSize = 30
        encouragingLabel.fontColor = .white
        encouragingLabel.position = CGPoint(x: size.width/2, y: size.height/2.5)
        encouragingLabel.zPosition = 10
        self.addChild(encouragingLabel)
    }
    
    
    //Updates the size of the elevation label depending on the altitude
    func adjustLabels(){
        
        if (altitude >= score) {
            score = altitude
        }
        
        elevationLabel.text = String(describing: "\(Int(score)) ft")
        let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.3)
        let scaleDownAction = SKAction.scale(to: 1.0, duration: 0.3)
        let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
        
        //Used to decide when to animate ElevationLabel
        let currentCheckpoint = floor(altitude/1000)
        if (currentCheckpoint > previousCheckpoint) {
            previousCheckpoint = currentCheckpoint
            elevationLabel.run(scaleActionSequence)
        }
    }
    
    //Adds spark particles
    func addSparkNode(scene: SKScene, Object: SKNode, file: String, size: CGSize) {
        guard let emitter = SKEmitterNode(fileNamed: file) else {
            return
        }

        emitter.particleBirthRate = 100 
        emitter.numParticlesToEmit = 15
        emitter.particleLifetime = 0.2
        emitter.particleSize = size
        
        emitter.position = Object.position
        emitter.name = "exhaust"
        
        // Send the particles to the scene.
        emitter.targetNode = scene;
        scene.addChild(emitter)
    }
    
    //Called every 1/10th of a second, adds sprites if randomly generated number falls below threshold
    func addBeeAndFly(){
        if gameStarted == true {
            if latestTime - worm_fly_checkpoint > 0.1 {
                worm_fly_checkpoint = latestTime
                let randBee = random(min: 0, max: 100)
                //Threshold check
                if (randBee < beeFrequency) {
                    createBee()
                }
                
                let randFly = random(min: 0, max: 100)
                if (bird.position.y > size.height / 2) {
                    if powerUpActive == false {
                        //Threshold check
                        if (randFly < fliesFrequency) {
                            createFly()
                        }
                    }
                }
            }
        }
    }
}


