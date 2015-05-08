//
//  ILMenuScene.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-1.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMenuScene.h"
#import "CCBReader.h"
#import "CCScrollLayer.h"
#import "ILMenuLayer.h"
#import "ILPlayScene.h"
#import "ILMenuItem.h"
#import "ILDataSimpleSave.h"
#import "ILSceneReplace.h"
#import "ILHomeLayerControl.h"

@implementation ILMenuScene


- (id)init
{
    self = [super init];
    if (self) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"group.plist"];
        [self configBackground];
        [self configMenu];
        [self configHomeButton];
        self.currentPage = 0;
    }
    return self;
}

- (void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"group.plist"];
    [super dealloc];
}

- (void)configHomeButton
{
    CCNode *homeButton = [CCBReader nodeGraphFromFile:@"ButtonHome.ccbi" owner:self];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    homeButton.position = ccp(winSize.width * 0.95, winSize.height * 0.075);
    [self addChild:homeButton];
}

- (void)configBackground
{
    CCSprite *sprite = [CCSprite spriteWithFile:@"menu_bk.png"];
    sprite.position = ccpMult(ccpFromSize([CCDirector sharedDirector].winSize), 0.5);
    [self addChild:sprite];
}

- (void)configMenu
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    NSMutableArray *layers = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        ILMenuLayer *layer = (ILMenuLayer *)[CCBReader nodeGraphFromFile:@"MenuLayer.ccbi"];
        NSString *groupFile = [NSString stringWithFormat:@"MenuGroup%i.ccbi", i + 1];
        layer.menuGroup = [CCBReader nodeGraphFromFile:groupFile owner:self];
        layer.position = ccp(winSize.width * i, 0);
        [layers addObject:layer];
        layer.groupIndex = i;


    }
    _scrollLayer = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:0];
    _scrollLayer.delegate = self;
    [self addChild:_scrollLayer];
    [_scrollLayer release];
    
}

- (void)pressedHomButton:(id)sender
{
    [ILSceneReplace replaceScene:[ILHomeLayerControl scene]];
}

- (void)onEnter
{
    [super onEnter];
    int page = [[ILDataSimpleSave sharedDataSave] intWithKey:@"current_page"];
    [_scrollLayer selectPage:page];
    self.currentPage = page;
}

- (void)pressedMenuItem:(id)sender
{
    ILMenuItem *item = (ILMenuItem *)[sender parent];
    Level level;
    level.levelNo = item.levelNO;
    level.page = self.currentPage;
    ILPlayScene *playScene = [[ILPlayScene alloc] initWithLevel:level];
    [ILSceneReplace replaceScene:playScene];
    [playScene release];
    
}

- (void)scrollLayer:(CCScrollLayer *)sender scrolledToPageNumber:(int)page
{
    self.currentPage = page;
}

@end
