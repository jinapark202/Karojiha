//
//  MenuScene.swift
//  Karojiha
//
//  Created by Hannah Gray  on 11/19/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate {
    
    let playLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let message = "Play"
        playLabel.text = message
        playLabel.fontSize = 60
        playLabel.fontColor = SKColor.white
        playLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(playLabel)
        playLabel.run(SKAction.scale(to: 1.0, duration: 0.0))

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if playLabel.contains(location){
                let reveal = SKTransition.moveIn(with: .down,
                                                 duration: 0.5)
                let gameScene = GameScene(size: size)
                self.view?.presentScene(gameScene, transition: reveal)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
