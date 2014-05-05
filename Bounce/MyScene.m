//
//  MyScene.m
//  Bounce
//
//  Created by Andrea Compton on 4/10/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import "MyScene.h"
#import "GameOver.h"

SKLabelNode *_lblScore;
SKLabelNode *_lblLife;
BOOL gameOver = NO;
static const uint32_t shipCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;
static const uint32_t butterflyCategory = 0x1 << 2;

static const float BG_VELOCITY = 35.0;
static const float BIRD_VELOCITY = 225.0;
static const float SPEED = 2;

static NSString* ballCategoryName = @"ball";


//static const float OBJECT_VELOCITY = 160.0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}

@implementation MyScene {
    
    SKSpriteNode *ship;
    SKAction *actionMoveUp;
    SKAction *actionMoveDown;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    NSTimeInterval _lastBirdAdded;
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        //SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

        //SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointZero toPoint:CGPointMake(0, self.size.width)];
        //self.physicsBody = borderBody;
        //self.physicsBody.friction = 0.0f;
 
        self.backgroundColor = [SKColor whiteColor];
        [self initalizingScrollingBackground];
        [self addShip];
        //[self addFloor];
       // [self addBall];
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,-5);
        self.physicsWorld.contactDelegate = self;
        self.size = size;
        //self.score = 0;
        [GameState sharedInstance].score = 0;
        [GameState sharedInstance].life = 100;
        gameOver = NO;
        
        _lblLife = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        _lblLife.fontSize = 30;
        _lblLife.fontColor = [SKColor greenColor];
        _lblLife.position = CGPointMake(20, self.size.height-40);
        _lblLife.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [_lblLife setText:[NSString stringWithFormat:@"Life: %d", [GameState sharedInstance].life]];
        [self addChild:_lblLife];
        
        _lblScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        _lblScore.fontSize = 30;
        _lblScore.fontColor = [SKColor greenColor];
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

-(void)addShip
{
    //initalizing spaceship node
    ship = [SKSpriteNode spriteNodeWithImageNamed:@"tigger"];
    [ship setScale:0.15];
    //ship.zRotation = - M_PI / 2;
    
    //Adding SpriteKit physicsBody for collision detection
    ship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ship.size];
    
    //CGPathRef path = CGPathCreateWithEllipseInRect((CGRect){{-10, -10}, {20, 20}}, NULL);
    //[ship setPath:path];
   // CGPathRelease(path);
    
    ship.physicsBody.categoryBitMask = shipCategory;
    ship.physicsBody.dynamic = YES;
    ship.physicsBody.contactTestBitMask = obstacleCategory | butterflyCategory;
    ship.physicsBody.collisionBitMask = 0;
    ship.physicsBody.usesPreciseCollisionDetection = YES;
    ship.physicsBody.velocity = CGVectorMake(-1, -3);
    ship.physicsBody.mass = 30;
    ship.physicsBody.restitution=1;
    ship.physicsBody.linearDamping=0;
    ship.physicsBody.angularDamping=0;
    ship.name = @"ship";
    ship.position = CGPointMake(self.size.width/3,self.size.height);
    actionMoveUp = [SKAction speedBy:SPEED duration:.8];
    actionMoveDown = [SKAction speedBy:-SPEED duration:.8];
    
    [self addChild:ship];
}


-(void)addBird
{
    //initalizing spaceship node
    SKSpriteNode *bird;
    bird = [SKSpriteNode spriteNodeWithImageNamed:@"bee.png"];
    [bird setScale:0.05];
    
    //Adding SpriteKit physicsBody for collision detection
    bird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bird.size];
    bird.physicsBody.categoryBitMask = obstacleCategory;
    bird.physicsBody.dynamic = NO;
    //bird.physicsBody.velocity = CGVectorMake(-10, 0);
    bird.physicsBody.contactTestBitMask = shipCategory;
    bird.physicsBody.collisionBitMask = 0;
    bird.physicsBody.usesPreciseCollisionDetection = YES;
    bird.name = @"bird";
    
    //selecting random y position for missile
    int r = arc4random() % 300;
    bird.position = CGPointMake(self.frame.size.width + 20,r);
    
    [self addChild:bird];
}

