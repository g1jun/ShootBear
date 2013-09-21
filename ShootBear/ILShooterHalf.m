//
//  ILShooterHalf.m
//  ShootBear
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShooterHalf.h"
#import "ILShooter.h"
#import "CCBReader.h"
#import "CCBAnimationManager+RmoveDeadNode.h"

@implementation ILShooterHalf

- (void)dealloc
{
    [_arm stopAccpetTouch];
    self.gunType = nil;
    _arm = nil;
    [super dealloc];
}

- (void)resetRotation
{
    self.arm.rotation = 0;
}

- (float)totalRotation
{
    return [self.arm currentDegree];
}

- (void)replaceGunType:(NSString * )type
{
    float rotation = [self totalRotation];
    if ([type hasPrefix:kCannon]) {
        ILShooterArm *cannonArm = (ILShooterArm *)[CCBReader nodeGraphFromFile:type];
        [self changeArm:cannonArm];
        self.gunType = type;
        return;
    }
    if ([self.gunType hasPrefix:kCannon]) {
        NSString *fileName = @"ShooterArmRight.ccbi";
        if ([type rangeOfString:@"Left"].length != 0) {
            fileName = @"ShooterArmLeft.ccbi";
        }
        ILShooterArm *cannonArm = (ILShooterArm *)[CCBReader nodeGraphFromFile:fileName];
        [self changeArm:cannonArm];
    }
    [self.arm replaceGunType:type];
    [self.arm setAllRotation:rotation];
    self.gunType = type;

}

- (void)changeArm:(ILShooterArm *)cannonArm
{
    CCBAnimationManager *manager = self.userObject;
    [manager removeDeadNode:self.arm];
    cannonArm.position = self.arm.position;
    [cannonArm setAllRotation:[self totalRotation]];
    [self removeChild:self.arm cleanup:YES];
    [self.arm stopAccpetTouch];
    self.arm = cannonArm;
//    [self.arm setTexture:self.textureAtlas.texture];
    [self addChild:self.arm];
}


- (CGPoint)firePointGL
{
    CCNode *line = self.arm.gun.lineReference;
    return [line.parent convertToWorldSpace:line.position];
}



@end
