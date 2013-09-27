//
//  ILDataSimpleSave.h
//  ShootBear
//
//  Created by mac on 13-9-23.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILStruct.h"

@interface ILDataSimpleSave : NSObject
{
    @private
    NSUserDefaults *_dataSave;
}

- (void)saveString:(NSString *)value forKey:(NSString *)key;
- (void)saveInt:(int)vlaue forKey:(NSString *)key;
- (void)saveFloat:(float)value forKey:(NSString *)key;
- (void)saveBool:(BOOL)vlaue forKey:(NSString *)key;
- (void)saveLevelPass:(Level)level;


- (NSString *)stringWithKey:(NSString *)key;
- (int)intWithKey:(NSString *)key;
- (float)floatWithKey:(NSString *)key;
- (BOOL)boolWithKey:(NSString *)key;
- (BOOL)levelState:(Level)leve;
+ (ILDataSimpleSave *)sharedDataSave;

@end
