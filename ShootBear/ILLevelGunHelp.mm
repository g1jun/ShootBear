//
//  ILLevelGunHelp.m
//  ShootBear
//
//  Created by mac on 13-9-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLevelGunHelp.h"
#import "CCBAnimationManager.h"

@implementation ILLevelGunHelp


- (void)switchGunType:(NSString *)gunType
{
    [super switchGunType:gunType];
    if (![gunType isEqualToString:kHandGun] && !_hasSwithGun) {
        [self.userObject runAnimationsForSequenceNamed:@"state1"];
        _hasSwithGun = YES;
    } else if (![gunType isEqualToString:kHandGun] && _hasSwithGun) {
        [self.userObject runAnimationsForSequenceNamed:@"state_finish"];

    }
    
    if ([gunType isEqualToString:kHandGun]) {
        [self.userObject runAnimationsForSequenceNamed:@"state0"];
    }
}


@end
