//
//  ILLineReference.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-10.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILLineReference.h"
#import "ILLinePoint.h"
#define POINTER_TOTAL 30
#define EMIT_RATE 0.25
#define ACCELERATION 20
#define POINT_END_SCALE 0.3

@interface ILLineReference ()

@property (retain, nonatomic) NSMutableArray *points;

@end

@implementation ILLineReference

- (void)dealloc
{
    self.points = nil;
    [super dealloc];
}

- (void)didLoadFromCCB
{
    self.visible = true;
    self.points = [NSMutableArray array];
    [self loadAllPoints];
    [self schedule:@selector(emitPoint:) interval:EMIT_RATE];    
}

- (void)emitPoint:(ccTime)delta
{
    ILLinePoint *last =  [[self.points lastObject] retain];
    [self.points removeLastObject];
    [last reset];
    [self scalePoint:last WithIndex:0];
    [self.points insertObject:last atIndex:0];
    [last release];
}

- (void)scalePoint:(CCNode *)point WithIndex:(int)index
{
    id scale = [CCScaleTo actionWithDuration:EMIT_RATE * (POINTER_TOTAL - index) scale:POINT_END_SCALE];
    [point runAction:scale];

}

- (void)loadAllPoints
{
    for (int i = 0; i < POINTER_TOTAL; i++) {
        ILLinePoint *point = [[ILLinePoint alloc] initWithAcc:ACCELERATION age:EMIT_RATE * i];
        [self.points addObject:point];
        [self addChild:point];
        point.scale = (POINTER_TOTAL - i) / (float)POINTER_TOTAL;
        [self scalePoint:point WithIndex:i];
        [point release];
    }
}

@end
