//
//  Frozen.m
//  Bounce
//
//  Created by Andrea Compton on 4/10/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import "Frozen.h"
#import "GameOver.h"

SKLabelNode *_lblScore;
SKLabelNode *_lblLife;
BOOL gameOverFrozen = NO;
static const uint32_t elsaCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;
static const uint32_t olafCategory = 0x1 << 2;

static const float BG_VELOCITY = 35.0;
static const float ice_VELOCITY = 225.0;
static const float SPEED = 2;


static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

@implementation Frozen {
    
    SKSpriteNode *elsa;
    SKAction *actionMoveUp;
    SKAction *actionMoveDown;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    NSTimeInterval _lasticeAdded;
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
       
        [self initalizingScrollingBackgroundFrozen];
        [self addElsa];
        
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,-5);
        self.physicsWorld.contactDelegate = self;
        self.size = size;
        //self.score = 0;
        [GameState sharedInstance].score = 0;
        [GameState sharedInstance].life = 100;
        gameOverFrozen = NO;
        
        _lblLife = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        _lblLife.fontSize = 30;
        _lblLife.fontColor = [SKColor blackColor];
        _lblLife.position = CGPointMake(20, self.size.height-40);
        _lblLife.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [_lblLife setText:[NSString stringWithFormat:@"Life: %d", [GameState sharedInstance].life]];
        [self addChild:_lblLife];
        
        _lblScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        _lblScore.fontSize = 30;
        _lblScore.fontColor = [SKColor blackColor];
        _lblScore.position = CGPointMake(self.size.width-20, self.size.height-40);
        _lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        // 5
        [_lblScore setText:@"0"];
        [self addChild:_lblScore];
        
        //[self addChild:[self createFloor]];
        //[self addChild:[self createBall:CGPointMake(50, 50)]];
    }
    
    return self;
}

-(void)addElsa
{
    elsa = [SKSpriteNode spriteNodeWithImageNamed:@"elsa.png"];
    [elsa setScale:0.15];
    //Adding SpriteKit physicsBody for collision detection
    elsa.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:elsa.size];
    
    elsa.physicsBody.categoryBitMask = elsaCategory;
    elsa.physicsBody.dynamic = YES;
    elsa.physicsBody.contactTestBitMask = obstacleCategory | olafCategory;
    elsa.physicsBody.collisionBitMask = 0;
    elsa.physicsBody.usesPreciseCollisionDetection = YES;
    elsa.physicsBody.velocity = CGVectorMake(-1, -3);
    elsa.physicsBody.mass = 30;
    elsa.physicsBody.restitution=1;
    elsa.physicsBody.linearDamping=0;
    elsa.physicsBody.angularDamping=0;
    elsa.name = @"elsa";
    elsa.position = CGPointMake(self.size.width/3,self.size.height);
    actionMoveUp = [SKAction speedBy:SPEED duration:.8];
    actionMoveDown = [SKAction speedBy:-SPEED duration:.8];
    
    [self addChild:elsa];
}


-(void)addice
{
    //initalizing spaceelsa node
    SKSpriteNode *ice;
    ice = [SKSpriteNode spriteNodeWithImageNamed:@"ice.png"];
    [ice setScale:0.3];
    
    //Adding SpriteKit physicsBody for collision detection
    ice.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ice.size];
    ice.physicsBody.categoryBitMask = obstacleCategory;
    ice.physicsBody.dynamic = NO;
    //ice.physicsBody.velocity = CGVectorMake(-10, 0);
    ice.physicsBody.contactTestBitMask = elsaCategory;
    ice.physicsBody.collisionBitMask = 0;
    ice.physicsBody.usesPreciseCollisionDetection = YES;
    ice.name = @"ice";
    
    //selecting random y position for missile
    int r = arc4random() % 300;
    ice.position = CGPointMake(self.frame.size.width + 20,r);
    
    [self addChild:ice];
}

