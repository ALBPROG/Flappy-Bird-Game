
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    
    var scoreLabel = SKLabelNode()
    
    var gameoverLabel = SKLabelNode()
    
    var bird = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var pipe1 = SKSpriteNode()
    
    var pipe2 = SKSpriteNode()
    
    var movingObjects = SKSpriteNode()
    
    var labelContainer = SKSpriteNode()
    
    enum ColliderType: UInt32 {
        
        case bird = 1
        case object = 2
        case gap = 4
        
    }
    
    var gameOver = false
    
    func makebg() {
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let movebg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let movebgForever = SKAction.repeatForever(SKAction.sequence([movebg, replacebg]))
        
        
        for i in 0 ..< 3 {
            _ = CGFloat(i)
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * CGFloat(i), y: self.frame.midY)
            
            bg.size.height = self.frame.height
            
            bg.zPosition = -5
            
            bg.run(movebgForever)
            
            movingObjects.addChild(bg)
            
        }

    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        
        makebg()
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
    
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        bird.physicsBody!.isDynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody!.categoryBitMask = ColliderType.bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        //added allowRotation property and set to false - to disable the effect of rotation when collides with a pipe
        bird.physicsBody!.allowsRotation = false
        
        
        self.addChild(bird)
        
        // changed ground from var to let
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        self.addChild(ground)
        
        
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameScene.makePipes), userInfo: nil, repeats: true)
        
        
    }
    
    func makePipes() {
        
        let gapHeight = bird.size.height * 4
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        let movePipes = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: TimeInterval(self.frame.size.width / 100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        //changed pipeTexture and pipe1 from var to let
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY + pipeTexture.size().height/2 + gapHeight / 2 + pipeOffset)
        pipe1.run(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe1.physicsBody!.isDynamic = false
        
        pipe1.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        pipe1.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.object.rawValue

        
        movingObjects.addChild(pipe1)
        
        //changed pipe2Texture and pipe2 from var to let
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY - pipe2Texture.size().height/2 - gapHeight / 2 + pipeOffset)
        pipe2.run(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        movingObjects.addChild(pipe2)
        
        //changed gap variable from var to let
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY + pipeOffset)
        gap.run(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipe1.size.width, height: gapHeight))
        gap.physicsBody!.isDynamic = false
        
        gap.physicsBody!.categoryBitMask = ColliderType.gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.bird.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.gap.rawValue
        
        movingObjects.addChild(gap)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.gap.rawValue {
            
            score += 1
            
            scoreLabel.text = String(score)
            
        } else {
            
            if gameOver == false {
        
                gameOver = true
        
                self.speed = 0
            
                gameoverLabel.fontName = "Helvetica"
                gameoverLabel.fontSize = 30
                gameoverLabel.text = "Game Over! Tap to play again."
                gameoverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                labelContainer.addChild(gameoverLabel)
                
            }
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
       
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50))
        
        } else {
            
            score = 0
            
            scoreLabel.text = "0"
            
            bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            
            movingObjects.removeAllChildren()
            
            makebg()
            
            self.speed = 1
            
            gameOver = false
            
            labelContainer.removeAllChildren()
            
        }
        }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
