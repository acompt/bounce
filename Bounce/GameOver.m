//
//  GameOver.m
//  Bounce
//
//  Created by Andrea Compton on 4/14/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import "GameOver.h"
#import "characters.h"
#import "StartGame.h"

@implementation GameOver

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:.3 alpha:.5];
        
        // Score
        SKLabelNode *lblScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblScore.fontSize = 60;
        lblScore.fontColor = [SKColor whiteColor];
        lblScore.position = CGPointMake(size.width/2, 200);
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
        [self addChild:lblScore];
        
        // High Score
        SKLabelNode *lblHighScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblHighScore.fontSize = 30;
        lblHighScore.fontColor = [SKColor cyanColor];
        lblHighScore.position = CGPointMake(size.width/2, 150);
        lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblHighScore setText:[NSString stringWithFormat:@"High Score: %d", [GameState sharedInstance].highScore]];
        [self addChild:lblHighScore];
        
        // Try again
        SKLabelNode *lblTryAgain = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblTryAgain.fontSize = 30;
        lblTryAgain.name = @"again";
        lblTryAgain.fontColor = [SKColor whiteColor];
        lblTryAgain.position = CGPointMake(size.width/2, 100);
        lblTryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblTryAgain setText:@"Tap To Try Again"];
        [self addChild:lblTryAgain];
        
        // Main Menu
        SKLabelNode *menu = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        menu.fontSize = 30;
        menu.name = @"menu";
        menu.fontColor = [SKColor whiteColor];
        menu.position = CGPointMake(size.width/2, 50);
        menu.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [menu setText:@"Main Menu"];
        [self addChild:menu];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if (n != self && [n.name isEqual: @"menu"]) {
            // Transition back to the Game
            SKScene *myScene = [[StartGame alloc] initWithSize:self.size];
            
            SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene:myScene transition:reveal];
            return;
        }
        if (n != self && [n.name isEqual: @"again"]) {
            // Transition back to the Game
            SKScene *myScene = [[characters alloc] initWithSize:self.size];
            
            SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene:myScene transition:reveal];
            return;
        }
    }
}

@end
