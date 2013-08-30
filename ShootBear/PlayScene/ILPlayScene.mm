//
//  ILPlayScene.m
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright 2013年 mac. All rights reserved.
//

#import "ILPlayScene.h"
#import "ILBox2dDebug.h"
#import "CCBReader.h"
#import "ILPhysicsSprite.h"
#import "CCBAnimationManager.h"
#import "ILShapeCache.h"
#import "ILShooter.h"
#import "ILPlayControl.h"


#define zBK 0
#define zLevel 1
#define zLevelControl 9
#define zLevelCompleted 10

@interface ILPlayScene ()

@end

@implementation ILPlayScene

- (id)init {
    self = [super init];
    if(self) {
        [self configBox2d];
        [self configSubLayers];
        [self loadLayer:0];
        [self loadControl];
        [self scheduleUpdate];
        
    }
    return self;
}

- (void)loadControl
{
    if (_playControl != nil) {
        [_playControl removeFromParent];
        [_playControl release], _playControl = nil;
    }
    _playControl = [[ILPlayControl node] retain];
    _playControl.delegate = _currentLevel;
    [self addChild:_playControl z:zLevelControl];
}

- (void)configBox2d
{
    [[ILBox2dFactory sharedFactory] prepareB2World];
    ILBox2dDebug *debug = [[ILBox2dDebug alloc] init];
    [self addChild:debug z:100];
    [debug release];
}

- (void)configSubLayers
{
    CCNode *bk = [CCBReader nodeGraphFromFile:@"SceneBackground1.ccbi"];
    [self addChild:bk z:zBK];
    _levelComplete = [(CCLayer *)[CCBReader nodeGraphFromFile:@"LevelCompletedLayer.ccbi" owner:self] retain];
    _levelComplete.visible = NO;
    [self addChild:_levelComplete z:zLevelCompleted];
    
}

- (void)loadLayer:(int)level
{
    if (_currentLevel != nil) {
        [_currentLevel removeFromParent];
        [_currentLevel release], _currentLevel = nil;
    }
    NSString *fileName = [NSString stringWithFormat:@"level%i.ccbi",level];
    _currentLevel = [(ILLevelLayer *)[CCBReader nodeGraphFromFile:fileName] retain];
    _currentLevel.position = ccp(0, 0);
    _currentLevel.delegate = self;
    [self addChild:_currentLevel z:zLevel];
}

- (void)dealloc
{
    [_levelComplete release],_levelComplete = nil;
    [_currentLevel release], _currentLevel = nil;
    [_playControl release], _playControl = nil;
    [[ILBox2dFactory sharedFactory] releaseB2World];
    [super dealloc];
}

- (void)levelCompleted
{
    _levelComplete.visible = YES;
    CCBAnimationManager *manager = _levelComplete.userObject;
    [manager runAnimationsForSequenceNamed:@"first"];
}

- (void)hideLevelCompletedLevel
{
    _levelComplete.visible = NO;
}

- (void)pressedNextButton:(id)sender
{
    [self hideLevelCompletedLevel];
}

- (void)pressedRetryButton:(id)sender
{
    [self hideLevelCompletedLevel];
    [self loadLayer:_currentLevel.levelNo];
    [self loadControl];
}

- (void)pressedMoreButton:(id)sender
{
    [self hideLevelCompletedLevel];

}


-(void) update: (ccTime) dt
{
	int32 velocityIterations = 1;
	int32 positionIterations = 10;
	[ILBox2dFactory sharedFactory].world->Step(dt, velocityIterations, positionIterations);
}






@end
