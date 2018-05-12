//
//  MenuScene.swift
//  Breakout2
//
//  Created by Todd Michalik on 4/28/18.
//  Copyright © 2018 Todd Michalik. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene {
    var playButtonLabel : SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        playButtonLabel = self.childNode(withName: "playButtonLabel") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if playButtonLabel.contains(location) {
                if let gameScene = SKScene(fileNamed: "BoardsScene") {
                    self.view?.presentScene(gameScene, transition: SKTransition.flipHorizontal(withDuration: 1.0))
                }
            }
        }
    }
}
