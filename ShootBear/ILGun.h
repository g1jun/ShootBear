//
//  ILGun.h
//  ShootBear
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILLineReference.h"

@interface ILGun : CCNode
{
    NSString *_bulletCCBName;
}

@property (assign, nonatomic) ILLineReference *lineReference;

- (void)fire;

- (CCSprite *)findGunSprite;

- (float)lineTotalDegree;

- (CGPoint)lineReferenceVector;

@end
