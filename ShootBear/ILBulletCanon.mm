//
//  ILBulletCanon.m
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-9-17.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILBulletCanon.h"
#import "CCBReader.h"
#import "ILQueryTool.h"
#import "ILBox2dConfig.h"
#import "CCBAnimationManager.h"
#import "ILBox2dFactory.h"
#import "CCNode+CCBRelativePositioning.h"
#import "ILBear.h"
#import "SimpleAudioEngine.h"

class BulletCanonExplosionCallback : public b2QueryCallback
{
public:
    b2Vec2 _position;
    float _killR;
    float _resultion;
    BulletCanonExplosionCallback(b2Vec2 position, float killR, float resultion)
    {
        _killR = killR;
        _position = position;
        _resultion = resultion;
    }
    bool ReportFixture(b2Fixture* fixture) {
        id node = (id)fixture->GetBody()->GetUserData();
        if ([node isKindOfClass:[ILSpriteBase class]]) {
            ILSpriteBase *base = (ILSpriteBase *)node;
            if (!base.isStatic) {
                b2Body *body = fixture->GetBody();
                id node = (id)body->GetUserData();
                if ([[node collisionCCNode] isKindOfClass:[ILBear class]]) {
                    UInt16 category = fixture->GetFilterData().categoryBits;
                    if(category == 1 << 1)
                    {
                        [[ILBox2dFactory sharedFactory] bearDead:[node collisionCCNode]];
                    }
                    return true;
                }
                b2Vec2 bodyPosition = body->GetWorldCenter();
                b2Vec2 temp = bodyPosition -  _position;
                float size = _killR - temp.Length();
                if (size < 0) {
                    size = 0;
                }
                temp.Normalize();
                temp.operator*=(size * _resultion * 0.01);
                body->ApplyLinearImpulse(temp, body->GetWorldCenter());
                 
            }
        }
        
        return true;
    }
};

@implementation ILBulletCanon


- (void)lifeStart
{
    if (_lifeStart) {
        return;
    }
    [super lifeStart];
    [self schedule:@selector(updateTimer:) interval:1];
    _flash.visible = YES;
    [self.userObject runAnimationsForSequenceNamed:@"flash"];
    _lifeStart = YES;

}

- (void)onEnter
{
    [super onEnter];
}


- (void)didLoadFromCCB
{
    _timer.string = [NSString stringWithFormat:@"%i", (int)[self life]];

}

- (void)updateTimer:(float)delta
{
    NSString *temp = _timer.string;
    int time = [temp intValue];
    time--;
    _timer.string = [NSString stringWithFormat:@"%i", time];
}

- (float)life
{
    return 6;
}

- (void)update:(ccTime)delta
{
    [super update:delta];
    if (_timer && self.entity) {
        _timer.position = self.entity.position;
    }
    if (_timer && _flash) {
        _flash.position = _timer.position;
    }
}

- (void)explosion
{
    CGRect r = self.entity.boundingBox;
    float killR = ccpDistance(CGPointZero, ccpFromSize(r.size)) / 2 * PIXELS_PER_METER;
    
    BulletCanonExplosionCallback callback(b2Vec2(self.entity.position.x / PIXELS_PER_METER,
                                                 self.entity.position.y / PIXELS_PER_METER),
                                          killR,
                                          [self resolutionScale]);
    [ILQueryTool queryAround:self.entity callback:&callback scale:6];
}

- (void)lifeEnd
{
    [self explosion];
    _flash.visible = NO;
    [self.userObject removeUnusedNode:_flash];
    [_flash removeFromParent], _flash = nil;
    CCNode *explosion = [CCBReader nodeGraphFromFile:@"CannonExplosion.ccbi"];
    explosion.position = self.entity.position;
    [self addChild:explosion];
    [self performSelector:@selector(destroySelf) withObject:nil afterDelay:1.05];
    [_timer removeFromParent], _timer = nil;
    [self.entity removeFromParent], self.entity = nil;
    [[SimpleAudioEngine sharedEngine] playEffect:@"bomb.wav"];
    
    
}

- (void)destroySelf
{
    [self unscheduleAllSelectors];
    [self removeFromParent];
}


@end
