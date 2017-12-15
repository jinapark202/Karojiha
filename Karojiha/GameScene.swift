//
//  GameScene.swift
//  Karojiha
//
//  Created by Jina Park on 10/11/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//


import SpriteKit
import CoreMotion

//creates a random function for us to use
func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}
func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    let birdAtlas = SKTextureAtlas(named:"player")
    var flappingAction = SKAction()
    var flapVelocity = CGFloat(600.0)

    var fliesEaten = 0
    var beeEaten = 0
    var fliesFrequency = CGFloat(6.0)
    var beeFrequency = CGFloat(0.0)
    var worm_fly_checkpoint = 0.0

    //Variables for score counter.
    let elevationLabel = SKLabelNode()
    var score = CGFloat(0.0)
    var previousCheckpoint = CGFloat(0.0)      //For label animation
    
    var latestTime = 0.0
    var powerUpEndTime = 0.0
    var penaltyEndTime = 0.0
    
    let buttons = Buttons()
    
    var gameStarted = false
    var soundOn: Bool = true
    var powerUpActive: Bool = false
    
    let cameraNode = SKCameraNode()
    let background = Background()
    let music = Sound()
    let motionManager = CMMotionManager()

    //For proper collision detection
    struct PhysicsCategory {
        static let Player: UInt32 = 1
        static let Fly: UInt32 = 3
        static let Bee: UInt32 = 4
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        background.scene = self
        buttons.scene = self
    }
    
    //TODO: WHAT IS THIS?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        background.scene = self
        buttons.scene = self
    }
    
    
    //Called as soon as the user presses "START", sets up the game environment
    override func didMove(to view: SKView) {
        createScene()

        addChild(music.backgroundSound)
        music.backgroundSound.autoplayLooped = true
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = CGFloat(-10.0)
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
            
        //Starts generating accelerometer data
        motionManager.startAccelerometerUpdates()
    }
    
    
    //Adds all neccessary physical components to the screen
    func createScene(){
        createElevationLabel()
        
        buttons.addHomeButton(position: CGPoint(x: -size.width/2.5 , y: size.height/2.25))
        buttons.homeBtn.removeFromParent()
        cameraNode.addChild(buttons.homeBtn)
        
        buttons.addSoundButton(position: CGPoint(x: -size.width/2.5, y: size.height/3.85))
        buttons.soundBtn.removeFromParent()
        cameraNode.addChild(buttons.soundBtn)
        
        buttons.createPauseButton()
        cameraNode.addChild(buttons.pauseBtn)
        

        background.initBackgroundArray(names: background.backgroundNames)
        bird = createBird()
        addChild(bird)
        
        //Prevents bird from leaving the frame
        let edgeFrame = CGRect(origin: CGPoint(x: ((self.view?.frame.minX)!) ,y: (self.view?.frame.minY)!), size: CGSize(width: (self.view?.frame.width)!, height: (self.view?.frame.height)! + 200000000))
        physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
    }
    
    
    
    //Responsible for the setting up and maintaing correct viewing frame as the bird moves up the screen.
    func setupCameraNode() {
        let playerPositionInCamera = cameraNode.convert(bird.position, from: self)
        
        //Moves the camera up with the bird when it reaches the halfway point up the screen
        if playerPositionInCamera.y > 0 {
            cameraNode.position.y = bird.position.y
        }
        
        //Restarts the game when the bird hits the bottom of the screen
        if playerPositionInCamera.y < -size.height / 2.0 {
            run(music.dyingSound)
            let reveal = SKTransition.fade(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, score: Int(score), fliesCount: fliesEaten)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    
    
    // Responds to the user's touches. Checks for contact with all buttons and animates bird.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Sets the parallax background in motion on the first touch of the game
        if gameStarted == false {
            gameStarted = true
            background.createParallax()
        }
        
        
        for touch in touches{
            var location = touch.location(in: self)
            
            //Adjust for cameraNode position
            location.x -= cameraNode.position.x
            location.y -= cameraNode.position.y
            
            if buttons.homeBtn.contains(location){
                if soundOn == true {
                    run(music.buttonPressSound)
                }
                let reveal = SKTransition.fade(withDuration: 0.5)
                let menuScene = MenuScene(size: size)
                self.view?.presentScene(menuScene, transition: reveal)
            } else if buttons.soundBtn.contains(location) {
                if soundOn {
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                    soundOn = false
                    music.backgroundSound.run(SKAction.stop())
                } else {
                    run(music.buttonPressSound)
                    buttons.soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                    soundOn = true
                    music.backgroundSound.run(SKAction.play())
                }
            } else if buttons.pauseBtn.contains(location){
                if self.isPaused == false {
                    if soundOn == true {
                        run(music.buttonPressSound)
                    }
                    self.isPaused = true
                    buttons.pauseBtn.texture = SKTexture(imageNamed: "playButtonSmallSquare")
                } else {
                    if soundOn == true {
                        run(music.buttonPressSound)
                    }
                    self.isPaused = false
                    buttons.pauseBtn.texture = SKTexture(imageNamed: "pauseButtonSmallSquare")
                }
            }
            else{
                self.bird.run(flappingAction)

                if (bird.physicsBody?.velocity.dy)! < flapVelocity {
                    bird.physicsBody?.velocity.dy = flapVelocity
                }
            }
        }
    }
    
    
    //checks whether bird is high enough for space helmet; applies it if so
    func applyFlapAnimation(){
        if altitude < 1000{
            animateBird(fileName: "bird" )
        }else{
            animateBird(fileName: "birdHelmet")
        }
    }
   
    //Makes bird flap its wings when tap occurrs
    func animateBird(fileName: String){
        let birdSprites = (1...4).map { n in birdAtlas.textureNamed(fileName+"_\(n)") }
        let animatebird = SKAction.animate(with: birdSprites, timePerFrame: 0.1)
        flappingAction = SKAction.repeat(animatebird, count: 2)
    }
    
    //Allows the bird to move left and right when phone tilts
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
        if gameStarted == true {
            if let bird = childNode(withName: "bird") as? SKSpriteNode {
                if let data = motionManager.accelerometerData {
                    if fabs(data.acceleration.x) > 0.001 {
                        bird.physicsBody!.applyForce(CGVector(dx: 70 * pow(abs(data.acceleration.x) * 7, 1.5) * sign(data.acceleration.x), dy: 0))
                    }
                }
            }
        }
    }
    
    //Checks for collision between bird and other objects, calls necessary collision functions
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Fly {
            if let flies = secondBody.node as? SKSpriteNode, let bird = firstBody.node as? SKSpriteNode {
                collisionWithFlies(object: flies, bird: bird)
            }
        } else if firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Bee {
            if let bee = secondBody.node as? SKSpriteNode, let bird = firstBody.node as? SKSpriteNode {
                collisionWithBee(object: bee, bird: bird)
            }
        }
    }
    
    
    //Adds sparks/sounds when bird collides with flies, starts a power up if 3 flies have been eaten
    func collisionWithFlies(object: SKNode, bird: SKNode) {
        object.removeFromParent()
        fliesEaten += 1
        let remainder = fliesEaten % 3
        
        if powerUpActive == false {
            if remainder == 0 && fliesEaten > 1 {
                startPowerUp()
            }
            if remainder == 1{
                if soundOn == true {
                    run(music.fly1Sound)
                }
                addSparkNode(scene: self, Object: object, file: "spark", size: CGSize(width: 75, height: 75))
            }
            if remainder == 2{
                if soundOn == true {
                    run(music.fly2Sound)
                }
                addSparkNode(scene: self, Object: object, file: "spark", size: CGSize(width: 200, height: 200))
            }
        }
    }
    
    
    //Called when the bird eats its third fly... see collisionWithFlies() above
    func startPowerUp() {
        if soundOn == true {
            run(music.powerUpSound)
        }
        powerUpEndTime = latestTime + 2
    }
    
    //Called continuously in update()... once a powerUp has been started, stops applying force after 2 seconds
    func applyPowerUp(){
        if latestTime < powerUpEndTime {
            bird.physicsBody?.applyForce(CGVector(dx: 0, dy: 900))
            addSparkNode(scene: self, Object: bird, file: "fire", size: CGSize(width: 75, height: 75))
            powerUpActive = true
        } else {
            powerUpActive = false
        }
    }
    
    
    
    
    //Removes bee, adds sound and sparks, and starts a 5 second penalty.
    func collisionWithBee(object: SKNode, bird: SKNode) {
        object.removeFromParent()
        
        if powerUpActive == false {
            if soundOn == true {
                run(music.beeHitSound)
            }
            addSparkNode(scene: self, Object: object, file: "smoke1", size: CGSize(width: 50, height: 50))
            beeEaten += 1
            startPenalty()
        }
    }
    
    //Called when user collides with a bee... 5 seconds of impaired movement
    //Collision with a bee within the 5 second window restarts the penalty timer
    func startPenalty() {
        penaltyEndTime = latestTime + 5
    }
    
    
    //Further slows the bird as it collides with more bees within 5 seconds
    func applyPenalty(){
        var speedArray = [600, 400, 200, 100, 0]

        if beeEaten > speedArray.count - 1 {
            flapVelocity = CGFloat(speedArray.endIndex)
        } else if latestTime < penaltyEndTime {
            flapVelocity = CGFloat(speedArray[beeEaten])
        } else {
            beeEaten = 0
            flapVelocity = CGFloat(speedArray[0])
        }
    }

    
    
    //Called in update(), this function increases the probability of bees spawning as altitiude increases
    func updateBeeFrequency() {
        let exponent = Double(-0.12 * (bird.position.y / 1000))
        beeFrequency =  CGFloat(20 / (1 + (5.9 * (pow(M_E, exponent)))))
    }
    
    var altitude: CGFloat {
        return floor(bird.position.y - 38)
    }

    
    //We override this function to avoid lag that possibly resulted from conflict between update() and didSimulatePhysics()
    override func didSimulatePhysics() {
        setupCameraNode()
    }
    
    //Called continuously, this runs the game
    override func update(_ currentTime: TimeInterval) {
        latestTime = currentTime
        processUserMotion(forUpdate: currentTime)
        adjustLabels()
        background.adjust(forBirdPosition: bird.position)
        background.addBackgroundFlavor(forBirdPosition: bird.position)
        applyPowerUp()
        applyPenalty()
        applyFlapAnimation()
        updateBeeFrequency()
        addBeeAndFly()
    }
}

