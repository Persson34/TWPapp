//
//  Stamps.m
//
//  Created by Self Devalapally on 4/25/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Stamps.h"


NSString *const kStampsStampId = @"stampId";
NSString *const kStampsStampUrl = @"stampUrl";


@interface Stamps ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Stamps

@synthesize stampId = _stampId;
@synthesize stampUrl = _stampUrl;


+ (Stamps *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Stamps *instance = [[Stamps alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.stampId = [[self objectOrNilForKey:kStampsStampId fromDictionary:dict] doubleValue];
            self.stampUrl = [self objectOrNilForKey:kStampsStampUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stampId] forKey:kStampsStampId];
    [mutableDict setValue:self.stampUrl forKey:kStampsStampUrl];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.stampId = [aDecoder decodeDoubleForKey:kStampsStampId];
    self.stampUrl = [aDecoder decodeObjectForKey:kStampsStampUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_stampId forKey:kStampsStampId];
    [aCoder encodeObject:_stampUrl forKey:kStampsStampUrl];
}


@end
