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
        _cacheLayers = [[NSMutableDictionary dictionary] retain];
        [self configBox2d];
        [self configSubLayers];
        [self loadLayer:0];
        [self loadControl];
        
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
    _playControl.failedDelegate = self;
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
    [_cacheLayers release], _cacheLayers = nil;
    [_currentLevel release], _currentLevel = nil;
    [_playControl release], _playControl = nil;
    [[ILBox2dFactory sharedFactory] releaseB2World];
    [super dealloc];
}

- (void)levelFailed
{
    [self loadLevelFinished:@"LevelFailedLayer.ccbi"];

}

- (void)levelCompleted
{
    [self loadLevelFinished:@"LevelCompletedLayer.ccbi"];
}

- (void)loadLevelFinished:(NSString *)ccbName
{
    if (_cacheLayers[@"levelResult"]) {
        return;
    }
    CCLayer* _tempLayer = (CCLayer *)[CCBReader nodeGraphFromFile:ccbName owner:self];
    _cacheLayers[@"levelResult"] = _tempLayer;
    [self addChild:_tempLayer z:zLevelCompleted];
    CCBAnimationManager *manager = _tempLayer.userObject;
    _playControl.forbiddenTouch = YES;
    [manager runAnimationsForSequenceNamed:@"first"];
}


- (void)removeTempLayer
{
    id levelResult = _cacheLayers[@"levelResult"];
    [levelResult removeFromParent];
    [_cacheLayers removeObjectForKey:@"levelResult"];
}

- (void)pressedNextButton:(id)sender
{
    [self removeTempLayer];
}

- (void)pressedShoppingButton:(id)sender
{
    
}

- (void)pressedRetryButton:(id)sender
{
    [self removeTempLayer];
    [self loadLayer:_currentLevel.levelNo];
    [self loadControl];
}

- (void)pressedMoreButton:(id)sender
{
    [self removeTempLayer];

}


@end
