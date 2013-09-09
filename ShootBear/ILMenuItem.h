//
//  ILMenuItem.h
//  ShootBear
//
//  Created by mac on 13-9-3.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "CCControlButton.h"

@interface ILMenuItem : CCNode
{
    CCSprite *_lockSprite;
    CCLabelTTF *_label;
}

@property (assign, nonatomic, readonly) int levelNO;
@property (assign, nonatomic, readonly) BOOL hasOpen;

- (void)open;

@end