-(void)addOlaf
{
    //initalizing spaceelsa node
    SKSpriteNode *olaf;
    olaf = [SKSpriteNode spriteNodeWithImageNamed:@"olaf.png"];
    [olaf setScale:0.10];
    
    //Adding SpriteKit physicsBody for collision detection
    olaf.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:olaf.size];
    olaf.physicsBody.categoryBitMask = olafCategory;
    olaf.physicsBody.dynamic = NO;
    //ice.physicsBody.velocity = CGVectorMake(-10, 0);
    olaf.physicsBody.contactTestBitMask = elsaCategory;
    olaf.physicsBody.collisionBitMask = 0;
    olaf.physicsBody.usesPreciseCollisionDetection = YES;
    olaf.name = @"olaf";
    
    //selecting random y position for missile
    int r = arc4random() % 300;
    olaf.position = CGPointMake(self.frame.size.width + 20,r);
    
    [self addChild:olaf];
}

-(void)initalizingScrollingBackgroundFrozen
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"frozen"];
        //[bg setScale:0.5];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"frozen";
        [self addChild:bg];
    }
    
}

- (void)moveBgFrozen
{
    [self enumerateChildNodesWithName:@"frozen" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         //Checks if bg node is completely scrolled of the screen, if yes then put it at the end of the other node
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
    
    [self enumerateChildNodesWithName:@"olaf" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * fly = (SKSpriteNode *) node;
         CGPoint flyVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(flyVelocity,_dt);
         fly.position = CGPointAdd(fly.position, amtToMove);
     }];
}


-(void)moveice
{
    [self enumerateChildNodesWithName:@"ice" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * ice = (SKSpriteNode *) node;
         CGPoint iceVelocity = CGPointMake(-ice_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(iceVelocity,_dt);
         ice.position = CGPointAdd(ice.position, amtToMove);
         if(ice.position.x < -100)
         {
             [ice removeFromParent];
         }
     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    NSInteger dif = self.size.height - touchLocation.y;
    
    [self enumerateChildNodesWithName:@"elsa" usingBlock:^(SKNode *node, BOOL *stop) {
        node.physicsBody.velocity = CGVectorMake(0, node.physicsBody.velocity.dy + dif);
        if (node.position.y > self.size.height) {
            node.position = CGPointMake(self.size.width/3, self.size.height);
        }
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (gameOverFrozen) return;
    
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    if( currentTime - _lasticeAdded > 3)
    {
        _lasticeAdded = currentTime + 3;
        [self addice];
        [self addOlaf];
    }
    
    [self moveBgFrozen];
    [self moveice];
    
}


- (void)didSimulatePhysics {
    [self enumerateChildNodesWithName:@"elsa" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y <= 0) {
            node.physicsBody.velocity = CGVectorMake(0, -(5*node.physicsBody.velocity.dy)/6);
        }
        if (node.position.y < 0) {
            node.position = CGPointMake(self.size.width/3,0);
        }
        if (node.position.y > self.size.height) {
            node.position = CGPointMake(self.size.width/3, self.size.height);
            node.physicsBody.velocity = CGVectorMake(0, 0);
            
        }
    }];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & elsaCategory) != 0 &&
        (secondBody.categoryBitMask & obstacleCategory) != 0) {
        
        [GameState sharedInstance].life -= 50;
        [secondBody.node removeFromParent];
        [_lblLife setText:[NSString stringWithFormat:@"Life: %d", [GameState sharedInstance].life]];
        if ([GameState sharedInstance].life <= 0) {
            [self endGameFrozen];
        }
    }
    
    if ((firstBody.categoryBitMask & elsaCategory) != 0 &&
        (secondBody.categoryBitMask & olafCategory) != 0) {
        
        [GameState sharedInstance].score += 5;
        [secondBody.node removeFromParent];
        [_lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
    }
}

-(void)endGameFrozen {
    
    [elsa removeFromParent];
    gameOverFrozen = YES;
    
    // Save high score
    [[GameState sharedInstance] saveState];
    
    SKScene *gameOver = [[GameOver alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:gameOver transition:reveal];
}

@end
