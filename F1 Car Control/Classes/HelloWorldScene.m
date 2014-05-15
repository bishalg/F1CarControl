//
//  HelloWorldScene.m
//  F1 Car Control
//
//  Created by Bishal Ghimire on 5/10/14.
//  Copyright Big B Soft 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "GameOverScene.h"
#import "AppDelegate.h"


@interface HelloWorldScene () <CCPhysicsCollisionDelegate>

@property (nonatomic) CGPoint lastLocation;
@property (nonatomic) CGFloat lastRotation;
@property (nonatomic) CGPoint lastPosition;

@property (nonatomic) CGFloat score;
@property (nonatomic) CCLabelTTF *scoreLabel;

@property (nonatomic) CCLabelTTF *fuelLabel;
@property (nonatomic) CGFloat fuelValue;

@end

#define ARC4RANDOM_MAX      0x100000000

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_spriteCar;
    CCSprite *_spriteFuel;
    CCSprite *_spriteFuelRed;
    CCPhysicsNode *_physicsWorld;
}

@synthesize lastLocation;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    // _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    /**
     *  Draw Sprites
     */
    [self drawCar];
    [self drawFuels];
    [self drawRedFuels];
    [self drawInfoElements];
    
    // done
	return self;
}


- (void)drawCar {
    // Add a sprite
    _spriteCar = [CCSprite spriteWithImageNamed:@"virgin_f1.png"]; // 530 x 256
    CGFloat scale =  5.0;
    _spriteCar.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self resizeSprite:_spriteCar toWidth:(530/scale) toHeight:(256/scale)];
    
    _spriteCar.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _spriteCar.contentSize} cornerRadius:0]; // 1
    _spriteCar.physicsBody.collisionGroup = @"carGroup"; // 2
    _spriteCar.physicsBody.collisionType  = @"carCollision";
    [_physicsWorld addChild:_spriteCar];
    
    
    //[self addChild:_spriteCar];
    
    // Animate sprite with action
    //    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    //    [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
}

// -----------------------------------------------------------------------
#pragma mark - Fuels
// -----------------------------------------------------------------------

- (void)drawFuels {
    float val = ((float)arc4random() / ARC4RANDOM_MAX);
    NSString *greenFuel = @"fuel_green.png";
    //NSString *blackFuel = @"fuel_black.png";
    
    CGFloat scale =  10.0;
    _spriteFuel = [CCSprite spriteWithImageNamed:greenFuel]; // 310 x 310
    [self resizeSprite:_spriteFuel toWidth:(310/scale) toHeight:(310/scale)];
    _spriteFuel.position  = ccp(self.contentSize.width * val, self.contentSize.height * val);
    _spriteFuel.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _spriteFuel.contentSize} cornerRadius:0];
    _spriteFuel.physicsBody.collisionGroup = @"fuelGroup";
    _spriteFuel.physicsBody.collisionType  = @"fuelCollision";
    [_physicsWorld addChild:_spriteFuel];
}

- (void)drawRedFuels {
    float val = ((float)arc4random() / ARC4RANDOM_MAX);
    CGFloat scale =  10.0;
    NSString *redFuel = @"fuel_red.png";
    _spriteFuelRed = [CCSprite spriteWithImageNamed:redFuel]; // 310 x 310
    [self resizeSprite:_spriteFuelRed toWidth:(310/scale) toHeight:(310/scale)];
    _spriteFuelRed.position  = ccp(self.contentSize.width * val, self.contentSize.height * val);
    _spriteFuelRed.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _spriteFuel.contentSize} cornerRadius:0];
    _spriteFuelRed.physicsBody.collisionGroup = @"fuelRedGroup";
    _spriteFuelRed.physicsBody.collisionType  = @"fuelRedCollision";
    [_physicsWorld addChild:_spriteFuelRed];

}


