//
//  ILUsedOnceButton.h
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "CCControlButton.h"

@interface ILUsedOnceButton : CCNode

@property (assign, nonatomic, readonly)BOOL isSelected;
@property (assign, nonatomic, readonly) CCControlButton *button;


- (void)recover;
- (void)addTarget:(id)target action:(SEL)action;


@end
