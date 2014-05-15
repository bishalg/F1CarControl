//
//  GameOverScene.m
//  F1 Car Control
//
//  Created by Bishal Ghimire on 5/10/14.
//  Copyright 2014 Big B Soft. All rights reserved.
//

#import "GameOverScene.h"
#import "HelloWorldScene.h"
#import "AppDelegate.h"

@implementation GameOverScene

+ (GameOverScene *)scene
{
	return [[self alloc] init];
}

//+ (GameOverScene *)sceneWithScore:(CGFloat)score
//{
//    [[GameOverScene class] score] = score;
//	return [[self alloc] init];
//}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@" Game OVER !" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.75f); // Middle of screen
    [self addChild:label];

    // AppDelegate *appDelegate = [[AppDelegate alloc] init];
    CGFloat currentScore = SharedAppDelegate.score;
    
    NSString *str = [NSString stringWithFormat:@"Score %.2f", currentScore];
    CCLabelTTF *score = [CCLabelTTF labelWithString:str fontName:@"Chalkduster" fontSize:30.0f];
    score.positionType = CCPositionTypeNormalized;
    score.color = [CCColor redColor];
    score.position = ccp(0.5f, 0.55f); // Middle of screen
    [self addChild:score];

    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Re - Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.35f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:helloWorldButton];
    
    
    // Show High Score
    NSString *keyHightScore = @"highScore";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float hScore = [userDefaults floatForKey:keyHightScore];
    
    NSString *strHighScore;
    CCColor *textColor;
    if (hScore > currentScore) {
        strHighScore = [NSString stringWithFormat:@"Hight Score %.2f", hScore];
        textColor = [CCColor redColor];
    } else {
        strHighScore = [NSString stringWithFormat:@"NEW Hight Score %.2f", currentScore];
        textColor = [CCColor greenColor];
        [userDefaults setFloat:currentScore forKey:keyHightScore];
        [userDefaults synchronize];
    }
    
    CCLabelTTF *highScore = [CCLabelTTF labelWithString:strHighScore fontName:@"Chalkduster" fontSize:20.0f];
    highScore.positionType = CCPositionTypeNormalized;
    highScore.color = textColor;
    highScore.position = ccp(0.5f, 0.65f); // Middle of screen
    [self addChild:highScore];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}



@end
