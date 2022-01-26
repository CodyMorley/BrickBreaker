//
//  GameScene.swift
//  BlockBreakerGame
//
//  Created by Cody Morley on 1/26/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    //Properties
    //published
    @Published var level: Int = 1
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    //objects
    let ball = SKShapeNode(circleOfRadius: CGFloat(12))
    let paddle = SKSpriteNode(color: SKColor(.white),
                              size: CGSize(width: 120, height: 16))
    let floor = SKSpriteNode(color: SKColor(.clear),
                             size: CGSize(width: UIScreen.main.bounds.width, height: 20))
    
    
    //Methods
    //SKScene life cycle
    override func didMove(to view: SKView) {
        //set size and color
        self.size = CGSize(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
        scene?.scaleMode = .fill
        backgroundColor = .black
        
        // set physics boundaries & values
        let border = SKPhysicsBody(edgeLoopFrom: frame)
        border.friction = 0
        physicsBody = border
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // Call functions to populate game with new objects
        startNewGame()
    }
    
    //Gameplay Methods
    func makeBall() {
        ball.name = "ball"
        ball.fillColor = SKColor.white
        ball.position = CGPoint(x: UIScreen.main.bounds.width / 2,
                                y: UIScreen.main.bounds.height / 1.6)
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 24,
                                                             height: 24))
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        
        addChild(ball)
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 8, dy: -8))
    }
    
    func makeBricks() {
        let rows = [
            Row(color: .red, positionY: UIScreen.main.bounds.height / 1.14),
            Row(color: .red, positionY: UIScreen.main.bounds.height / 1.17),
            Row(color: .orange, positionY: UIScreen.main.bounds.height / 1.202),
            Row(color: .orange, positionY: UIScreen.main.bounds.height / 1.235),
            Row(color: .green, positionY: UIScreen.main.bounds.height / 1.272),
            Row(color: .green, positionY: UIScreen.main.bounds.height / 1.310),
            Row(color: .yellow, positionY: UIScreen.main.bounds.height / 1.350),
            Row(color: .yellow, positionY: UIScreen.main.bounds.height / 1.392),
        ]
        rows.forEach {
            makeRows(color: $0.color, positionY: $0.positionY)
        }
    }
    
    func makeRows(color: UIColor, positionY: CGFloat) {
        let numberOfBricks = 8
        let brickWidth: CGFloat = 50
        let brickHeight: CGFloat = 16
        let rowWidth = brickWidth * CGFloat(numberOfBricks)
        let xOffset = (frame.width - rowWidth) / 2
        
        for i in 0..<numberOfBricks {
            let brick = SKSpriteNode(color: color,
                                     size: CGSize(width: 35, height: brickHeight))
            brick.name = "brick"
            brick.position = CGPoint(x: xOffset + CGFloat(CGFloat(i) + 0.5) * brickWidth,
                                     y: positionY)
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.frame.size)
            brick.physicsBody?.allowsRotation = false
            brick.physicsBody?.friction = 0
            brick.physicsBody?.isDynamic = false
            addChild(brick)
        }
    }
    
    func makeFloor() {
        floor.name = "floor"
        floor.position = CGPoint(x: UIScreen.main.bounds.width / 2,
                                 y: 12)
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: UIScreen.main.bounds.width,
                                                              height: 24))
        floor.physicsBody?.allowsRotation = false
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.contactTestBitMask = floor.physicsBody!.collisionBitMask
        
        addChild(floor)
    }
    
    func makePaddle() {
        paddle.name = "paddle"
        paddle.position = CGPoint(x: UIScreen.main.bounds.width / 2,
                                  y: 40)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 120,
                                                               height: 24))
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.restitution = 1
        paddle.physicsBody?.allowsRotation = false
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.contactTestBitMask = paddle.physicsBody!.collisionBitMask
        
        let edgeConstraint = SKConstraint.positionX(SKRange(lowerLimit: 64,
                                                            upperLimit: UIScreen.main.bounds.width - 64))
        paddle.constraints = [edgeConstraint]
        
        addChild(paddle)
    }
    
    func startNewGame() {
        level = 1
        score = 0
        makeBall()
        makePaddle()
        makeBricks()
        makeFloor()
    }
    
    //interactivity
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        paddle.position = CGPoint(x: location.x, y: 40)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "brick" {
            removeBrickFromParent(contact.bodyB.node!)
            updateScore(1)
            
            if children.count <= 3 {
                ball.removeFromParent()
                level += 1
                
                makeBall()
                makeBricks()
            }
        }
        
        if contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "floor" {
            ball.removeFromParent()
            isGameOver.toggle()
        }
    }
    
    func removeBrickFromParent(_ node: SKNode) {
        node.removeFromParent()
    }
    
    func updateScore(_ newScore: Int) {
        score += newScore
    }
}

struct Row {
    let color: UIColor
    let positionY: CGFloat
}
