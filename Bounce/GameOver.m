//
//  GameOver.m
//  Bounce
//
//  Created by Andrea Compton on 4/14/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import "GameOver.h"
#import "MyScene.h"

@implementation GameOver

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /*
        SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
        star.position = CGPointMake(25, self.size.height-30);
        [self addChild:star];
        SKLabelNode *lblStars = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblStars.fontSize = 30;
        lblStars.fontColor = [SKColor whiteColor];
        lblStars.position = CGPointMake(50, self.size.height-40);
        lblStars.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [lblStars setText:[NSString stringWithFormat:@"X %d", [GameState sharedInstance].stars]];
        [self addChild:lblStars];
         */
        
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
        lblHighScore.position = CGPointMake(size.width/2, 100);
        lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblHighScore setText:[NSString stringWithFormat:@"High Score: %d", [GameState sharedInstance].highScore]];
        [self addChild:lblHighScore];
        
        // Try again
        SKLabelNode *lblTryAgain = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblTryAgain.fontSize = 30;
        lblTryAgain.fontColor = [SKColor whiteColor];
        lblTryAgain.position = CGPointMake(size.width/2, 50);
        lblTryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblTryAgain setText:@"Tap To Try Again"];
        [self addChild:lblTryAgain];
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
