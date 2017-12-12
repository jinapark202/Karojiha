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
    
    struct PhysicsCategory {
        static let Player: UInt32 = 1
        static let Fly: UInt32 = 3
        static let Bee: UInt32 = 4
    }
    
    let backgroundNames = ["background1","background2","background3","background4New","blackBackground"]

    var gravity = CGFloat(0.0)
    var initialFlapVelocity = CGFloat(600.0)
    var flapVelocity = CGFloat(600.0)

    let motionManager = CMMotionManager()
    var fliesFrequency = CGFloat(6.0)
    var beeFrequency = CGFloat(0.0)
    
    var worm_fly_checkpoint = 0.0
    
    //For label animation
    var previousCheckpoint = CGFloat(0.0)
    var fliesEaten = 0
    var beeEaten = 0
    
    //Variables for click counter.
    var totalClickCounter = 0.0
    let elevationLabel = SKLabelNode()
    let fliesEatenLabel = SKLabelNode()
    
    var soundBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var homeBtn = SKSpriteNode()
    
    var gameStarted = false
    var sound: Bool = true
    var powerUpActive: Bool = false
    
    var latestTime = 0.0
    var powerUpEndTime = 0.0
    var penaltyEndTime = 0.0
    
    let birdName = "bird"
    let birdAtlas = SKTextureAtlas(named:"player")
    var bird = SKSpriteNode()
    var flappingAction = SKAction()
    let playerBody = SKPhysicsBody(circleOfRadius: 30)
    
    let cameraNode = SKCameraNode()
    let ledge = SKNode()
    
    //Sound effects and music taken from freesfx.co.uk
    let fliesHitSound = SKAction.playSoundFileNamed("open_lighter.mp3", waitForCompletion: true)
    let dyingSound = SKAction.playSoundFileNamed("slide_whistle_down.mp3", waitForCompletion: true)
    let backgroundSound = SKAudioNode(fileNamed: "city_pulse.mp3")
    let buttonPressSound = SKAction.playSoundFileNamed("single_bubbleEDIT.wav", waitForCompletion: true)
    let beeHitSound = SKAction.playSoundFileNamed("wet_gooey_liquid_splat.mp3", waitForCompletion: true)
    
    let background = Background()

    
    override init(size: CGSize) {
        super.init(size: size)
        background.scene = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        background.scene = self
    }
    
    //makes bird flap its wings when tap occurrs
    func animateBird(){
        let birdSprites = (1...4).map { n in birdAtlas.textureNamed("bird_\(n)") }
        let animatebird = SKAction.animate(with: birdSprites, timePerFrame: 0.1)
        flappingAction = SKAction.repeat(animatebird, count: 2)
    }
    
    //makes bird flap its wings when tap occurrs
    func animateAstroBird(){
        let birdSprites = (1...4).map { n in birdAtlas.textureNamed("birdHelmet_\(n)") }
        let animatebird = SKAction.animate(with: birdSprites, timePerFrame: 0.1)
        flappingAction = SKAction.repeat(animatebird, count: 2)
    }

    
    //Adds the first background to the screen and sets up the scene.
    override func didMove(to view: SKView) {
        
        //Prevents bird from leaving the frame
        let edgeFrame = CGRect(origin: CGPoint(x: ((self.view?.frame.minX)!) ,y: (self.view?.frame.minY)!), size: CGSize(width: (self.view?.frame.width)!, height: (self.view?.frame.height)! + 200000000))
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
        
        //Creates scene, bird, and buttons
        createScene()
        createElevationLabel()
        createSoundBtn()
        createPauseBtn()
        createHomeBtn()
        background.initBackgroundArray(names: backgroundNames)
        
        self.addChild(backgroundSound)
        backgroundSound.autoplayLooped = true
        
        self.physicsWorld.contactDelegate = self
        
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)

            
        //Starts generating accelerometer data
        motionManager.startAccelerometerUpdates()
    }
    
    
    //Makes the bird flap its wings once screen is clicked, adds a number to the counter every time screen is clicked.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //Implements the pause and restart button functionality
        for touch in touches{
            var location = touch.location(in: self)
            
            //Adjust for cameraNode position
            location.x -= cameraNode.position.x
            location.y -= cameraNode.position.y
            
            if homeBtn.contains(location){
                if sound == true {
                    run(buttonPressSound)
                }
                let reveal = SKTransition.fade(withDuration: 0.5)
                let menuScene = MenuScene(size: size)
                self.view?.presentScene(menuScene, transition: reveal)
            } else if soundBtn.contains(location) {
                if sound {
                    soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                    sound = false
                    backgroundSound.run(SKAction.stop())
                } else {
                    run(buttonPressSound)
                    soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                    sound = true
                    backgroundSound.run(SKAction.play())
                }
            } else if pauseBtn.contains(location){
                if self.isPaused == false {
                    if sound == true {
                        run(buttonPressSound)
                    }
                    self.isPaused = true
                    pauseBtn.texture = SKTexture(imageNamed: "playButtonSmallSquare")
                } else {
                    if sound == true {
                        run(buttonPressSound)
                    }
                    self.isPaused = false
                    pauseBtn.texture = SKTexture(imageNamed: "pauseButtonSmallSquare")
                }
            }
            else{
                self.bird.run(flappingAction)
                
                if (bird.physicsBody?.velocity.dy)! < flapVelocity {
                    bird.physicsBody?.velocity.dy = flapVelocity
                    totalClickCounter += 1
                }
            }
        }
    }
    
    
    //Creates the bird and makes it flap its wings.
    func createScene(){
        self.bird = createBird()
        self.addChild(bird)
        animateAstroBird()
    }
    
    
    func updateBeeFrequency() {
        let exponent = Double(-0.12 * (bird.position.y / 1000))
        beeFrequency =  CGFloat(20 / (1 + (5.9 * (pow(M_E, exponent)))))
    }
    
    //Function to emit spark particles
    func newSparkNode(scene: SKScene, Object: SKNode, file: String, size: CGSize) {
        
        guard let emitter = SKEmitterNode(fileNamed: file) else {
            return
        }
        
        emitter.particleBirthRate = 100 //100
        emitter.numParticlesToEmit = 15 //15
        emitter.particleLifetime = 0.2 //.2
        emitter.particleSize = size
        
        // Place the emitter at fly postition.
        emitter.position = Object.position
        emitter.name = "exhaust"

        // Send the particles to the scene.
        emitter.targetNode = scene;
        scene.addChild(emitter)
    }
    
    
    func startPowerUp() {
        powerUpEndTime = latestTime + 2
    }
    
    
    //Collecting enough flies will apply an upward force to the bird
    func applyPowerUp(){
    
        if latestTime < powerUpEndTime {
            
            let stopGravity = CGFloat(-10.0)
            physicsWorld.gravity.dy = stopGravity
            gravity = stopGravity
            
            //bird.physicsBody?.applyForce(CGVector(dx: 0, dy: 900))
            bird.physicsBody?.velocity.dy = (bird.physicsBody?.velocity.dy)! + 50
            newSparkNode(scene: self, Object: bird, file: "fire", size: CGSize(width: 75, height: 75))
            
            powerUpActive = true
            
        } else {
            powerUpActive = false
        }
    }
    
    func startPenalty() {
        penaltyEndTime = latestTime + 5
    }
    
    
    //Collecting enough worms will apply an upward force to the bird
    func applyPenalty(){
        var speedArray = [600, 400, 200, 100, 0]

        if beeEaten > speedArray.count - 1 {
            flapVelocity = CGFloat(speedArray.endIndex)
        } else if latestTime < penaltyEndTime {
            flapVelocity = CGFloat(speedArray[beeEaten])
        } else {
            beeEaten = 0
            flapVelocity = initialFlapVelocity
        }
    }
    
    // If 3 worms are eaten, start power up. Change labels depending on number of worms eaten.
    func threeFliesEaten() {
        fliesEaten += 1
  
        let fliesNeeded = 3
        if fliesEaten % fliesNeeded == 0 && fliesEaten > 1 {
            startPowerUp()
        }
    }
    
    
    //Removes worm, adds sound, and increases the number of worms eaten when a worm when it collides with bird
    func collisionWithFlies(object: SKNode, bird: SKNode) {
        object.removeFromParent()

        if powerUpActive == false {
            if sound == true {
                run(fliesHitSound)
            }
            threeFliesEaten()
            let remainder = fliesEaten % 3
//            newSparkNode(scene: self, Object: object, file: "spark", size: CGSize(width: remainder*100, height: remainder*100) )
            if remainder == 1{
                newSparkNode(scene: self, Object: object, file: "spark", size: CGSize(width: 75, height: 75))
            }
            if remainder == 2{
                newSparkNode(scene: self, Object: object, file: "spark", size: CGSize(width: 200, height: 200))
            }
        }
    }
    
    
    //Makes sound and sparks when bird collides with bees
    func collisionWithBee(object: SKNode, bird: SKNode) {
        object.removeFromParent()

        if powerUpActive == false {
            if sound == true {
                run(beeHitSound)
            }
            newSparkNode(scene: self, Object: object, file: "smoke1", size: CGSize(width: 50, height: 50))
            beeEaten += 1
            startPenalty()
        }

    }
    

    func collisionWithFloor(object: SKNode, bird: SKNode) {
        
        
    }
    
    
    //function to check for collision between worm and bird
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //Checks which categoryBitMask is larger, larger one is assigned to secondBody, smaller one is assigned to firstBody
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
    
    
    //Allows the bird to move left and right when phone tilts
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
        if gameStarted == true {
            if let bird = childNode(withName: birdName) as? SKSpriteNode {
                if let data = motionManager.accelerometerData {
                    if fabs(data.acceleration.x) > 0.001 {
                        bird.physicsBody!.applyForce(CGVector(dx: 70 * pow(abs(data.acceleration.x) * 7, 1.5) * sign(data.acceleration.x), dy: 0))
                    }
                }
            }
        }
    }
    
    
    var altitude: CGFloat {
        return floor(bird.position.y - (ledge.position.y + 10) - 28)
    }

    var score = CGFloat(0.0)
    
    
    //Updates the text of the labels on the game screen
    func adjustLabels(){
        
        //Keeps track of the score - the highest point the bird ever went
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
    
    //Adjusts the camera as the bird moves up the screen.
    func setupCameraNode() {
        let playerPositionInCamera = cameraNode.convert(bird.position, from: self)

        //Moves the camera up with the bird when the bird goes halfway up the screen
        if playerPositionInCamera.y > 0 {
            cameraNode.position.y = bird.position.y
            
            if gameStarted == false {
                gameStarted = true
                background.createParallax()
            }
        }
        
        //Restarts the game when the bird hits the bottom of the screen
        if playerPositionInCamera.y < -size.height / 2.0 {
            run(dyingSound)
            let reveal = SKTransition.fade(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, score: Int(score), fliesCount: fliesEaten)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    override func didSimulatePhysics() {
        setupCameraNode()
    }
    
    func addBeeAndFly(){
        if latestTime - worm_fly_checkpoint > 0.1 {
            worm_fly_checkpoint = latestTime
            let randBee = random(min: 0, max: 100)
            if (randBee < beeFrequency) {
                createBee()
            }
            
            let randFly = random(min: 0, max: 100)
            if (bird.position.y > size.height / 2) {
                if powerUpActive == false {
                    if (randFly < fliesFrequency) {
                        createFly()
                    }
                }
            }
        }
    }
    
    
    //Updates several parts of the game, including background/bird/labels/gravity
    override func update(_ currentTime: TimeInterval) {
        latestTime = currentTime
        processUserMotion(forUpdate: currentTime)
        adjustLabels()
        background.adjust(forBirdPosition: bird.position)
        applyPowerUp()
        applyPenalty()
        updateBeeFrequency()
        background.addBackgroundFlavor(forBirdPosition: bird.position)
        addBeeAndFly()
    }
}

