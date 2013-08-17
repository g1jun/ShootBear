//
//  ILTMXToBox2d.m
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILTMXToBox2d.h"
#import "ILShootBear.h"

@implementation ILTMXToBox2d

- (void) loadPhysics
{
    NSDictionary *tilesDic = [self parseTiles];
    CCTMXLayer *box2dLayer = [self.tmxMap layerNamed:@"box2d"];
    CGSize tilesCout = box2dLayer.layerSize;
    for (int x = 0; x < tilesCout.width; x++) {
        for (int y = 0; y < tilesCout.height; y++) {
            int tileType = [box2dLayer tileGIDAt:ccp(x, tilesCout.height - 1 - y)];
            if ([self isTileEmpty:tileType]) {
                continue;
            }
            NSString *key = [NSString stringWithFormat:@"%i", tileType];
            NSArray *lines = tilesDic[key];
            NSArray *physicsLines = [self configPhyscisLine:lines atTilePoint:ccp(x, y)];
            [self producePhysicsLines:physicsLines];
        }
    }
    
}

- (void) producePhysicsLines:(NSArray *)lines
{
    ILBox2dFactory *factory = [ILBox2dFactory sharedFactory];
    [factory createLineSegement:lines];
}

- (NSArray *)configPhyscisLine:(NSArray *)lines atTilePoint:(CGPoint) position
{
    NSMutableArray *physicsLines = [NSMutableArray array];
    for (ILLineSegment *lineSegement in lines) {
        ILLineSegment *physicsLine = [ILLineSegment new];
        physicsLine.start = [self convertToOpenGL:position line:lineSegement.start];
        physicsLine.end = [self convertToOpenGL:position line:lineSegement.end];
        [physicsLines addObject:physicsLine];
        [physicsLine release];
    }
    return physicsLines;
}

- (CGPoint)convertToOpenGL:(CGPoint)position line:(CGPoint)lineCoord
{
    CGSize tileSize = self.tmxMap.tileSize;
    const int x = position.x * tileSize.width + lineCoord.x;
    const int y = position.y * tileSize.height + (32 - lineCoord.y);
    return ccp(x, y);
}

- (BOOL) isTileEmpty:(int) tileType
{
    return tileType == 0;
}

- (NSMutableDictionary *) parseTiles
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\n\r"];
    NSArray *lines = [self.collisionString componentsSeparatedByCharactersInSet:set];
    NSMutableDictionary *tilesDic = [NSMutableDictionary dictionary];
    for (NSString *line in lines) {
        NSString *temp = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *segements = [temp componentsSeparatedByString:@" "];
        if ([segements count] < 2) {
            continue;
        }
        NSArray *tempArray = [self parseLineWithArray:segements];
        const NSString *tileNo = segements[0];
        tilesDic[tileNo] = tempArray;
    }
    return tilesDic;
}

- (NSArray *)parseLineWithArray:(NSArray *)segements
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 1; i < segements.count; i++) {
        NSArray *coord = [segements[i] componentsSeparatedByString:@","];
        ILLineSegment *lineSegment = [ILLineSegment new];
        lineSegment.start = [self parseCoordWithString:coord[0]];
        lineSegment.end = [self parseCoordWithString:coord[1]];
        [tempArray addObject:lineSegment];
        [lineSegment release];
    }
    return tempArray;
}

- (CGPoint)parseCoordWithString:(NSString *) coordString
{
    NSArray *coord = [coordString componentsSeparatedByString:@"x"];
    CGPoint point = ccp([coord[0] intValue], [coord[1] intValue]);
    return point;
}

- (void)dealloc
{
    [super dealloc];
    self.tmxMap = nil;
    self.collisionString = nil;
}

@end
