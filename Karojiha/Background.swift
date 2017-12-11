//
//  Background.swift
//  Karojiha
//
//  Created by Kai Heen on 11/27/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit

class Background {

    var size = CGSize.zero
    weak var scene: SKScene? {
        didSet {
            self.size = scene?.size ?? CGSize.zero
            //initBackgroundArray(names: backgroundNames)
        }
    }
    
    //Add desired background images to this array of strings. Makes sure background images are in Assets.xcassets
    let backgroundNames = ["background1","background2","background3","background4New","testStarsBg"]

    var backgroundImages: [SKNode] = []
    let backgroundHeight = CGFloat(8.0)
    var currentBackground: CGFloat = 1.0
    var previousBackground: CGFloat = 0.0
    var bgFlavorCheckpoint = CGFloat(0.0)
    let flavorFrequency = CGFloat(500.0)
    
    var bgFlavorImages  = [
        1: ["background1Cloud"],   //First background (light blue)
        2: [],
        3: [],
        4: [],
        5: ["comet", "planet"]    //Last background (Space)
    ]

    //This function creates SKSpriteNode Objects for all background images, and adds them to an array (backgroundImages)
    func initBackgroundArray(names: [String]){
        var x: CGFloat = 0.0
        for bgName in names {
            let backgroundImage = SKSpriteNode(imageNamed: bgName)
            backgroundImage.xScale = size.width/backgroundImage.size.width
            backgroundImage.yScale = size.height/backgroundImage.size.height*backgroundHeight
            backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            backgroundImage.position = CGPoint(x: size.width/2, y: backgroundImage.size.height*x)
            backgroundImage.zPosition = -5
            backgroundImages.append(backgroundImage)
            x += 1
        }
        
        let mountainImage = SKSpriteNode(imageNamed: "mountains_700")
        mountainImage.size = CGSize(width: size.width, height: size.height/1.05)
        mountainImage.position = CGPoint(x: size.width/2, y: size.height/3)
        mountainImage.zPosition = 1
        
        scene?.addChild(backgroundImages[0])
        scene?.addChild(mountainImage)

    }
    
    
    //Perform Necessary Background checks, making changes as necesary... called in continously in update()
    func adjust(forBirdPosition position: CGPoint){
        
        //Adds the next background when the bird is close enough
        if (position.y > backgroundHeight * size.height * currentBackground - size.height){
            
            //Check if at end of BackgroundImages array, if so, re-add last Image
            if currentBackground >= CGFloat(backgroundImages.count) {
                let backgroundImage = SKSpriteNode(imageNamed: backgroundNames.last!)
                backgroundImage.xScale = size.width / backgroundImage.size.width
                backgroundImage.yScale = size.height / backgroundImage.size.height * backgroundHeight
                backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.0)
                backgroundImage.position = CGPoint(x: size.width/2, y: backgroundImage.size.height * currentBackground)
                backgroundImage.zPosition = -2
                backgroundImages.append(backgroundImage)
            }
            scene?.addChild(backgroundImages[Int(currentBackground)])
            currentBackground += 1
        }
        
        //Removes the previous background when the bird is far enough above it
        if (position.y > backgroundHeight * size.height * (previousBackground + 1) + size.height){
            (backgroundImages[Int(previousBackground)]).removeFromParent()
            previousBackground += 1
        }
    }
    
    //Adds images to the background, choosing randomly from the correct array in bgFlavorImages
    func addBackgroundFlavor(forBirdPosition position: CGPoint){
        if position.y > flavorFrequency + bgFlavorCheckpoint {
            bgFlavorCheckpoint = position.y
            
            var choicesForImage = [String]()
            if currentBackground <= 4 {
                choicesForImage = bgFlavorImages[Int(currentBackground)]! }
            else {
                choicesForImage = bgFlavorImages[5]! }
            
            if choicesForImage.count > 0 {
                let randomIndex = random(min: 0, max: CGFloat((choicesForImage.endIndex)))
                let chosenImage = choicesForImage[Int(randomIndex)]
                createFlavorSprite(imageName: chosenImage, forBirdPosition: position)
            }
            
        }
        
    }
    
    
    //Called in addBackgroundFlavor()
    func createFlavorSprite(imageName: String, forBirdPosition position: CGPoint){
        let flavorSprite = SKSpriteNode(imageNamed: imageName)
        scene?.addChild(flavorSprite)
        flavorSprite.position = position
        flavorSprite.position.y += size.height
        
        let moveAction = SKAction.moveBy(x:0, y: -1100, duration: 5.1)
        let deleteAction = SKAction.removeFromParent()
        let flavorAction = SKAction.sequence([moveAction, deleteAction])
        flavorSprite.run(flavorAction)
        
    }
    
    // Code altered from https://www.hackingwithswift.com/read/36/3/sky-background-and-ground-parallax-scrolling-with-spritekit
    //Scrolling background - parallax
    func createParallax() {
        let backgroundTexture = SKTexture(imageNamed: "parallax_125")
        
        for i in 0 ... 50 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -1.5
            background.anchorPoint = CGPoint.zero
            background.xScale = size.width / background.size.width
            background.yScale = size.height / background.size.height * backgroundHeight
            background.position = CGPoint(x: 0, y: (backgroundTexture.size().height * CGFloat(i) - CGFloat(1 * i)))
            scene?.addChild(background)
            
            let moveUp = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 10)
            let moveReset = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveUp, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
}
