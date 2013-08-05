
//
//  ILTMXLayer.m
//  ShootBear
//
//  Created by mac on 13-8-4.
//  Copyright 2013年 mac. All rights reserved.
//

#import "ILTMXLayer.h"


@implementation ILTMXLayer

+ (id) nodeWithB2World:(b2World *)world {
    ILTMXLayer *tmxLayer = [[self alloc] init];
    if (self) {
        CCTMXTiledMap *tmxMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map1.tmx"];
        [tmxLayer addChild:tmxMap];
        ILTMXToBox2d *tmxToBox2d = [ILTMXToBox2d new];
        tmxToBox2d.world = world;
        tmxToBox2d.collisionString = [self loadCollisionString];
        tmxToBox2d.tmxMap = tmxMap;
        [tmxToBox2d loadPhysics];
        [tmxToBox2d release];
    }
    return [tmxLayer autorelease];
}

+ (NSString *) loadCollisionString
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"collision" ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        CCLOG(@"ILTMXLayer: error: %@",[error description]);
    }
    return string;

}

@end
