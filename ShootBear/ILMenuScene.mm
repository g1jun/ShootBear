//
//  ILMenuScene.m
//  ShootBear
//
//  Created by mac on 13-9-1.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMenuScene.h"
#import "CCBReader.h"
#import "CCScrollLayer.h"
#import "ILMenuLayer.h"
#import "ILMenuButton.h"
#import "ILPlayScene.h"

@implementation ILMenuScene


- (id)init
{
    self = [super init];
    if (self) {
        [self configBackground];
        [self configMenu];
        self.currentPage = 0;
    }
    return self;
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

    }
    CCScrollLayer *scroll = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:0];
    scroll.delegate = self;
    [self addChild:scroll];
    [scroll release];
    
}

- (void)pressedMenuItem:(id)sender
{
    ILMenuItem *item = [sender menuItem];
    Level level;
    level.levelNo = item.levelNO;
    level.page = self.currentPage;
    ILPlayScene *playScene = [[ILPlayScene alloc] initWithLevel:level];
    [[CCDirector sharedDirector] replaceScene:playScene];
    [playScene release];
    
}

- (void)scrollLayer:(CCScrollLayer *)sender scrolledToPageNumber:(int)page
{
    self.currentPage = page;
}

@end
