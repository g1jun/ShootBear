//
//  ILShoppingControl.m
//  ShootBear
//
//  Created by mac on 13-9-27.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShoppingControl.h"
#import "CCBReader.h"
#import "ILDataSimpleSave.h"

@implementation ILShoppingControl

- (id)init
{
    self = [super init];
    if (self) {
        CCNode *layer = [CCBReader nodeGraphFromFile:@"ShoppingLayer.ccbi" owner:self];
        layer.position = CGPointZero;
        [self addChild:layer];
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    [self updateCoinLabel];
    
}

- (void)updateCoinLabel
{
    float coinAmout = [[ILDataSimpleSave sharedDataSave] floatWithKey:kCoinAmount];
    NSString *string = [NSString stringWithFormat:@"%.1f", coinAmout];
    _coinLabel.string = string;
}

- (void)pressedBackButton:(id)sender
{
    [self removeFromParent];
}

@end
