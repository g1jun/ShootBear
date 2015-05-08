//
//  ILLevelHelper0-0.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLevelShootHelp.h"
#import "CCBAnimationManager.h"
@implementation ILLevelShootHelp

- (void)removeBear:(ILBear *)bear
{
    [super removeBear:bear];
    if (_bears.count > 0) {
        ILBear *temp = _bears[0];
        NSString *state = temp.levelState;
        if ([state hasPrefix:@"state"]) {
            [self.userObject runAnimationsForSequenceNamed:state];
        }
    }
    if(_bears.count == 0) {
        [self.userObject runAnimationsForSequenceNamed:@"state_finish"];
    }
}

- (float)levelCompletedDelay
{
    return 2.5;
}

@end
