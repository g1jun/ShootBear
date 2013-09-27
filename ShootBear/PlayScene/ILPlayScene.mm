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
#import "ILMenuScene.h"
#import "ILPlayControl.h"
#import "ILDataSimpleSave.h"
#import "ILShoppingControl.h"


#define zBK 0
#define zLevel 1
#define zLevelControl 9
#define zLevelCompleted 10
#define zShopping 11

@interface ILPlayScene ()

@end

@implementation ILPlayScene

- (id)initWithLevel:(Level)level
{
    self = [super init];
    if(self) {
        _cacheLayers = [[NSMutableDictionary dictionary] retain];
        [self configBox2d];
        [self configSubLayers];
        [self loadLayer:level];
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
    _playControl.level = _currentLevelNO;
    [self addChild:_playControl z:zLevelControl];
}

- (void)configBox2d
{
    [[ILBox2dFactory sharedFactory] prepareB2World];
#ifdef BOX2D_DEBUG
    ILBox2dDebug *debug = [[ILBox2dDebug alloc] init];
    [self addChild:debug z:100];
    [debug release];
#endif

}

- (void)configSubLayers
{
    CCNode *bk = [CCBReader nodeGraphFromFile:@"SceneBackground1.ccbi"];
    [self addChild:bk z:zBK];
}

- (void)loadLayer:(Level)level
{
    _currentLevelNO = level;
    if (_currentLevel != nil) {
        [_currentLevel removeFromParent];
        [_currentLevel release], _currentLevel = nil;
    }
    NSString *levelFileName = [NSString stringWithFormat:@"Level%i-%i.ccbi", level.page, level.levelNo];
    _currentLevel = [(ILLevelLayer *)[CCBReader nodeGraphFromFile:levelFileName] retain];
    _currentLevel.position = ccp(0, 0);
    _currentLevel.delegate = self;
    [self addChild:_currentLevel z:zLevel];
}

- (void)dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    [_cacheLayers release], _cacheLayers = nil;
    [_currentLevel release], _currentLevel = nil;
    [_playControl release], _playControl = nil;
    [[ILBox2dFactory sharedFactory] releaseB2World];
    [super dealloc];
}

- (void)levelFailed
{
    [_playControl pause];
    [self loadLevelFinished:@"LevelFailedLayer.ccbi"];

}

- (void)levelCompleted
{
    Level next = [self nextLevel];
    [[ILDataSimpleSave sharedDataSave] saveLevelPass:next];
    [_playControl pause];
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


- (NSDictionary *)levelGroupNumber
{
    return @{@"0":@15,@"1":@18,@"2":@16};
}


- (void)removeTempLayer
{
    id levelResult = _cacheLayers[@"levelResult"];
    [levelResult removeFromParent];
    [_cacheLayers removeObjectForKey:@"levelResult"];
}

- (Level)nextLevel
{
    Level temp = _currentLevelNO;
    NSString *key = [NSString stringWithFormat:@"%i", temp.page];
    int max = [[self levelGroupNumber][key] intValue];
    if (temp.levelNo == max - 1) {
        temp.page ++;
        temp.levelNo = 0;
    } else {
        temp.levelNo++;
    }
    return temp;
}

- (void)pressedNextButton:(id)sender
{
    _currentLevelNO = [self nextLevel];
    [self removeTempLayer];
    [self loadLayer:_currentLevelNO];
    [self loadControl];
}

- (void)pressedShoppingButton:(id)sender
{
    ILShoppingControl *shopping = [ILShoppingControl node];
    [self addChild:shopping z:zShopping];
}

- (void)pressedRetryButton:(id)sender
{
    [self removeTempLayer];
    [self loadLayer:_currentLevelNO];
    [self loadControl];
}

- (void)pressedMoreButton:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[ILMenuScene node]];
}

- (void)pause
{
    [self pause:_currentLevel];
}

- (void)pause:(CCNode *)node
{
    [[CCDirector sharedDirector].actionManager pauseTarget:node];
    for (id ch in node.children) {
        [self pause:ch];
    }
}

- (void)resume
{
    [self resume:_currentLevel];
}

- (void)resume:(CCNode *)node
{
    [[CCDirector sharedDirector].actionManager resumeTarget:node];
    for (id ch in node.children) {
        [self resume:ch];
    }
}


@end
