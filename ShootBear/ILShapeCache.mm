//
//  ILShapeCache.m
//  ShootBear
//
//  Created by mac on 13-8-12.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ILShapeCache.h"
#import "CCNode+CCBRelativePositioning.h"
#import "CCSprite.h"
#import "ILBox2dConfig.h"


#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#   define CGPointFromString_ CGPointFromString
#else
static CGPoint CGPointFromString_(NSString* str)
{
    NSString* theString = str;
    theString = [theString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [theString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}
#endif


class FixtureDef
{
public:
    FixtureDef()
    : next(0)
    {}
    
    ~FixtureDef()
    {
        delete next;
        delete fixture.shape;
    }
    
    FixtureDef *next;
    b2FixtureDef fixture;
    int callbackData;
};


@interface BodyDef : NSObject
{
@public
    FixtureDef *fixtures;
    CGPoint anchorPoint;
}
@end


@implementation BodyDef

-(id) init
{
    self = [super init];
    if(self)
    {
        fixtures = 0;
    }
    return self;
}

-(void) dealloc
{
    delete fixtures;
    [super dealloc];
}

@end



@implementation ILShapeCache

+ (ILShapeCache *)sharedShapeCache
{
    static ILShapeCache *shapeCache = 0;
    if(!shapeCache)
    {
        shapeCache = [[ILShapeCache alloc] init];
    }
    return shapeCache;
}


-(id) init
{
    self = [super init];
    if(self)
    {
        shapeDic_ = [NSMutableDictionary new];
    }
    return self;
}

-(void) dealloc
{
    [shapeDic_ release];
    [super dealloc];
}

-(void) addFixturesToBody:(b2Body*)body forPhysicsSprite:(ILPhysicsSprite *)sprite
{
    CGPoint moveVector = [self moveVector:sprite];
    NSDictionary *dic = [[self applayVector:moveVector forShape:sprite.imageName] retain];
    BodyDef *so = [self createBodyDefWithName:dic];
    [dic release];
    [self configFixture:body bodyDef:so];
    
}

- (CGPoint)moveVector:(ILPhysicsSprite *)sprite
{
    float scale = [self spriteScale:sprite];
    CGPoint size = ccpFromSize(sprite.contentSize);
    CGPoint imageSize = ccpMult(size, scale);
    CGPoint imageAnchor = [self anchorPointForShape:sprite.imageName];
    CGPoint spriteAnchor = sprite.anchorPoint;
    CGPoint vector = ccpSub(imageAnchor, spriteAnchor);
    CGPoint moveVector = ccp(vector.x * imageSize.x, vector.y * imageSize.y);
    return moveVector;
}

- (NSMutableDictionary *)applayVector:(CGPoint)moveVector forShape:(NSString *)shapeName;
{
    NSMutableDictionary *dic = [shapeDic_[shapeName] mutableCopy];
    NSMutableArray *fixtures = dic[@"fixtures"];
    for (NSMutableDictionary *item in fixtures) {
        if ([self isPolygons:item]) {
            NSMutableArray *polygons = item[@"polygons"];
            for (NSMutableArray *item in polygons) {
                for (int i = 0; i < item.count; i++) {
                    NSString *pString = item[i];
                    CGPoint p = CGPointFromString_(pString);
                    item[i] = NSStringFromCGPoint(ccpAdd(p, moveVector));
                    
                }
            }
            
        } else if ([self isCycle:item]) {
            NSMutableDictionary *circle = item[@"circle"];
            CGPoint p = CGPointFromString_([circle objectForKey:@"position"]);
            circle[@"position"] = NSStringFromCGPoint(ccpAdd(p, moveVector));
        }
    }
    return [dic autorelease];
}

- (float)spriteScale:(ILPhysicsSprite *)sprite
{
    float resolutionScale = 2 - [sprite resolutionScale] + 1;
    float imageScale = 1 / [self shapeScale:sprite.imageName];
    return resolutionScale * imageScale;
}

-(void) addFixturesToBody:(b2Body*)body forShapeName:(NSString*)shape
{
    NSDictionary *bodyData = [shapeDic_ objectForKey:shape];
    BodyDef *so = [self createBodyDefWithName:bodyData];
    [self configFixture:body bodyDef:so];
}

- (void)configFixture:(b2Body *)body bodyDef:(BodyDef *)so
{
    assert(so);
    FixtureDef *fix = so->fixtures;
    while(fix)
    {
        body->CreateFixture(&fix->fixture);
        fix = fix->next;
    }
}

-(CGPoint) anchorPointForShape:(NSString*)shape
{
    NSDictionary *bodyData = shapeDic_[shape];
    return CGPointFromString_([bodyData objectForKey:@"anchorpoint"]);
}


-(void) addShapesWithFile:(NSString*)plist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:plist
                                                     ofType:nil
                                                inDirectory:nil];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *metadataDict = [dictionary objectForKey:@"metadata"];
    int format = [[metadataDict objectForKey:@"format"] intValue];
    NSAssert(format == 1, @"Format not supported");
    NSMutableDictionary *bodyDict = [dictionary objectForKey:@"bodies"];
    [shapeDic_ addEntriesFromDictionary:bodyDict];
    for (id key in bodyDict) {
        NSMutableDictionary *bodyData = bodyDict[key];
        float ptm = [[metadataDict objectForKey:@"ptm_ratio"] floatValue] / 100;
        bodyData[@"ptm_ratio"] = [NSString stringWithFormat:@"%f", ptm];
    }
}

