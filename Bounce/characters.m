//
//  characters.m
//  Bounce
//
//  Created by Andrea Compton on 5/5/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import "characters.h"
#import "StartGame.h"
#import "MyScene.h"
#import "Frozen.h"

@implementation characters

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:.3 alpha:.5];
        // Title
        
        SKLabelNode *lblTitle = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblTitle.fontSize = 50;
        lblTitle.fontColor = [SKColor whiteColor];
        lblTitle.position = CGPointMake(size.width/2, 250);
        lblTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblTitle setText:@"Choose a Character:"];
        [self addChild:lblTitle];
        
        SKLabelNode *tigger = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        tigger.fontSize = 40;
        tigger.name = @"tigger";
        tigger.fontColor = [SKColor cyanColor];
        tigger.position = CGPointMake(size.width/2, 150);
        tigger.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [tigger setText:@"Tigger"];
        [self addChild:tigger];
        
        SKLabelNode *elsa = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        elsa.fontSize = 40;
        elsa.name = @"elsa";
        elsa.fontColor = [SKColor cyanColor];
        elsa.position = CGPointMake(size.width/2, 100);
        elsa.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [elsa setText:@"Elsa"];
        [self addChild:elsa];
        
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
        if (n != self && [n.name isEqual: @"tigger"]) {
            // Transition back to the Game
           // SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"tigger.png"];
            SKScene *Main = [[MyScene alloc] initWithSize:self.size];
            Main.backgroundColor = [UIColor whiteColor];
            SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene: Main transition:reveal];
            return;
        }
        if (n != self && [n.name isEqual: @"elsa"]) {
            // Transition back to the Game
            SKScene *Main = [[Frozen alloc] initWithSize:self.size];
            Main.backgroundColor = [SKColor blackColor];
            SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
            [self.view presentScene: Main transition:reveal];
            return;
        }
    }
    
}

@end
