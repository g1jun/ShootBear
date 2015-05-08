//
//  ILShoppingCard.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-28.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"

/**
 
 Gun0:10;Gun1:10;
 
 */

@interface ILShoppingCard : CCNode
{
    NSString *_data;
}

@property (assign, nonatomic)CCLabelTTF *priceLabel;

- (void)buy;

@end
