//
//  ILLabelTTF.m
//  ShootBear
//
//  Created by mac on 13-9-30.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLabelTTF.h"

@implementation ILLabelTTF

- (void)didLoadFromCCB
{
    NSString *signString = self.string;
    NSString *newString = NSLocalizedString(signString, Nil);
    self.string = newString;
}

@end
