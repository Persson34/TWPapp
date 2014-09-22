//
//  Location.h
//
//  Created by Self Devalapally on 4/25/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Initializer, Cloner;

@interface Location : NSObject <NSCoding>

@property (nonatomic, assign) BOOL isInitialized;
@property (nonatomic, strong) Initializer *initializer;
@property (nonatomic, strong) Cloner *cloner;

+ (Location *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
