//
//  ILCannonIndicator.h
//  ShootBear
//
//  Created by mac on 13-9-16.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILSprite.h"

@interface ILCannonIndicator : ILSprite <CCTouchOneByOneDelegate>
{
    NSMutableArray *_array;
    float _speed;
}

- (float)cannonSpeed;

@end
