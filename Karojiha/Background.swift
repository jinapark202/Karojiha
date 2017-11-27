//
//  Background.swift
//  Karojiha
//
//  Created by Kai Heen on 11/27/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene{

    
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
    
    
    
    func addBackgroundFlavor(){
        var choicesForImage = [String]()
        
        if currentBackground <= 4 {
            choicesForImage = bgFlavorImages[Int(currentBackground)]!
        }
        else{
            choicesForImage = bgFlavorImages[5]!
        }
        
        let randomIndex = random(min: 0, max: CGFloat((choicesForImage.endIndex)))
        let chosenImage = choicesForImage[Int(randomIndex)]
        createFlavorSprite(imageName: chosenImage)
        
    }
    
    
    
    //Called in addBackgroundFlavor()
    
    func createFlavorSprite(imageName: String){
        let flavorSprite = SKSpriteNode(imageNamed: imageName)
        addChild(flavorSprite)
        flavorSprite.position = bird.position
        flavorSprite.position.y += size.height
        
        
        let moveAction = SKAction.moveBy(x:0, y: -1100, duration: 5.1)
        let deleteAction = SKAction.removeFromParent()
        let flavorAction = SKAction.sequence([moveAction, deleteAction])
        flavorSprite.run(flavorAction)
        
    }
    
 
    
    //Scrolling background - parallax
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "dotsBackground")
        
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
    
    
    
}
