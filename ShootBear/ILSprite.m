//
//  ILSprite.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-13.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSprite.h"
#import "CCSpriteFrameCache+ILSpriteNameSearch.h"

@implementation ILSprite
- (void)dealloc
{
    self.imageName = nil;
    self.pngFileName = nil;
    [super dealloc];
}

- (void)setDisplayFrame:(CCSpriteFrame *)newFrame
{
    [super setDisplayFrame:newFrame];
    NSString *name = [[CCSpriteFrameCache sharedSpriteFrameCache] nameBySpriteFrame:newFrame];
    self.pngFileName = newFrame.textureFilename;
    self.imageName = [name stringByDeletingPathExtension];
}

- (CCTexture2D *)texture
{
    CCTexture2D *ret = [super texture];
    if (ret ==nil) {
        return [[self.children objectAtIndex:0] texture];
    } else {
        return ret;
    }
    return nil;
}

@end
