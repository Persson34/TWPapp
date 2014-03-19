//
//  TWPUser.m
//
//  Created by Naresh Kumar D on 3/18/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TWPUser.h"
#import "Stamps.h"
#import "Location.h"


NSString *const kTWPUserStampCount = @"stampCount";
NSString *const kTWPUserStamps = @"stamps";
NSString *const kTWPUserUserId = @"userId";
NSString *const kTWPUserUserProfile = @"user_profile";
NSString *const kTWPUserCode = @"code";
NSString *const kTWPUserLocation = @"location";
NSString *const kTWPUserMeta = @"meta";
NSString *const kTWPUserUsername = @"username";
NSString *const kTWPUserFollowersCount = @"followersCount";


@interface TWPUser ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TWPUser

@synthesize stampCount = _stampCount;
@synthesize stamps = _stamps;
@synthesize userId = _userId;
@synthesize userProfile = _userProfile;
@synthesize code = _code;
@synthesize location = _location;
@synthesize meta = _meta;
@synthesize username = _username;
@synthesize followersCount = _followersCount;


+ (TWPUser *)modelObjectWithDictionary:(NSDictionary *)dict
{
    TWPUser *instance = [[TWPUser alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.stampCount = [self objectOrNilForKey:kTWPUserStampCount fromDictionary:dict];
    NSObject *receivedStamps = [dict objectForKey:kTWPUserStamps];
    NSMutableArray *parsedStamps = [NSMutableArray array];
    if ([receivedStamps isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedStamps) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedStamps addObject:[Stamps modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedStamps isKindOfClass:[NSDictionary class]]) {
       [parsedStamps addObject:[Stamps modelObjectWithDictionary:(NSDictionary *)receivedStamps]];
    }

    self.stamps = [NSArray arrayWithArray:parsedStamps];
            self.userId = [[self objectOrNilForKey:kTWPUserUserId fromDictionary:dict] doubleValue];
            self.userProfile = [self objectOrNilForKey:kTWPUserUserProfile fromDictionary:dict];
            self.code = [self objectOrNilForKey:kTWPUserCode fromDictionary:dict];
            self.location = [Location modelObjectWithDictionary:[dict objectForKey:kTWPUserLocation]];
            self.meta = [self objectOrNilForKey:kTWPUserMeta fromDictionary:dict];
            self.username = [self objectOrNilForKey:kTWPUserUsername fromDictionary:dict];
            self.followersCount = [self objectOrNilForKey:kTWPUserFollowersCount fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stampCount forKey:kTWPUserStampCount];
NSMutableArray *tempArrayForStamps = [NSMutableArray array];
    for (NSObject *subArrayObject in self.stamps) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForStamps addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForStamps addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForStamps] forKey:@"kTWPUserStamps"];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kTWPUserUserId];
    [mutableDict setValue:self.userProfile forKey:kTWPUserUserProfile];
    [mutableDict setValue:self.code forKey:kTWPUserCode];
    [mutableDict setValue:[self.location dictionaryRepresentation] forKey:kTWPUserLocation];
    [mutableDict setValue:self.meta forKey:kTWPUserMeta];
    [mutableDict setValue:self.username forKey:kTWPUserUsername];
    [mutableDict setValue:self.followersCount forKey:kTWPUserFollowersCount];

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

    self.stampCount = [aDecoder decodeObjectForKey:kTWPUserStampCount];
    self.stamps = [aDecoder decodeObjectForKey:kTWPUserStamps];
    self.userId = [aDecoder decodeDoubleForKey:kTWPUserUserId];
    self.userProfile = [aDecoder decodeObjectForKey:kTWPUserUserProfile];
    self.code = [aDecoder decodeObjectForKey:kTWPUserCode];
    self.location = [aDecoder decodeObjectForKey:kTWPUserLocation];
    self.meta = [aDecoder decodeObjectForKey:kTWPUserMeta];
    self.username = [aDecoder decodeObjectForKey:kTWPUserUsername];
    self.followersCount = [aDecoder decodeObjectForKey:kTWPUserFollowersCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stampCount forKey:kTWPUserStampCount];
    [aCoder encodeObject:_stamps forKey:kTWPUserStamps];
    [aCoder encodeDouble:_userId forKey:kTWPUserUserId];
    [aCoder encodeObject:_userProfile forKey:kTWPUserUserProfile];
    [aCoder encodeObject:_code forKey:kTWPUserCode];
    [aCoder encodeObject:_location forKey:kTWPUserLocation];
    [aCoder encodeObject:_meta forKey:kTWPUserMeta];
    [aCoder encodeObject:_username forKey:kTWPUserUsername];
    [aCoder encodeObject:_followersCount forKey:kTWPUserFollowersCount];
}


@end
