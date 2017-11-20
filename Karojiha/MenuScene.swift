//
//  MenuScene.swift
//  Karojiha
//
//  Created by Hannah Gray  on 11/19/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScreen: SKScene, SKPhysicsContactDelegate {
    override init(size: CGSize) {
        
        super.init(size: size)
        
//        let message = "Play"
//        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
//        gameOverLabel.text = message
//        gameOverLabel.fontSize = 60
//        gameOverLabel.fontColor = SKColor.white
//        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/1.25)
//        addChild(gameOverLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
