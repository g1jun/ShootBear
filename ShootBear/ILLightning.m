//
//  ILLightning.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLightning.h"
#import "ILSprite.h"

#define ANIMATION_TIME_DUR 0.15

@implementation ILLightning

- (id)init
{
    self = [super init];
    if (self) {
        _currentIndex = 0;
        _sprites = [[NSMutableArray array] retain];
        [self schedule:@selector(updateAnimation:) interval:ANIMATION_TIME_DUR];
        for (int i = 1; i < 8; i ++) {
            ILSprite *sprite = [self spriteWithIndex:i];
            [_sprites addObject:sprite];
            [self addChild:sprite];
        }
    }
    return self;
}

- (ILSprite *)spriteWithIndex:(int)i
{
    NSString *fileName = [NSString stringWithFormat:@"lightning%i.png", i];
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:fileName];
    ILSprite *sprite = [ILSprite spriteWithTexture:texture];
    sprite.imageName = fileName;
    sprite.pngFileName = fileName;
    CGSize size = [CCDirector sharedDirector].winSize;
    [sprite setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    sprite.anchorPoint = CGPointZero;
    sprite.position = CGPointZero;
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    [sprite.texture setTexParameters:&tp];
    sprite.visible = NO;
    return sprite;
}

- (void)updateAnimation:(float)delta
{
    _currentIndex = (_currentIndex + 1) % _sprites.count;
    [self hideAllSprites];
    [_sprites[_currentIndex] setVisible:YES];
}

- (void)hideAllSprites
{
    for (ILSprite *sprite in _sprites) {
        sprite.visible = NO;
    }
}

- (void)dealloc
{
    [_sprites release], _sprites = nil;
    [super dealloc];
}

@end
