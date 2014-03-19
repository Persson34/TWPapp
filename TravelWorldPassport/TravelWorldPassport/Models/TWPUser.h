//
//  TWPUser.h
//
//  Created by Naresh Kumar D on 3/18/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;

@interface TWPUser : NSObject <NSCoding>

@property (nonatomic, strong) NSString *stampCount;
@property (nonatomic, strong) NSArray *stamps;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *userProfile;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *meta;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *followersCount;

+ (TWPUser *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
