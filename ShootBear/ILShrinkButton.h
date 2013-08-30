//
//  ILShrinkButton.h
//  ShootBear
//
//  Created by mac on 13-8-29.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"

@protocol ILShrinkButtonDelegate <NSObject>

- (void)fold;

- (void)unfold;

@end

@interface ILShrinkButton : CCNode
{
    BOOL _isFold;
}

@property (assign, nonatomic) id<ILShrinkButtonDelegate> delegate;

@end
