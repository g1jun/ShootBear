//
//  ILShoppingControl.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-27.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CCNode.h"
#import "ILShoppingCard.h"

@interface ILShoppingControl : CCNode <UIAlertViewDelegate>
{
    CCLabelTTF * _coinLabel;
    CCLabelTTF *_fireGunLabel;
    CCLabelTTF *_electricGunLabel;
    CCLabelTTF *_cannonLabel;
    CCLabelTTF *_bulletLabel;
    ILShoppingCard *_shoppingCard;
}

@end
