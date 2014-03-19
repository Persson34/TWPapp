//
//  Stamps.h
//
//  Created by Naresh Kumar D on 3/18/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Stamps : NSObject <NSCoding>

@property (nonatomic, strong) NSString *stampId;
@property (nonatomic, strong) NSString *stampUrl;

+ (Stamps *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
