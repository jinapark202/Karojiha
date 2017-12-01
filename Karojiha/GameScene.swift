//
//  GameScene.swift
//  Karojiha
//
//  Created by Jina Park on 10/11/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//


import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let Player: UInt32 = 1
        static let Obstacle: UInt32 = 2
        static let Edge: UInt32 = 4
        static let Worm: UInt32 = 3
    }
    var gravity = CGFloat(0.0)
    
    let motionManager = CMMotionManager()

    let birdName = "bird"
    
    //For label animation
    var previousCheckpoint = CGFloat(0.0)
    var wormsEaten = 0
    
    //Variables for click counter.
    var totalClickCounter = 0.0
    let elevationLabel = SKLabelNode()
    let wormsEatenLabel = SKLabelNode()
    
    var soundBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var homeBtn = SKSpriteNode()
    
    
    var gameStarted = false
    var mute: Bool = true
    
    //All necessary to determine clicksRequired
    var timer = Timer()
    var time = 0.0
    
    var latestTime = 0.0
    var powerUpEndTime = 0.0
    
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    var repeatActionbird = SKAction()
    let playerBody = SKPhysicsBody(circleOfRadius: 30)
    
    var obstacles: [SKNode] = []
    let obstacleSpacing: CGFloat = 800
    let cameraNode = SKCameraNode()
    let ledge = SKNode()
    
    
    var birdVelocity = CGFloat(600.0)
    
    //Sound effects and music taken from freesfx.co.uk
    let wormHitSound = SKAction.playSoundFileNamed("open_lighter.mp3", waitForCompletion: true)
    let sparkSound = SKAction.playSoundFileNamed("ascending_zip_glissEDIT.wav", waitForCompletion: true)
    let dyingSound = SKAction.playSoundFileNamed("slide_whistle_down.mp3", waitForCompletion: true)
    let backgroundSound = SKAudioNode(fileNamed: "city_pulse.mp3")
    let buttonPressSound = SKAction.playSoundFileNamed("single_bubbleEDIT.wav", waitForCompletion: true)

    
    //Add desired background images to this array of strings. Makes sure background images are in Assets.xcassets
    let backgroundNames: [String] = ["background1","background2","background3","background4New","testStarsBg"]
    var backgroundImages: [SKNode] = []
    let backgroundHeight = CGFloat(8.0) //This is height of background in terms of # of screens (if Bg is gradient, changes speed of color change)
    var currentBackground: CGFloat = 1.0
    var previousBackground: CGFloat = 0.0
    
    var bgFlavorImages  = [1: ["rainbow.png", "cloud"],   //First background (light blue)
                           2: ["airplane", "cloud", "pigeon", "pigeon"],
                           3: ["rainbow.png", "airplane","pigeon", "redPlane", "eagle", "eagle"],
                           4: ["thunder1", "redPlane", "airplane"],
                           5: ["planet","comet", "spaceship"]    //Last background (Space)
        ]
    
    var bgFlavorCheckpoint = CGFloat(0.0)
    let flavorFrequency = CGFloat(500.0)
    
    //creates a random function for us to use
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //Initiates the position of the bird and sets up the playerBody.
    func createPlayerAndPosition() {
        playerBody.mass = 0.4
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = 4
        
        bird.physicsBody = playerBody
        bird.physicsBody!.isDynamic = true
        bird.position = CGPoint(x: self.frame.midX, y: ledge.position.y + 15)
        bird.zPosition = 10
        bird.name = birdName
        
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.Worm
        bird.physicsBody?.usesPreciseCollisionDetection = true
        
        //Prevents bird from rotating upon collision
        bird.physicsBody?.allowsRotation = false
    }
    

    //Starts timer in motion, calls updateCounting every second
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    
    //Waits a while at beginning of game, then begins to calculate
    //Prevent worms from accumulating until after the bird gets halfway up the screen
    @objc func updateCounting(){
        time += 1
        if (bird.position.y > size.height / 2) {
            if (time.truncatingRemainder(dividingBy: 2) == 0) {
                addWorm()
            }
        }
    }
    
    func animateWormLabel(){
        
        if wormsEaten % 3 == 1 {
            let scaleUpAction = SKAction.scale(to: 1.1, duration: 0.3)
            wormsEatenLabel.fontColor = UIColor.orange
            wormsEatenLabel.run(scaleUpAction)
        }
        
        if wormsEaten % 3 == 2 {
            let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.3)
            wormsEatenLabel.fontColor = UIColor.yellow
            wormsEatenLabel.run(scaleUpAction)
        }
        
        if wormsEaten % 3 == 0 {
            let scaleUpAction = SKAction.scale(to: 1.4, duration: 0.3)
            wormsEatenLabel.fontColor = UIColor.green
            wormsEatenLabel.run(scaleUpAction)
        
        
        }
    }
    
    //Adds the first background to the screen and sets up the scene.
    override func didMove(to view: SKView) {
        //Prevents bird from leaving the frame
        let edgeFrame = CGRect(origin: CGPoint(x: ((self.view?.frame.minX)!) ,y: (self.view?.frame.minY)!), size: CGSize(width: (self.view?.frame.width)!, height: (self.view?.frame.height)! + 200000000)) //Sloppy solution but it works
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
        
        //Creates scene, bird, and buttons
        createScene()
        createPlayerAndPosition()
        createElevationLabel()
        createSoundBtn()
        createPauseBtn()
        createHomeBtn()
        createWormsEatenLabel()
        
        self.addChild(backgroundSound)
        backgroundSound.autoplayLooped = true
        
        initBackgroundArray(names: backgroundNames)
        addChild(backgroundImages[0])
        
        self.physicsWorld.contactDelegate = self
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
            
        //Starts generating accelerometer data
        motionManager.startAccelerometerUpdates()
    }
    
    
    //Makes the bird flap its wings once screen is clicked, adds a number to the counter every time screen is clicked.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        totalClickCounter += 1
        
        self.bird.run(repeatActionbird)
        
        if (bird.physicsBody?.velocity.dy)! < birdVelocity {
            bird.physicsBody?.velocity.dy = birdVelocity
        }
        
        //Start the timer counting
        if gameStarted == false{
            scheduledTimerWithTimeInterval()
            gameStarted = true
            createBackground()
        }
        
        //Implements the pause and restart button functionality
        for touch in touches{
            var location = touch.location(in: self)
            
            //Adjust for cameraNode position
            location.x -= cameraNode.position.x
            location.y -= cameraNode.position.y
            
            if homeBtn.contains(location){
                run(buttonPressSound)
                let reveal = SKTransition.fade(withDuration: 0.5)
                let menuScene = MenuScene(size: size)
                self.view?.presentScene(menuScene, transition: reveal)
            }
            else if pauseBtn.contains(location){
                if self.isPaused == false{
                    self.isPaused = true
                    timer.invalidate()
                    pauseBtn.texture = SKTexture(imageNamed: "playButtonSmallSquare")
                } else {
                    self.isPaused = false
                    timer.fire()
                    pauseBtn.texture = SKTexture(imageNamed: "pauseButtonSmallSquare")
                }
            } else if soundBtn.contains(location) {
                if mute {
                    run(buttonPressSound)
                    soundBtn.texture = SKTexture(imageNamed: "soundOffButtonSmallSquare")
                    mute = false
                    backgroundSound.run(SKAction.stop())
                } else {
                    run(buttonPressSound)
                    soundBtn.texture = SKTexture(imageNamed: "soundButtonSmallSquare")
                    mute = true
                    backgroundSound.run(SKAction.play())
                }
            }
        }
    }
    
    
    //Creates the bird and makes it flap its wings.
    func createScene(){
        self.bird = createBird()
        self.addChild(bird)
        
        birdSprites.append(birdAtlas.textureNamed("bird_1"))
        birdSprites.append(birdAtlas.textureNamed("bird_2"))
        birdSprites.append(birdAtlas.textureNamed("bird_3"))
        birdSprites.append(birdAtlas.textureNamed("bird_4"))
        
        let animatebird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        self.repeatActionbird = SKAction.repeatForever(animatebird)
    }

    
    //Function to emit spark particles at worm position when worm collides with bird
    func newFlyNode(scene: SKScene, Bird: SKNode) {
        
        run(sparkSound)
        
        guard let emitter = SKEmitterNode(fileNamed: "fire.sks") else {
            return
        }
        emitter.particleBirthRate = 100
        emitter.numParticlesToEmit = 15
        emitter.particleLifetime = 0.2
        
        // Place the emitter at worm postition.
        emitter.position = bird.position
        emitter.name = "exhaust"
        
        // Send the particles to the scene.
        emitter.targetNode = scene;
        scene.addChild(emitter)
    }
    
    //Function that adds worms to screen
    func addWorm() {
        
        // Create sprite
        let worm = SKSpriteNode(imageNamed: "dragonfly.png")
        
        worm.physicsBody = SKPhysicsBody(rectangleOf: worm.size)
        worm.physicsBody?.isDynamic = true
        worm.physicsBody?.affectedByGravity = false
        worm.physicsBody?.categoryBitMask = PhysicsCategory.Worm
        worm.physicsBody?.collisionBitMask = PhysicsCategory.Worm
        worm.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        // Determine where to spawn the worm along the Y axis
        let actualY = bird.position.y + size.height/2
        
        // Position the worm
        worm.position = CGPoint(x: random(min:10, max: size.width - 10), y: actualY)
        
        // Add the worm to the scene
        self.addChild(worm)
        
        worm.physicsBody?.velocity = CGVector(dx: random(min: -25, max: 25), dy: random(min: -25, max: 25))
    }
    

    
    //Function to emit spark particles at worm position when worm collides with bird
    func newSparkNode(scene: SKScene, Worm: SKNode) {
        
        guard let emitter = SKEmitterNode(fileNamed: "spark.sks") else {
            return
        }
        emitter.particleBirthRate = 100
        emitter.numParticlesToEmit = 15
        emitter.particleLifetime = 0.2
        
        // Place the emitter at worm postition.
        emitter.position = Worm.position
        emitter.name = "exhaust"
        
        // Send the particles to the scene.
        emitter.targetNode = scene;
        scene.addChild(emitter)
    }
    
    func startPowerUp() {
        powerUpEndTime = latestTime + 2
    }
    
    //Collecting enough worms will apply an upward force to the bird
    func applyPowerUp(){
        //expontential decay funtion to allow for more worms to be needed at the beginning of the game than at the end of the game
        //let wormsNeeded = (pow((1/1.3),((abs(gravity))-21))).rounded(.up)
        
        if latestTime < powerUpEndTime {
            
            let stopGravity = CGFloat(-10.0)
            physicsWorld.gravity.dy = stopGravity
            gravity = stopGravity
            
            bird.physicsBody?.applyForce(CGVector(dx: 0, dy: 1000))
            newFlyNode(scene: self, Bird: bird)
        }
    }
    
    //function to remove worm when it collides with bird
    func collisionBetween(worm: SKNode, bird: SKNode) {
        run(wormHitSound)
        worm.removeFromParent()
        wormsEaten += 1
        
        let wormsNeeded = 3
        if wormsEaten % wormsNeeded == 0 && wormsEaten > 1 {
            startPowerUp()
        }

        animateWormLabel()
        if (wormsEaten % wormsNeeded == 0) {
            wormsEatenLabel.text = ("x ") + String(describing: (3))}
        else{
            wormsEatenLabel.text = ("x ") + String(describing: (Int(wormsEaten % wormsNeeded))) }
        
        newSparkNode(scene: self, Worm: worm)
    }
    
    
    //function to check for collision between worm and bird
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //checks which categoryBitMask is larger, larger one is assigned to secondBody, smaller one is assigned to firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask != secondBody.categoryBitMask) {
            if let worm = secondBody.node as? SKSpriteNode, let bird = firstBody.node as? SKSpriteNode {
                collisionBetween(worm: worm, bird: bird)
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
    
    //Changes gravity of the physics World
    func calculateGravity(){
        //Logistic Function for gravity increase, can graph this at
        //www.desmos.com/calculator/agxuc5gip8
        
        let newGravity = CGFloat(-1 * (65 / (1 + (100 * (pow(M_E, -0.025 * totalClickCounter))))) - 14)
        physicsWorld.gravity.dy = newGravity
        gravity = newGravity
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
        }
        
        //Restarts the game when the bird hits the bottom of the screen
        if playerPositionInCamera.y < -size.height / 2.0 {
            run(dyingSound)
            let reveal = SKTransition.fade(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, score: Int(score), wormCount: wormsEaten)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    
    //Updates several parts of the game, including background/bird/labels/gravity
    override func update(_ currentTime: TimeInterval) {
        latestTime = currentTime
        processUserMotion(forUpdate: currentTime)
        calculateGravity()
        adjustLabels()
        adjustBackground()
        applyPowerUp()
        setupCameraNode()
        addBackgroundFlavor()
    }
    
}

