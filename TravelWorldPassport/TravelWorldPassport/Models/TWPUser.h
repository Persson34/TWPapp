//
//  TWPUser.h
//
//  Created by Self Devalapally on 4/25/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;

@interface TWPUser : NSObject <NSCoding>

@property (nonatomic, assign) double stampCount;
@property (nonatomic, strong) NSMutableArray *stamps;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *userProfile;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *meta;
@property (nonatomic, assign) double followersCount;
@property (nonatomic, strong) NSString *name;

+ (TWPUser *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSString*)getFullName;
- (NSDictionary *)dictionaryRepresentation;

@end
