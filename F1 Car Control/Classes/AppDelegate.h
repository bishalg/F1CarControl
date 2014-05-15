//
//  AppDelegate.h
//  F1 Car Control
//
//  Created by Bishal Ghimire on 5/10/14.
//  Copyright Big B Soft 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"

@interface AppDelegate : CCAppDelegate

#define SharedAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@property (nonatomic) CGFloat score;

@end
