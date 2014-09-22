//
//  Location.m
//
//  Created by Self Devalapally on 4/25/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Location.h"
#import "Initializer.h"
#import "Cloner.h"


NSString *const kLocationIsInitialized = @"__isInitialized__";
NSString *const kLocationInitializer = @"__initializer__";
NSString *const kLocationCloner = @"__cloner__";


@interface Location ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Location

@synthesize isInitialized = _isInitialized;
@synthesize initializer = _initializer;
@synthesize cloner = _cloner;


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
            self.initializer = [Initializer modelObjectWithDictionary:[dict objectForKey:kLocationInitializer]];
            self.cloner = [Cloner modelObjectWithDictionary:[dict objectForKey:kLocationCloner]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.isInitialized] forKey:kLocationIsInitialized];
    [mutableDict setValue:[self.initializer dictionaryRepresentation] forKey:kLocationInitializer];
    [mutableDict setValue:[self.cloner dictionaryRepresentation] forKey:kLocationCloner];

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
    self.initializer = [aDecoder decodeObjectForKey:kLocationInitializer];
    self.cloner = [aDecoder decodeObjectForKey:kLocationCloner];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_isInitialized forKey:kLocationIsInitialized];
    [aCoder encodeObject:_initializer forKey:kLocationInitializer];
    [aCoder encodeObject:_cloner forKey:kLocationCloner];
}


@end