- (BOOL)isPolygons:(NSDictionary *)fixtureData
{
    return [[fixtureData objectForKey:@"fixture_type"] isEqual:@"POLYGON"];
}

- (BOOL)isCycle:(NSDictionary *)fixtureData
{
    return [[fixtureData objectForKey:@"fixture_type"] isEqual:@"CIRCLE"];
}

- (BodyDef *)createBodyDefWithName:(NSDictionary *)bodyData
{
    BodyDef *bodyDef = [[[BodyDef alloc] init] autorelease];
    bodyDef->anchorPoint = CGPointFromString_([bodyData objectForKey:@"anchorpoint"]);
    NSArray *fixtureList = [bodyData objectForKey:@"fixtures"];
    FixtureDef **nextFixtureDef = &(bodyDef->fixtures);
    localRatio_ = ptmRatio_/ ([bodyData[@"ptm_ratio"] floatValue]);
    for(NSDictionary *fixtureData in fixtureList) {
        if([self isPolygons:fixtureData]) {
            NSArray *polygonsArray = [fixtureData objectForKey:@"polygons"];
            for(int i = 0; i < polygonsArray.count; i++) {
                FixtureDef *fix = [self createPolygonFixtureDef:fixtureData index:i];
                *nextFixtureDef = fix;
                nextFixtureDef = &(fix->next);
            }
        }
        else if([self isCycle:fixtureData]) {
            FixtureDef *fix = [self createCircleFixtureDef:fixtureData];
            *nextFixtureDef = fix;
            nextFixtureDef = &(fix->next);
        } else {
            assert(0);
        }
    }
    return bodyDef;
}


- (FixtureDef *)createPolygonFixtureDef:(NSDictionary *)fixtureData index:(int)index
{
    FixtureDef *fix = new FixtureDef();
    fix->fixture = [self fixtureDef:fixtureData];; // copy basic data
    fix->callbackData = [[fixtureData objectForKey:@"userdataCbValue"] intValue];
    NSArray *polygonsArray = [fixtureData objectForKey:@"polygons"];
    NSArray *polygonArray = polygonsArray[index];
    fix->fixture.shape = [self createPolygonShape:polygonArray];
    return fix;
}

- (void)setPTMRatio:(float)ptmRatio
{
    ptmRatio_ = ptmRatio;
}

- (float)localPTMRatio:(NSString *)shape
{
    return ptmRatio_ / [self shapeScale:shape];
}

- (b2PolygonShape *)createPolygonShape:(NSArray *)polygonArray
{
    b2Vec2 vertices[b2_maxPolygonVertices];
    b2PolygonShape *polyshape = new b2PolygonShape();
    int vindex = 0;
    assert([polygonArray count] <= b2_maxPolygonVertices);
    for(NSString *pointString in polygonArray)
    {
        CGPoint offset = CGPointFromString_(pointString);
        vertices[vindex].x = (offset.x / localRatio_) ;
        vertices[vindex].y = (offset.y / localRatio_) ;
        vindex++;
    }
    
    polyshape->Set(vertices, vindex);
    return polyshape;
}

- (FixtureDef *)createCircleFixtureDef:(NSDictionary *)fixtureData
{
    FixtureDef *fix = new FixtureDef();
    fix->fixture = [self fixtureDef:fixtureData]; // copy basic data
    fix->callbackData = [[fixtureData objectForKey:@"userdataCbValue"] intValue];
    b2CircleShape *circleShape = [self createCircleshape:fixtureData];
    fix->fixture.shape = circleShape;
    return fix;
}

- (b2FixtureDef) fixtureDef:(NSDictionary *)fixtureData
{
    b2FixtureDef basicData;
    basicData.filter.categoryBits = [[fixtureData objectForKey:@"filter_categoryBits"] intValue];
    basicData.filter.maskBits = [[fixtureData objectForKey:@"filter_maskBits"] intValue];
    basicData.filter.groupIndex = [[fixtureData objectForKey:@"filter_groupIndex"] intValue];
    basicData.friction = [[fixtureData objectForKey:@"friction"] floatValue];
    basicData.density = [[fixtureData objectForKey:@"density"] floatValue];
    basicData.restitution = [[fixtureData objectForKey:@"restitution"] floatValue];
    basicData.isSensor = [[fixtureData objectForKey:@"isSensor"] boolValue];
    return basicData;
}


- (b2CircleShape *)createCircleshape:(NSDictionary*)fixtureData
{
    NSDictionary *circleData = [fixtureData objectForKey:@"circle"];
    b2CircleShape *circleShape = new b2CircleShape();
    circleShape->m_radius = [[circleData objectForKey:@"radius"] floatValue]  / localRatio_;
    CGPoint p = CGPointFromString_([fixtureData objectForKey:@"position"]);
    circleShape->m_p = b2Vec2(p.x / localRatio_, p.y / localRatio_);
    return circleShape;
}

-(float) shapeScale:(NSString *)shape
{
    return [shapeDic_[shape][@"ptm_ratio"] floatValue];
}

@end