-(void)addButterfly
{
    //initalizing spaceship node
    SKSpriteNode *butterfly;
    butterfly = [SKSpriteNode spriteNodeWithImageNamed:@"honey.png"];
    [butterfly setScale:0.15];
    
    //Adding SpriteKit physicsBody for collision detection
    butterfly.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:butterfly.size];
    butterfly.physicsBody.categoryBitMask = butterflyCategory;
    butterfly.physicsBody.dynamic = NO;
    //bird.physicsBody.velocity = CGVectorMake(-10, 0);
    butterfly.physicsBody.contactTestBitMask = shipCategory;
    butterfly.physicsBody.collisionBitMask = 0;
    butterfly.physicsBody.usesPreciseCollisionDetection = YES;
    butterfly.name = @"butterfly";
    
    //selecting random y position for missile
    int r = arc4random() % 300;
    butterfly.position = CGPointMake(self.frame.size.width + 20,r);
    
    [self addChild:butterfly];
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"Landscape"];
        //[bg setScale:0.5];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        [self addChild:bg];
    }
    
}

- (void)moveBg
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
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
    
    [self enumerateChildNodesWithName:@"butterfly" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * fly = (SKSpriteNode *) node;
         CGPoint flyVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(flyVelocity,_dt);
         fly.position = CGPointAdd(fly.position, amtToMove);
     }];
}


-(void)moveBirds
{
    [self enumerateChildNodesWithName:@"bird" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bird = (SKSpriteNode *) node;
         CGPoint birdVelocity = CGPointMake(-BIRD_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(birdVelocity,_dt);
         bird.position = CGPointAdd(bird.position, amtToMove);
         if(bird.position.x < -100)
         {
             [bird removeFromParent];
         }
     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    NSInteger dif = self.size.height - touchLocation.y;
    
    [self enumerateChildNodesWithName:@"ship" usingBlock:^(SKNode *node, BOOL *stop) {
        node.physicsBody.velocity = CGVectorMake(0, node.physicsBody.velocity.dy + dif);
        if (node.position.y > self.size.height) {
            node.position = CGPointMake(self.size.width/3, self.size.height);
        }
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (gameOver) return;

    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    if( currentTime - _lastBirdAdded > 3)
    {
        _lastBirdAdded = currentTime + 3;
        [self addBird];
        [self addButterfly];
    }
    
   // [self moveShip];
    [self moveBg];
    [self moveBirds];

}

/*
- (SKSpriteNode *)createFloor {
 
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:(CGSize){self.frame.size.width, 15}];
    [floor setAnchorPoint:(CGPoint){0, 0}];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.dynamic = NO;
    
    return floor;
}*/



- (void)didSimulatePhysics {
    [self enumerateChildNodesWithName:@"ship" usingBlock:^(SKNode *node, BOOL *stop) {
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
    
    if ((firstBody.categoryBitMask & shipCategory) != 0 &&
        (secondBody.categoryBitMask & obstacleCategory) != 0) {
        
        [GameState sharedInstance].life -= 50;
        [secondBody.node removeFromParent];
        [_lblLife setText:[NSString stringWithFormat:@"Life: %d", [GameState sharedInstance].life]];
        if ([GameState sharedInstance].life <= 0) {
            [self endGame];
        }
    }
    
    if ((firstBody.categoryBitMask & shipCategory) != 0 &&
        (secondBody.categoryBitMask & butterflyCategory) != 0) {
        
        [GameState sharedInstance].score += 5;
        [secondBody.node removeFromParent];
        [_lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
    }
}

-(void)endGame {
    
    [ship removeFromParent];
    gameOver = YES;
    
    // Save high score
    [[GameState sharedInstance] saveState];
    
    SKScene *gameOver = [[GameOver alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:gameOver transition:reveal];
}

@end
