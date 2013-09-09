//
//  ILMenuButton.m
//  ShootBear
//
//  Created by mac on 13-9-3.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILMenuButton.h"

@implementation ILMenuButton

- (ILMenuItem *)menuItem
{
    if ([self.parent.parent isKindOfClass:[ILMenuItem class]]) {
        return (ILMenuItem *)self.parent.parent;
    }
    return nil;
}

@end
