//
//  TWPShipping.h
//
//  Created by Self Devalapally on 4/28/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TWPShipping : NSObject <NSCoding>

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *addressTwo;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *meta;
@property (nonatomic, strong) NSString *addressOne;
@property (nonatomic, strong) NSString *state;

+ (TWPShipping *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
+(TWPShipping*)getStoredShippingDict;
-(void)saveShippingDict;

@end
