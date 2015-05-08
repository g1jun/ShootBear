//
//  ILLevelCompletedLayer.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-10-4.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLevelCompletedLayer.h"
#import "CCBAnimationManager.h"

@implementation ILLevelCompletedLayer


- (void)setGrade:(LevelGrade)grade
{
    _grade = grade;
    if (grade == kGeneral) {
        [self.userObject setCompletedAnimationCallbackBlock:^(id sender) {
            [self.userObject runAnimationsForSequenceNamed:@"general"];
            [self.userObject setCompletedAnimationCallbackBlock:nil];
        }];
    } else if(grade == kGood) {
        [self.userObject setCompletedAnimationCallbackBlock:^(id sender) {
            [self.userObject runAnimationsForSequenceNamed:@"good"];
            [self.userObject setCompletedAnimationCallbackBlock:nil];
        }];
    }
}

- (void)setPercent:(float)percent
{
    int show = percent * 100;
    if (show > 1 && show < 99) {
        [self setGrade:kGeneral];
    } else if(show > 99) {
        [self setGrade:kGood];
    }
    NSString *temp = _percentLabel.string;
    NSString *number = [NSString stringWithFormat:@"%i%%", show];
    temp = [temp stringByAppendingString:number];
    _percentLabel.string = temp;
}

@end
