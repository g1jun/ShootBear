//
//  ILShoppingCard.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-28.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShoppingCard.h"
#import "ILDataSimpleSave.h"

@implementation ILShoppingCard

- (void)didLoadFromCCB
{
    
}

- (void)buy
{
    NSArray *array = [_data componentsSeparatedByString:@";"];
    for (NSString *keyValue in array) {
        if (keyValue != nil && ![keyValue isEqualToString:@""]) {
            NSArray *temp = [keyValue componentsSeparatedByString:@":"];
            if ([temp[0] isEqualToString:kCoinAmount]) {
                [self floatValue:temp];
            } else {
                [self intValue:temp];
            }
        }
    }
}

- (void)intValue:(NSArray *)temp
{
    int number = [[ILDataSimpleSave sharedDataSave] intWithKey:temp[0]];
    int numberAdd = [temp[1] intValue];
    [[ILDataSimpleSave sharedDataSave] saveInt:(number + numberAdd) forKey:temp[0]];
}

- (void)floatValue:(NSArray *)temp
{
    float number = [[ILDataSimpleSave sharedDataSave] intWithKey:temp[0]];
    float numberAdd = [temp[1] intValue];
    [[ILDataSimpleSave sharedDataSave] saveInt:(number + numberAdd) forKey:temp[0]];
}

@end
