//
//  MyScene.h
//  Bounce
//

//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>

-(void)addShip:(NSString*)title;
-(void)addBird;
-(void)addButterfly;
-(void)initalizingScrollingBackground;
- (void)moveBg;
-(void)moveBirds;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)update:(CFTimeInterval)currentTime;
- (void)didSimulatePhysics;
- (void)didBeginContact:(SKPhysicsContact *)contact;
-(void)endGame;

@end
