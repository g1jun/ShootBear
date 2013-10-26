//
//  ILBox2dTools.m
//  ShootBear
//
//  Created by mac on 13-9-8.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBox2dTools.h"
#import "Box2D.h"
#import "ILSpriteBase.h"

@implementation ILBox2dTools

+ (void)changeCategoryBit:(CCNode *)node bit:(int )categoryBit
{
    [ILBox2dTools changeSingleCategoryBit:node bit:categoryBit];
    for (id ch in node.children) {
        [ILBox2dTools changeSingleCategoryBit:ch bit:categoryBit];
        [self changeCategoryBit:ch bit:categoryBit];
    }
}

+ (void)changeSingleCategoryBit:(CCNode *)node bit:(int)categoryBit
{
    if ([node isKindOfClass:[ILSpriteBase class]]) {
        ILSpriteBase *base = (ILSpriteBase *)node;
        if (base.b2Body == NULL) {
            return;
        }
        b2Fixture *fixture = base.b2Body->GetFixtureList();
        if (fixture == NULL) {
            return;
        }
        do {
            b2Filter filter = b2Filter(fixture->GetFilterData()) ;
            filter.categoryBits = categoryBit;
            fixture->SetFilterData(filter);
            fixture = fixture->GetNext();
        } while (fixture);
    }
}

@end
