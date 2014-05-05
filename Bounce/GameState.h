//
//  GameState.h
//  Bounce
//
//  Created by Andrea Compton on 4/14/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;
@property (nonatomic, assign) int life;


+ (instancetype)sharedInstance;

-(void)saveState;

@end
