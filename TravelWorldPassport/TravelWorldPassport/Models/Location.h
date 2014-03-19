//
//  Location.h
//
//  Created by Naresh Kumar D on 3/18/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Location : NSObject <NSCoding>

@property (nonatomic, assign) BOOL isInitialized;

+ (Location *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
