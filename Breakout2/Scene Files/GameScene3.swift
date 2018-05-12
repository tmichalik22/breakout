//
//  GameScene3.swift
//  Breakout2
//
//  Created by Todd Michalik on 4/29/18.
//  Copyright © 2018 Todd Michalik. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene3: SKScene, SKPhysicsContactDelegate {
    var ball : SKSpriteNode!
    var brick : SKSpriteNode!
    var paddle : SKSpriteNode!
    var scoreLabel : SKLabelNode!
    var resultLabel : SKLabelNode!
    let brickCollideSound = SKAction.playSoundFileNamed("Brick_Collide_Sound", waitForCompletion: false)
    let winGameSound = SKAction.playSoundFileNamed("Win-Sound-2", waitForCompletion: true)
    let loseGameSound = SKAction.playSoundFileNamed("Lose-Sound-2", waitForCompletion: true)
    var xStartGameState = [14, 16, 18, 20]
    var yStartGameState = [-14, -16, -18, -20]
    var score = 0
    var defaultWins = 0
    var defaultLosses = 0
    
    let defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        brick = self.childNode(withName: "Brick") as! SKSpriteNode
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        resultLabel = self.childNode(withName: "resultLabel") as! SKLabelNode
        
        //set background music
        let backgroundSound = SKAudioNode(fileNamed: "Background-Music-4.wav")
        self.addChild(backgroundSound)
        
        //define game border for ball to not bounce off screen
        let gameBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        gameBorder.friction = 0
        gameBorder.restitution = 1
        self.physicsBody = gameBorder
        self.physicsWorld.contactDelegate = self as? SKPhysicsContactDelegate
        
        //ball trail effect
        let ballTrailNode = SKNode()
        ballTrailNode.zPosition = 1
        addChild(ballTrailNode)
        let ballTrail = SKEmitterNode(fileNamed: "ballTrail")!
        ballTrail.targetNode = ballTrailNode
        ball.addChild(ballTrail)
        
        beginGame()
    }
    
    func beginGame() {
        //begin game set score to zero, set random start impulse of ball
        score = 0
        scoreLabel.text = "Score: " + "\(score)"
        let xRandom = xStartGameState[Int(arc4random_uniform(UInt32(xStartGameState.count)))]
        let yRandom = yStartGameState[Int(arc4random_uniform(UInt32(yStartGameState.count)))]
        ball.physicsBody?.applyImpulse(CGVector(dx: xRandom, dy: yRandom))
    }
    
    func updateScore() {
        score += 1
        scoreLabel.text = "Score: " + "\(score)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //setting a contact body name to the brick and ball
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        
        //checking if the ball has made contact with the brick if so run collide sound, update score and remove brick
        if bodyA == "Ball" && bodyB == "Brick" || bodyA == "Brick" && bodyB == "Ball" {
            if bodyA == "Brick" {
                run(brickCollideSound)
                updateScore()
                contact.bodyA.node?.removeFromParent()
            } else if bodyB == "Brick" {
                run(brickCollideSound)
                updateScore()
                contact.bodyB.node?.removeFromParent()
            }
        }
    }
    
    //Code reference: Michael Briscoe - www.raywenderlich.com/129904/create-breakout-game-sprite-kit-swift-part-2
    //Helper function for checking ball speed and random direction
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    //Helper function for checking ball speed and creating a random direction
    func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 3.0
        if randomFloat(from: 0.0, to: 100.0) >= 50 {
            return -speedFactor
        } else {
            return speedFactor
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //checks speed of ball to see if it falls below 10 or above 10 so it doesn't get caught going straight up-down
        let ball = scene?.childNode(withName: "Ball") as! SKSpriteNode
        
        let xBallSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        let yBallSpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        if xBallSpeed <= 10.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
        }
        if yBallSpeed <= 10.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
        } //end of code reference
        
        //Checking if all the bricks have been broken or if ball went past the paddle result Win or Lose
        if score == 24 {
            var winsTotal = 0
            resultLabel.text = "You Won"
            run(winGameSound)
            if var wins = defaults.string(forKey: WINS) {
                winsTotal = Int(wins)! + 1
                wins = String(winsTotal)
                defaults.set(wins, forKey: WINS)
            } else {
                defaults.set(defaultWins, forKey: WINS)
            }
            if let endOfGame = SKScene(fileNamed: "BoardsScene") {
                self.view?.presentScene(endOfGame, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
            }
        }
        
        if (ball.position.y < paddle.position.y) {
            resultLabel.text = "You Lose"
            run(loseGameSound)
            var lossesTotal = 0
            if var losses = defaults.string(forKey: LOSSES) {
                lossesTotal = Int(losses)! + 1
                losses = String(lossesTotal)
                defaults.set(losses, forKey: LOSSES)
            } else {
                defaults.set(defaultLosses, forKey: LOSSES)
            }
            if let endOfGame = SKScene(fileNamed: "BoardsScene") {
                self.view?.presentScene(endOfGame, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
            }
        }
    }
}
