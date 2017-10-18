//
//  GameScene.swift
//  Karojiha
//
//  Created by Jina Park on 10/11/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    struct PhysicsCategory {
        static let Player: UInt32 = 1
        static let Obstacle: UInt32 = 2
        static let Edge: UInt32 = 4
    }
    
    //Variables for click counter.
    var counter = 0
    let clickLabel = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()

    
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    var repeatActionbird = SKAction()
    let playerBody = SKPhysicsBody(circleOfRadius: 30)
    
    var obstacles: [SKNode] = []
    let obstacleSpacing: CGFloat = 800
    let cameraNode = SKCameraNode()
    let ledge = SKNode()

    //Add desired background images to this array of strings. Makes sure background images are in Assets.xcassets
    let backgroundNames: [String] = ["bg0","bg3","bg2"]
    var backgroundImages: [SKNode] = []
    let backgroundHeight = CGFloat(3.0) //This is height of background in terms of # of screens
    var currentBackground: CGFloat = 1.0
    var previousBackground: CGFloat = 0.0
    
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
        playerBody.mass = 1.5
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = 4
        bird.physicsBody = playerBody
        bird.position = CGPoint(x: ledge.position.x, y: ledge.position.y + 10)
    }
    
    //This function creates SKSpriteNode Objects for all background images, and adds them to an array (backgroundImages)
    func initBackgroundArray(names: [String]){
        var x: CGFloat = 0.0
        for i in names{
            let backgroundImage = SKSpriteNode(imageNamed: i)
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
    
    //Adds the first background to the screen and sets up the scene.
    override func didMove(to view: SKView) {
        createScene()
        createLedge()
        createPlayerAndPosition()
        createClickLabel()
        createRestartBtn()
        createPauseBtn()
    
        initBackgroundArray(names: backgroundNames)
        addChild(backgroundImages[0])
        
        physicsWorld.gravity.dy = -15
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
    }
    
    //Makes the bird flap its wings once screen is clicked, adds a number to the counter every time screen is clicked.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        counter += 1
        
        bird.physicsBody?.velocity.dy = 600.0
        
        self.bird.run(repeatActionbird)
        
        //Implements the pause and restart button functionality
        for touch in touches{
            var location = touch.location(in: self)
            //Adjust for cameraNode position
            location.x-=cameraNode.position.x
            location.y-=cameraNode.position.y
            if restartBtn.contains(location){
                dieAndRestart()
            } else {
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
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
        
        // TESTING OBSTACLE CODE
        //        for node in obstacles {
        //            node.removeFromParent()
        //        }
        //
        //        obstacles.removeAll()
        //
        //        addObstacle()
        //        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
        let scene = GameScene(size: size)
        view?.presentScene(scene)
        
        counter = 0
        clickLabel.text = String(counter)
    }
    
    
    //TESTING OBSTACLE CODE
    
//    func addObstacle() {
//        addSquareObstacle()
//    }
//
//    func addSquareObstacle() {
//        let path = UIBezierPath(roundedRect: CGRect.init(x: -200, y: -200,
//                                                         width: 400, height: 40),
//                                cornerRadius: 20)
//
//        let obstacle = obstacleByDuplicatingPath(path, clockwise: false)
//        obstacles.append(obstacle)
//        obstacle.position = CGPoint(x: size.width/2, y: obstacleSpacing * CGFloat(obstacles.count))
//        addChild(obstacle)
//    }
//
//    func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool) -> SKNode {
//        let container = SKNode()
//        let section = SKShapeNode(path: path.cgPath)
//        container.addChild(section)
//        return container
//    }

    
    //Updates the position of the bird and background, updates the click counter
    override func update(_ currentTime: TimeInterval) {
        
        clickLabel.text = String("Clicks: ") + String(counter)

        //Adds the next background when the bird is close enough
        if (bird.position.y > backgroundHeight*size.height*currentBackground - size.height){
            addChild(backgroundImages[Int(currentBackground)])
            currentBackground += 1
        }
        
        //Removes the previous background when the bird is far enough above it
        if (bird.position.y > backgroundHeight * size.height * (previousBackground + 1) + size.height){
            (backgroundImages[Int(previousBackground)]).removeFromParent()
            previousBackground += 1
        }
        
        // TESTING OBSTACLE CODE
//        if bird.position.y > obstacleSpacing * CGFloat(obstacles.count - 2) {
//            addObstacle()
//        }
        
        let playerPositionInCamera = cameraNode.convert(bird.position, from: self)
        if playerPositionInCamera.y > 0 {
            cameraNode.position.y = bird.position.y
        }
        if playerPositionInCamera.y < -size.height / 2.0 {
            dieAndRestart()
        }
    }
}
