//
//  File.swift
//  Karojiha
//
//  Created by Kai Heen on 12/15/17.
//  Copyright © 2017 Macalester College. All rights reserved.
//

import Foundation
import SpriteKit


class Button: SKSpriteNode{
    
    init(position:CGPoint, imageName: String, size: CGSize) {
        
        let texture = SKTexture(imageNamed: imageName)
        
        //Have to call this SKSpriteNode constructor
        super.init(texture: texture, color: UIColor.black, size: texture.size())
        super.position = position
        super.size = size
        super.zPosition = 10
    }
    
    //Adds button to camera node
    func addToCamera(parentCamera: SKCameraNode){
        parentCamera.addChild(self)
    }
    
    //Adds button to game scene
    func addToScene(parentScene: SKScene){
        parentScene.addChild(self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
