//
//  StartGame.m
//  Bounce
//
//  Created by Andrea Compton on 4/15/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import "StartGame.h"
#import "MyScene.h"

@implementation StartGame

-(id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:.3 alpha:.5];
        // Title
        
        SKLabelNode *lblTitle = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblTitle.fontSize = 60;
        lblTitle.fontColor = [SKColor whiteColor];
        lblTitle.position = CGPointMake(size.width/2, 200);
        lblTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblTitle setText:@"Bounce"];
        [self addChild:lblTitle];
        
        // Directions
        SKLabelNode *lblDirections = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblDirections.fontSize = 30;
        lblDirections.fontColor = [SKColor cyanColor];
        lblDirections.position = CGPointMake(size.width/2, 100);
        lblDirections.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblDirections setText:@"Directions"];
        [self addChild:lblDirections];
        
        // Try again
        SKLabelNode *lblStartGame = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblStartGame.fontSize = 30;
        lblStartGame.fontColor = [SKColor whiteColor];
        lblStartGame.position = CGPointMake(size.width/2, 50);
        lblStartGame.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblStartGame setText:@"Tap To Start"];
        [self addChild:lblStartGame];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Transition back to the Game
    SKScene *myScene = [[MyScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:myScene transition:reveal];
}


@end
