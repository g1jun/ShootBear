//
//  ILCollisionParameter.h
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILCollisionParameter : NSObject

@property (unsafe_unretained, nonatomic) SEL selector;
@property (unsafe_unretained, nonatomic) NSString *delegateKey;
@property (unsafe_unretained, nonatomic) id meReference;
@property (unsafe_unretained, nonatomic) id anotherReference;

@end