- (void)drawInfoElements {
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    
    NSString *str = [NSString stringWithFormat:@"Score"];
    _scoreLabel = [CCLabelTTF labelWithString:str fontName:@"Verdana-Bold" fontSize:10.f];
    _scoreLabel.positionType = CCPositionTypeNormalized;
    _scoreLabel.color = [CCColor redColor];
    _scoreLabel.position = ccp(0.5f, 0.9f); // Top Middle
    [self addChild:_scoreLabel];

    _fuelValue = 1000;
    NSString *strFuel = [NSString stringWithFormat:@"Fuel"];
    _fuelLabel = [CCLabelTTF labelWithString:strFuel fontName:@"Verdana-Bold" fontSize:10.f];
    _fuelLabel.positionType = CCPositionTypeNormalized;
    _fuelLabel.color = [CCColor redColor];
    _fuelLabel.position = ccp(0.2f, 0.9f); // Top left of screen
    [self addChild:_fuelLabel];
}

// Scale CCSprite to exact size

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}


// -----------------------------------------------------------------------
#pragma mark - Physics & Collision
// -----------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair carCollision:(CCNode *)car fuelCollision:(CCNode *)fuel {
//    [fuel removeFromParent];
    [self removeAndAddFules];
    _fuelValue += 100;
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair carCollision:(CCNode *)car fuelRedCollision:(CCNode *)fuel {
    // [fuel removeFromParent];
    [self removeAndAddFules];
    _fuelValue -= 300;
    return YES;
}

- (void)removeAndAddFules {
    [_spriteFuel removeFromParent];
    [_spriteFuelRed removeFromParent];
    [self drawFuels];
    [self drawRedFuels];
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    [self rotateObjetFromPoint:lastLocation toPoint:touchLoc];
    
    // Log touch location
    // CCLOG(@"Move sprite from @ %@ to @ %@",NSStringFromCGPoint(lastLocation), NSStringFromCGPoint(touchLoc));
    lastLocation = touchLoc;
    _score += 100;
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    [_spriteCar runAction:actionMove];

    //[_spriteCar runAction:[CCActionRepeatForever actionWithAction:actionMove]];
}


- (void)rotateObjetFromPoint:(CGPoint)fromPt toPoint:(CGPoint)toPoint {
    // Animate sprite with action
    //    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    //    [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    CGFloat deltaX = (fromPt.x - toPoint.x);
    CGFloat deltaY = (fromPt.y - toPoint.y);
    CGFloat angle =  tan( deltaY / deltaX ) * 180 / M_PI;
    
    // CCLOG(@"Angle @ %f",angle);
    
    _lastRotation = angle;
    
    CCActionRotateBy *actionSpin = [CCActionRotateBy actionWithDuration:1.0f angle:angle];
    [_spriteCar runAction:actionSpin];

}


- (void)update:(CCTime)dt
{
    CGPoint position = _spriteCar.position;
    _score += abs(abs((position.x  - _lastPosition.x)) + abs((position.y - _lastPosition.y))) / 100;
    _lastPosition = position;
    if (position.x < -100 || position.y < -100) {
        [self onGameOver];
    }
    NSString *str = [NSString stringWithFormat:@"Score = %.2f", _score];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [_scoreLabel setAttributedString:attributedStr];

    _fuelValue -= 1;
    if (_fuelValue < 1) {
        [self onGameOver];
    }
    NSString *strFuelValue = [NSString stringWithFormat:@"Fuel = %.2f", _fuelValue];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:strFuelValue];
    [_fuelLabel setAttributedString:aStr];
}

// -----------------------------------------------------------------------
#pragma mark - on GameOver
// -----------------------------------------------------------------------

- (void)onGameOver
{
    // back to intro scene with transition
    // AppDelegate *appDelegate = [[AppDelegate alloc] init];
    SharedAppDelegate.score = _score;
    
    GameOverScene *gameOverScene = [GameOverScene scene];
    gameOverScene.score = _score;
    [[CCDirector sharedDirector] replaceScene:gameOverScene
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
