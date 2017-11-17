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
    
    
    let motionManager = CMMotionManager()
    //for swiping
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    
    let birdName = "bird"
    
    var maxAltitude = CGFloat(0.0)
    //For label animation
    var previousCheckpoint = CGFloat(0.0)
    var altitude = CGFloat(0.0)
    var wormsEaten = CGFloat(0.0)
    
    //Variables for click counter.
    var totalClickCounter = 0.0
    let elevationLabel = SKLabelNode()
    let wormsEatenLabel = SKLabelNode()
    
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    
    var gameStarted = false
    
    //All necessary to determine clicksRequired
    var timer = Timer()
    var time = 0.0
    
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
    
    //Add desired background images to this array of strings. Makes sure background images are in Assets.xcassets
    let backgroundNames: [String] = ["background1","background2","background3","background4","testStarsBg"]
    var backgroundImages: [SKNode] = []
    let backgroundHeight = CGFloat(3.0) //This is height of background in terms of # of screens (if Bg is gradient, changes speed of color change)
    var currentBackground: CGFloat = 1.0
    var previousBackground: CGFloat = 0.0
    
    //creates a random function for us to use
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    


    
    //Creates a ledge that prevents the bird from falling to the bottom of the screen.
    func createLedge() {
        ledge.position = CGPoint(x: size.width/2, y: size.height/40)
        let ledgeBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width/2, height: size.height/40))
        ledgeBody.isDynamic = false
        ledgeBody.categoryBitMask = PhysicsCategory.Edge
        ledge.physicsBody = ledgeBody
        addChild(ledge)
    }
    
    //Initiates the position of the bird and sets up the playerBody.
    func createPlayerAndPosition() {
        playerBody.mass = 0.3
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = 4
        
        bird.physicsBody = playerBody
        bird.physicsBody!.isDynamic = true
        bird.position = CGPoint(x: ledge.position.x, y: ledge.position.y + 10)
        bird.zPosition = 10
        bird.name = birdName
        
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.Worm
        bird.physicsBody?.usesPreciseCollisionDetection = true
        
        //Prevents bird from rotating upon collision
        bird.physicsBody?.allowsRotation = false
    }
    
    //This function creates SKSpriteNode Objects for all background images, and adds them to an array (backgroundImages)
    func initBackgroundArray(names: [String]){
        var x: CGFloat = 0.0
        for bgName in names{
            let backgroundImage = SKSpriteNode(imageNamed: bgName)
            backgroundImage.xScale=size.width/backgroundImage.size.width
            backgroundImage.yScale=size.height/backgroundImage.size.height*backgroundHeight
            backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            backgroundImage.position = CGPoint(x: size.width/2, y: backgroundImage.size.height*x)
            backgroundImage.zPosition = -1
            backgroundImages.append(backgroundImage)
            x += 1
            //print(backgroundImage.position)
        }
    }
    
    //Starts timer in motion, calls updateCounting every second
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    
    //Waits a while at beginning of game, then begins to calculate
    @objc func updateCounting(){
        time += 1
        //print(time)
        addWorm()
    }
    
    
    func animateWormLabel(){
        
        if wormsEaten == 1 {
            let scaleUpAction = SKAction.scale(to: 1.1, duration: 0.3)
            wormsEatenLabel.fontColor = UIColor.orange
            wormsEatenLabel.run(scaleUpAction)
        }
        
        if wormsEaten == 2 {
            let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.3)
            wormsEatenLabel.fontColor = UIColor.yellow
            wormsEatenLabel.run(scaleUpAction)
        }
        
        if wormsEaten == 3 {
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
        createLedge()
        createPlayerAndPosition()
        createElevationLabel()
        createRestartBtn()
        createPauseBtn()
        createWormsEatenLabel()
        
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
            if restartBtn.contains(location){
                dieAndRestart()
            } else {
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        timer.invalidate()
                        pauseBtn.texture = SKTexture(imageNamed: "play1")
                    } else {
                        self.isPaused = false
                        timer.fire()
                        pauseBtn.texture = SKTexture(imageNamed: "pause1")
                    }
                }
            }
        }
    }
    
    
    //Creates the bird and makes it flap its wings.
    func createScene(){
        self.bird = createBird()
        self.addChild(bird)
        
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        
        let animatebird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        self.repeatActionbird = SKAction.repeatForever(animatebird)
    }
    
    
    //Restarts the game once the bird hits the bottom of the screen
    func dieAndRestart() {
        bird.physicsBody?.velocity.dy = 0
        
        let scene = GameScene(size: size)
        view?.presentScene(scene)
        
        totalClickCounter = 0
        altitude = 0.0
        
        timer.invalidate()
    }
    
    
    //    function to shake screen. used in power up func
    func shakeCamera(layer:SKSpriteNode, duration:Float) {
        
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        
        let actionSeq = SKAction.sequence(actionsArray);
        layer.run(actionSeq);
    }
    
    
    //Function to emit spark particles at worm position when worm collides with bird
    func newFlyNode(scene: SKScene, Bird: SKNode) {
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
    
    
    
    //    Collecting enough worms will apply an upward force to the bird
    func powerUp(){
        if wormsEaten.truncatingRemainder(dividingBy: 3)==0 && wormsEaten>1{
            bird.physicsBody?.applyForce(CGVector(dx: 0, dy: 3000))
            shakeCamera(layer: bird, duration: 1.0)
            newFlyNode(scene: self, Bird: bird)
            
            
        }
    }
    
    
    
    //Function that adds worms to screen
    func addWorm() {
        
        // Create sprite
        let worm = SKSpriteNode(imageNamed: "dragonfly.png")
        
        worm.physicsBody = SKPhysicsBody(rectangleOf: worm.size) // 1
        worm.physicsBody?.isDynamic = true// 2
        worm.physicsBody?.affectedByGravity = false
        worm.physicsBody?.categoryBitMask = PhysicsCategory.Worm // 3
        worm.physicsBody?.collisionBitMask = PhysicsCategory.Worm // 5
        worm.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        // Determine where to spawn the worm along the Y axis
        let actualY = bird.position.y + size.height/2
        
        // Position the worm
        worm.position = CGPoint(x: random(min:10, max: size.width-10 ), y: actualY)
        
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
    
    
    //function to remove worm when it collides with bird
    func collisionBetween(worm: SKNode, bird: SKNode) {
        worm.removeFromParent()
        wormsEaten += 1
        animateWormLabel()
        wormsEatenLabel.text = String("Worms: ") + String(describing: (Int(wormsEaten)))
        newSparkNode(scene: self, Worm: worm)
    }
    
    
    //function to check for collision between worm and bird
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
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
        
        // 2
        if (firstBody.categoryBitMask != secondBody.categoryBitMask) {
            if let worm = secondBody.node as? SKSpriteNode, let bird = firstBody.node as? SKSpriteNode {
                collisionBetween(worm: worm, bird: bird)
            }
        }
    }
    
    
    //Scrolling background - parallax
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "iconBackground")
        
        for i in 0 ... 6 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = 0
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: 0, y: (backgroundTexture.size().height * CGFloat(i) - CGFloat(1 * i)))
            addChild(background)
            
            let moveUp = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveUp, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    
    
    //Perform Necessary Background checks, making changes as necesary called in continously in update()
    func adjustBackground(){
        
        //Adds the next background when the bird is close enough
        if (bird.position.y > backgroundHeight*size.height*currentBackground - size.height){
            //Check if at end of BackgroundImages array, if so, re-add last Image
            if currentBackground >= CGFloat(backgroundImages.count) {
                let backgroundImage = SKSpriteNode(imageNamed: backgroundNames.last!)
                backgroundImage.xScale=size.width/backgroundImage.size.width
                backgroundImage.yScale=size.height/backgroundImage.size.height*backgroundHeight
                backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                backgroundImage.position = CGPoint(x: size.width/2, y: backgroundImage.size.height*currentBackground)
                backgroundImage.zPosition = -1
                backgroundImages.append(backgroundImage)
            }
            addChild(backgroundImages[Int(currentBackground)])
            currentBackground += 1
        }
        
        //Removes the previous background when the bird is far enough above it
        if (bird.position.y > backgroundHeight * size.height * (previousBackground + 1) + size.height){
            (backgroundImages[Int(previousBackground)]).removeFromParent()
            previousBackground += 1
        }
    }
    
    
    //Allows the bird to move left and right when phone tilts
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
        if let bird = childNode(withName: birdName) as? SKSpriteNode {
            if let data = motionManager.accelerometerData {
                if fabs(data.acceleration.x) > 0.2 {
                    //print("Acceleration: \(data.acceleration.x)")
                    bird.physicsBody!.applyForce(CGVector(dx: 100 * CGFloat(data.acceleration.x), dy: 0))
                }
            }
        }
    }
    
    
    
    //Changes gravity of the physics World
    func calculateGravity(){
        //Logistic Function for gravity increase, can graph this at
        //www.desmos.com/calculator/agxuc5gip8
        
        let gravity = CGFloat(-1*(65 / (1+(100 * (pow(M_E, -0.025 * totalClickCounter)))))-14)
        physicsWorld.gravity.dy = gravity
        
    }
    
    
    //Updates the text of the labels on the game screen
    func adjustLabels(){
        
        altitude = floor(bird.position.y - (ledge.position.y + 10) - 28)
        if (altitude >= maxAltitude) {
            maxAltitude = altitude
        }
        elevationLabel.text = String(describing: Int(altitude/10)) + String(" ft")
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
    
    
    //Updates several parts of the game, including background/bird/labels/gravity
    override func update(_ currentTime: TimeInterval) {
        processUserMotion(forUpdate: currentTime)
        calculateGravity()
        adjustLabels()
        adjustBackground()
        powerUp()
        
        //DON'T KNOW WHAT THIS CODE DOES, CAN THE PERSON THAT WROTE IT PUT IT IN A FUNCTION/ COMMENT?
        let playerPositionInCamera = cameraNode.convert(bird.position, from: self)
        if playerPositionInCamera.y > 0 {
            cameraNode.position.y = bird.position.y
        }
        if playerPositionInCamera.y < -size.height / 2.0 {
            dieAndRestart()
        }
    }
}

