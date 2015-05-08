//
//  ILHomeLayerControl.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-10-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILHomeLayerControl.h"
#import "CCBReader.h"
#import "ILMenuScene.h"
#import "ILSceneReplace.h"
#import "ILShoppingControl.h"
#import "ILMenuScene.h"

@implementation ILHomeLayerControl


+ (id)scene
{
    CCScene *scene = [CCScene node];
    ILHomeLayerControl *home = [ILHomeLayerControl node];
    [scene addChild:home];
//    ILMenuScene *scene = [ILMenuScene node];
    return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        CCNode *home = [CCBReader nodeGraphFromFile:@"HomeLayer.ccbi" owner:self];
        [self addChild:home];
    }
    return self;
}

- (void)pressedNextButton:(id)sender
{
    [ILSceneReplace replaceScene:[ILMenuScene node]];
}

- (void)pressedShoppingButton:(id)sender
{
    ILShoppingControl *shopping = [ILShoppingControl node];
    [self addChild:shopping];
}

@end
