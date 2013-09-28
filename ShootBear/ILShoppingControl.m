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
#import "ILShoppingCard.h"

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

- (void)consumeCoins:(float)coins
{
    
}

- (void)consumeMoney:(float)money
{
    
}

- (void)dealWithPrice:(NSString *)labelString
{
    if ([labelString hasPrefix:@"$"]) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"$ "];
        NSString *temp = [labelString stringByTrimmingCharactersInSet:set];
        [self consumeMoney:[temp floatValue]];
    }
    [self consumeCoins:[labelString floatValue]];
}


- (void)pressedBuyButton:(id)sender
{
    ILShoppingCard *card = (ILShoppingCard *)[[sender parent] parent];
    [card buy];
    [self dealWithPrice:card.priceLabel.string];
}

@end
