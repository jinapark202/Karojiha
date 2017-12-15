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
    
    let position: CGPoint
    let imageName: String
    let size: CGSize
    let parentScene: SKScene
    let camera: SKCameraNode
    
    
    init(position: CGPoint, imageName: String, size: CGSize, parentScene: SKScene, camera: SKCameraNode? = nil) {
        self.position = position
        self.imageName = imageName
        self.size = size
        self.parentScene = parentScene
        self.camera = camera
    }
    
    //TODO: Getters and setters
    
    
    
    
    func add(){
        if camera != nil{
            camera.addChild(self)
        }
        else{
            parentScene.addChild(self)
        }
    }
    
    
    
    
}
