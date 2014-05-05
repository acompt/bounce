//
//  Directions.m
//  Bounce
//
//  Created by Andrea Compton on 5/5/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import "Directions.h"
#import "StartGame.h"

@implementation Directions

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:.3 alpha:.5];
        // Title
        
        SKLabelNode *lblTitle = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblTitle.fontSize = 15;
        lblTitle.fontColor = [SKColor whiteColor];
        lblTitle.position = CGPointMake(size.width/2, 200);
        lblTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblTitle setText:@"Tap the screen to change the height of your character's bounce"];
        [self addChild:lblTitle];
        
        // Try again
        SKLabelNode *lblStartGame = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblStartGame.name = @"back";
        lblStartGame.fontSize = 30;
        lblStartGame.fontColor = [SKColor whiteColor];
        lblStartGame.position = CGPointMake(size.width/2, 50);
        lblStartGame.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblStartGame setText:@"Back"];
        [self addChild:lblStartGame];
  
    }
    return self;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if (n != self && [n.name isEqual: @"back"]) {
            // Transition back to the Game
            SKScene *Main = [[StartGame alloc] initWithSize:self.size];
            SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene: Main transition:reveal];
            return;
        }
        
    }
    
}



@end
