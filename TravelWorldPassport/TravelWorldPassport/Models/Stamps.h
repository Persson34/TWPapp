//
//  Stamps.h
//
//  Created by Self Devalapally on 4/25/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Stamps : NSObject <NSCoding>

@property (nonatomic, assign) double stampId;
@property (nonatomic, strong) NSString *stampUrl;

+ (Stamps *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
