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
#import "ILLevelCompletedLayer.h"
#import "SimpleAudioEngine.h"
#import "ILSceneReplace.h"


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
        [self configSubLayers:level.page];
        [self loadLayer:level];
        [self loadControl];
        _currentLevel.moneyBagPosition = _playControl.moneyPosition;
        
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

- (void)configSubLayers:(int)page
{
    if (_bk && _bk.tag != page) {
        [_bk removeFromParent];
        _bk = nil;
    }
    NSString *fileName = [NSString stringWithFormat:@"SceneBackground%i.ccbi", page + 1];
    if (_bk == nil) {
        _bk = [CCBReader nodeGraphFromFile:fileName];
        _bk.tag = _currentLevelNO.page;
        [self addChild:_bk z:zBK];
    }
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"game_dead.mp3"];

}

- (void)openNextLevel:(Level)next
{
    [self savePassState:next grade:kPass];
    if (next.page == 0 && next.levelNo == 3) {
        [[ILDataSimpleSave sharedDataSave] saveBool:YES forKey:@"show_coin_teach"];
    }
}

- (void)levelCompleted:(float)percent
{
    Level next = [self nextLevel];
    if (next.page == 1) {
        [[ILDataSimpleSave sharedDataSave] saveInt:1 forKey:@"current_page"];
    }
    LevelGrade grade = [self grade:percent];
    [self openNextLevel:next];
    [self savePassState:_currentLevelNO grade:grade];
    
    [_playControl pause];
    ILLevelCompletedLayer *compltedLayer = (ILLevelCompletedLayer *)[self loadLevelFinished:@"LevelCompletedLayer.ccbi"];
    compltedLayer.percent = percent;

}

- (void)savePassState:(Level) level grade:(LevelGrade)grade
{
    LevelGrade current = [[ILDataSimpleSave sharedDataSave] levelState:level];
    if (grade > current) {
        [[ILDataSimpleSave sharedDataSave] saveLevelPass:level grade:grade];
    }
}

- (LevelGrade)grade:(float)percent
{
    if (percent > 0.1 && percent < 0.99) {
        return kGeneral;
    } else if (percent > 0.99) {
        return kGood;
    }
    return kPass;
}

- (CCLayer *)loadLevelFinished:(NSString *)ccbName
{
    if (_cacheLayers[@"levelResult"]) {
        return nil;
    }
    CCLayer* _tempLayer = (CCLayer *)[CCBReader nodeGraphFromFile:ccbName owner:self];
    _cacheLayers[@"levelResult"] = _tempLayer;
    [self addChild:_tempLayer z:zLevelCompleted];
    _playControl.forbiddenTouch = YES;
    return _tempLayer;
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
    if (_currentLevelNO.page == 1 && _currentLevelNO.levelNo == 17) {
        Level ret;
        ret.levelNo = 0;
        ret.page = 0;
        return ret;
    }
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
    _currentLevel.moneyBagPosition = _playControl.moneyPosition;
    [self configSubLayers:_currentLevelNO.page];
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
    _currentLevel.moneyBagPosition = _playControl.moneyPosition;
}

- (void)pressedMoreButton:(id)sender
{
    [ILSceneReplace replaceScene:[ILMenuScene node]];
}

- (void)pressedHelpButton:(id)sender
{
    
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
