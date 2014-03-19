//
//  Location.m
//
//  Created by Naresh Kumar D on 3/18/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


NSString *const kLocationIsInitialized = @"__isInitialized__";


@interface Location ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Location

@synthesize isInitialized = _isInitialized;


+ (Location *)modelObjectWithDictionary:(NSDictionary *)dict
{
    Location *instance = [[Location alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.isInitialized = [[self objectOrNilForKey:kLocationIsInitialized fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.isInitialized] forKey:kLocationIsInitialized];

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

    self.isInitialized = [aDecoder decodeBoolForKey:kLocationIsInitialized];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_isInitialized forKey:kLocationIsInitialized];
}


@end
