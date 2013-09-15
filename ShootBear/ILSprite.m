//
//  ILSprite.m
//  ShootBear
//
//  Created by mac on 13-9-13.
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

@end