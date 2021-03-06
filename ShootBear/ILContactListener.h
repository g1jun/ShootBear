//
//  ILContactListener.h
//  ShootBear
//
//  Created by 一叶   欢迎访问http://00red.com on 13-8-15.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Box2D.h>

class ILContactListener : public b2ContactListener {
    
    public:
    ILContactListener();
    ~ILContactListener();
    virtual void BeginContact(b2Contact* contact);
	virtual void EndContact(b2Contact* contact);
	virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    
    private:
    bool isSensor(b2Contact *contact);
    void dealWithCollisionOrder(id from, id to);

    
    
};
