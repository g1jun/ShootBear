//
//  ILContactListener.m
//  ShootBear
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILContactListener.h"
#import "ILCollisionParameter.h"
#import "ILCollisionDelegate.h"
#import "ILBox2dFactory.h"

ILContactListener::ILContactListener() {
    
}

ILContactListener::~ILContactListener() {
    
}

void ILContactListener::BeginContact(b2Contact *contact) {
    if (this->isSensor(contact)) {
        return;
    }
    id node1 = (id)contact->GetFixtureA()->GetBody()->GetUserData();
    id node2 = (id)contact->GetFixtureB()->GetBody()->GetUserData();
    if (node1 == nil || node2 == nil) {
        CCLOGWARN(@"collision type must be not nil");
        return;
    }
    this->dealWithCollisionOrder(node1, node2);
    this->dealWithCollisionOrder(node2, node1);
    
}

void ILContactListener::dealWithCollisionOrder(id from, id to) {
    if ([from respondsToSelector:@selector(collisionResponse:)]) {
        ILCollisionParameter *parameter = [[from collisionResponse:to] retain];
        [[ILBox2dFactory sharedFactory] runTarget:parameter];
        [parameter release];
    }
    
    if ([from respondsToSelector:@selector(collisionDealWith:)]) {
        [from collisionDealWith:to];
    }
    
    
}

bool ILContactListener::isSensor(b2Contact *contact) {
    bool bodyA = contact->GetFixtureA()->IsSensor();
    bool bodyB = contact->GetFixtureB()->IsSensor();
    return bodyA || bodyB;
}



void ILContactListener::EndContact(b2Contact *contact) {
    
}

void ILContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {
    
}

void ILContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse) {
    
}




