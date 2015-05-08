//
//  ILShoppingControl.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-27.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShoppingControl.h"
#import "CCBReader.h"
#import "ILDataSimpleSave.h"
#import "ILShoppingCard.h"
#import "GRAlertView.h"
#import "Flurry.h"

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
    [self updateAll];
    
}

- (void)updateAll
{
    [self updateLabelWithKey:kCoinAmount label:_coinLabel];
    [self updateLabelWithKey:kFireGun label:_fireGunLabel];
    [self updateLabelWithKey:kElectriGun label:_electricGunLabel];
    [self updateLabelWithKey:kCannon label:_cannonLabel];
    [self updateLabelWithKey:kBulletQuantity label:_bulletLabel];
}

- (void)updateLabelWithKey:(NSString *)key label:(CCLabelTTF *)label
{
    int coinAmout = [[ILDataSimpleSave sharedDataSave] intWithKey:key];
    NSString *string = [NSString stringWithFormat:@"%i", coinAmout];
    label.string = string;
}

- (void)pressedBackButton:(id)sender
{
    [self removeFromParent];
}

- (void)consumeCoins:(float)coins
{
    [Flurry logEvent:@"Consume Coins" withParameters:@{@"coinsQuantity" : [NSString stringWithFormat:@"%f", coins]}];
    [self coinQuantityChange:-coins];

}

- (void)coinQuantityChange:(float)change
{
    float temp = [[ILDataSimpleSave sharedDataSave] floatWithKey:kCoinAmount];
    temp += change;
    [[ILDataSimpleSave sharedDataSave] saveFloat:temp forKey:kCoinAmount];
    [self updateAll];
}

- (void)consumeMoney:(float)money
{
    [self updateAll];

}

- (void)dealWithShopping
{
    NSString *labelString = _shoppingCard.priceLabel.string;
    if ([labelString hasPrefix:@"$"]) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"$ "];
        NSString *temp = [labelString stringByTrimmingCharactersInSet:set];
        [self consumeMoney:[temp floatValue]];
        return;
    }
    int price = [labelString intValue];
    int coinAmout = [[ILDataSimpleSave sharedDataSave] intWithKey:kCoinAmount];
    if (price > coinAmout) {
        [self showInfoAlertView];
    } else {
        [self showAskAlertView];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
        [_shoppingCard buy];
        int price = [_shoppingCard.priceLabel.string intValue];
        [self consumeCoins:price];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingUpdate object:nil];

    }
    _shoppingCard = nil;
}

- (void)showInfoAlertView
{
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:NSLocalizedString(@"ask", nil)
                                       message:NSLocalizedString(@"coin_not_enough", nil)
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
    alert.style = GRAlertStyleWarning;
    [alert show];
    [alert release];
}

- (void)showAskAlertView
{
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:NSLocalizedString(@"ask", nil)
                                                    message:NSLocalizedString(@"ask_info", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
    alert.style = GRAlertStyleInfo;
    [alert show];
    [alert release];
}


- (void)pressedBuyButton:(id)sender
{
    _shoppingCard = (ILShoppingCard *)[[sender parent] parent];
    [self dealWithShopping];
}

@end
