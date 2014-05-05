//
//  ViewController.m
//  Bounce
//
//  Created by Andrea Compton on 4/10/14.
//  Copyright (c) 2014 Bounce. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "StartGame.h"

@implementation ViewController

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [StartGame sceneWithSize:skView.bounds.size];
        //SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

/*
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}
*/
/*
- (IBAction)StartGame:(id)sender {
    SKView * skView = (SKView *)self.view;
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
 
    SKScene *myScene = [[MyScene alloc] initWithSize:self.size];
     
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    [skView presentScene:scene transition:reveal];
}
*/
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
