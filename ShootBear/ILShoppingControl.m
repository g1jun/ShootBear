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
#import "GRAlertView.h"

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

- (void)dealWithPrice:(NSString *)labelString
{
    if ([labelString hasPrefix:@"$"]) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"$ "];
        NSString *temp = [labelString stringByTrimmingCharactersInSet:set];
        [self consumeMoney:[temp floatValue]];
        return;
    }
    _price = [labelString intValue];
    int coinAmout = [[ILDataSimpleSave sharedDataSave] intWithKey:kCoinAmount];
    if (_price > coinAmout) {
        [self showInfoAlertView];
    } else {
        [self showAskAlertView];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1) {
        [self consumeCoins:_price];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingUpdate object:nil];

    }
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
    ILShoppingCard *card = (ILShoppingCard *)[[sender parent] parent];
    [card buy];
    [self dealWithPrice:card.priceLabel.string];
}

@end
