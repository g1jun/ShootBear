//
//  ILDataSimpleSave.m
//  ShootBear
//
//  Created by mac on 13-9-23.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILDataSimpleSave.h"
#import "NSDictionary+DeepCopy.h"

static ILDataSimpleSave *_dataSimpleSave = nil;

@implementation ILDataSimpleSave

- (id)init
{
    self = [super init];
    if (self) {
        _dataSave = [[NSUserDefaults standardUserDefaults] retain];
    }
    return self;
}

- (void)dealloc
{
    [_dataSave synchronize];
    [_dataSave release];
    [super dealloc];
}

+ (ILDataSimpleSave *)sharedDataSave
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_dataSimpleSave == nil) {
            _dataSimpleSave = [[ILDataSimpleSave alloc] init];
        }
    });
    return _dataSimpleSave;
}

- (void)saveString:(NSString *)value forKey:(NSString *)key
{
    [_dataSave setObject:value forKey:key];
    [_dataSave synchronize];
}

- (void)saveInt:(int)vlaue forKey:(NSString *)key
{
    [_dataSave setInteger:vlaue forKey:key];
    [_dataSave synchronize];

}

- (void)saveFloat:(float)value forKey:(NSString *)key
{
    [_dataSave setFloat:value forKey:key];
    [_dataSave synchronize];

}

- (void)saveBool:(BOOL)vlaue forKey:(NSString *)key
{
    [_dataSave setBool:vlaue forKey:key];
    [_dataSave synchronize];

}

- (NSString *)keyStringWithLevel:(Level)level
{
    return [NSString stringWithFormat:@"level_pass_state-%i-%i", level.page, level.levelNo];
}

- (void)saveLevelPass:(Level)level grade:(LevelGrade)grade
{
    NSString *key = [self keyStringWithLevel:level];
    [_dataSave setInteger:grade forKey:key];
    [_dataSave synchronize];
}

- (NSString *)stringWithKey:(NSString *)key
{
    return [_dataSave stringForKey:key];
}

- (int)intWithKey:(NSString *)key
{
    return [_dataSave integerForKey:key];
}

- (float)floatWithKey:(NSString *)key
{
    return [_dataSave floatForKey:key];
}

- (BOOL)boolWithKey:(NSString *)key
{
    return [_dataSave boolForKey:key];
}


- (LevelGrade)levelState:(Level)leve
{
    NSString *key = [self keyStringWithLevel:leve];
    return [_dataSave integerForKey:key];
}

@end
