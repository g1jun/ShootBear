//
//  ILUsedOnceButton.h
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "CCControlButton.h"

@interface ILGunSwitchControl : CCNode
{
    CCLabelTTF *_label;
    NSString *_gunType;
}

@property (assign, nonatomic, readonly)BOOL isSelected;
@property (assign, nonatomic, readonly) CCControlButton *button;


- (void)recover;
- (void)addTarget:(id)target action:(SEL)action;
- (int)quantityBullet;

- (void)bulletHasUsed;


@end
