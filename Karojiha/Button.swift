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
    
//    let parentScene: SKScene
    var camera: SKCameraNode?
    
    
    init(position: CGPoint, imageName: String, size: CGSize, cameraNode: SKCameraNode) {
        //Initialize a SKSpriteNode
//        self.parentScene = parentScene
//        self.camera = camera!
        let texture = SKTexture(imageNamed: imageName)
        self.camera = cameraNode
        super.init(texture: texture, color: UIColor.black, size: texture.size())
        super.position = position
        super.size = size
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func addToCamera(){
        camera?.addChild(self)
//        self.parentScene.addChild(self)
    }
    
    
    
    
}
