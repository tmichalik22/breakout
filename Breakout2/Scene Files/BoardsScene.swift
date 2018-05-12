//
//  BoardsScene.swift
//  Breakout2
//
//  Created by Todd Michalik on 4/28/18.
//  Copyright © 2018 Todd Michalik. All rights reserved.
//

import SpriteKit

var WINS = "Wins"
var LOSSES = "Losses"

class BoardsScene : SKScene {
    var boardsSceneLabel : SKLabelNode!
    var winsLabel : SKLabelNode!
    var lossesLabel : SKLabelNode!
    var GameScene1 : SKSpriteNode!
    var GameScene2 : SKSpriteNode!
    var GameScene3 : SKSpriteNode!
    var GameScene4 : SKSpriteNode!
    
    var defaultWins = 0
    var defaultLosses = 0
    
    let defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        boardsSceneLabel = self.childNode(withName: "boardsSceneLabel") as! SKLabelNode
        winsLabel = self.childNode(withName: "winsLabel") as! SKLabelNode
        lossesLabel = self.childNode(withName: "lossesLabel") as! SKLabelNode
        GameScene1 = self.childNode(withName: "GameScene1") as! SKSpriteNode
        GameScene2 = self.childNode(withName: "GameScene2") as! SKSpriteNode
        GameScene3 = self.childNode(withName: "GameScene3") as! SKSpriteNode
        GameScene4 = self.childNode(withName: "GameScene4") as! SKSpriteNode
        getDefaults()
    }
    
    func getDefaults() {
        //checking for persistent wins and losses or settinig default values
        if let wins = defaults.string(forKey: WINS), let losses = defaults.string(forKey: LOSSES) {
            winsLabel.text = "Wins: " + String(wins)
            lossesLabel.text = "Losses: " + String(losses)
        } else {
            defaults.set(defaultWins, forKey: WINS)
            defaults.set(defaultLosses, forKey: LOSSES)
            winsLabel.text = "Wins: " + String(defaultWins)
            lossesLabel.text = "Losses: " + String(defaultLosses)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if GameScene1.contains(location) {
                if let gameScene = SKScene(fileNamed: "GameScene") {
                    self.view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
            }
            } else if GameScene2.contains(location) {
                if let gameScene2 = SKScene(fileNamed: "GameScene2") {
                    self.view?.presentScene(gameScene2, transition: SKTransition.doorsOpenVertical(withDuration: 1.0))
                }
            } else if GameScene3.contains(location) {
                if let gameScene3 = SKScene(fileNamed: "GameScene3") {
                    self.view?.presentScene(gameScene3, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
                }
            } else if GameScene4.contains(location) {
                if let gameScene4 = SKScene(fileNamed: "GameScene4") {
                    self.view?.presentScene(gameScene4, transition: SKTransition.doorsOpenVertical(withDuration: 1.0))
                }
            }
       }
    }
}
