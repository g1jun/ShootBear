//
//  ILGun.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILLineReference.h"
#import "ILCannonIndicator.h"
//ccnode
@interface ILGun : ILSprite
{
    NSString *_bulletCCBName;
    ILCannonIndicator *_cannonIndicator;
}

@property (assign, nonatomic) ILLineReference *lineReference;

- (void)fire;

- (CCSprite *)findGunSprite;

- (float)lineTotalDegree;

//- (CGPoint)lineReferenceVector;

@end
