//
//  GameOverScene.h
//  F1 Car Control
//
//  Created by Bishal Ghimire on 5/10/14.
//  Copyright 2014 Big B Soft. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <Foundation/Foundation.h>

@interface GameOverScene : CCScene {
    
}

+ (GameOverScene *)scene;
// + (GameOverScene *)sceneWithScore:(CGFloat)score;

@property (nonatomic) CGFloat score;

@end
