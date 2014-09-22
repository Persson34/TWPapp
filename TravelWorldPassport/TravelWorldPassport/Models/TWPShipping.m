//
//  TWPShipping.m
//
//  Created by Self Devalapally on 4/28/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TWPShipping.h"


NSString *const kTWPShippingCity = @"city";
NSString *const kTWPShippingPostalCode = @"postalCode";
NSString *const kTWPShippingCode = @"code";
NSString *const kTWPShippingAddressTwo = @"addressTwo";
NSString *const kTWPShippingFullName = @"fullName";
NSString *const kTWPShippingMeta = @"meta";
NSString *const kTWPShippingAddressOne = @"addressOne";
NSString *const kTWPShippingState = @"state";


@interface TWPShipping ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TWPShipping

@synthesize city = _city;
@synthesize postalCode = _postalCode;
@synthesize code = _code;
@synthesize addressTwo = _addressTwo;
@synthesize fullName = _fullName;
@synthesize meta = _meta;
@synthesize addressOne = _addressOne;
@synthesize state = _state;


+ (TWPShipping *)modelObjectWithDictionary:(NSDictionary *)dict
{
    TWPShipping *instance = [[TWPShipping alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.city = [self objectOrNilForKey:kTWPShippingCity fromDictionary:dict];
            self.postalCode = [self objectOrNilForKey:kTWPShippingPostalCode fromDictionary:dict];
            self.code = [self objectOrNilForKey:kTWPShippingCode fromDictionary:dict];
            self.addressTwo = [self objectOrNilForKey:kTWPShippingAddressTwo fromDictionary:dict];
            self.fullName = [self objectOrNilForKey:kTWPShippingFullName fromDictionary:dict];
            self.meta = [self objectOrNilForKey:kTWPShippingMeta fromDictionary:dict];
            self.addressOne = [self objectOrNilForKey:kTWPShippingAddressOne fromDictionary:dict];
            self.state = [self objectOrNilForKey:kTWPShippingState fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.city forKey:kTWPShippingCity];
    [mutableDict setValue:self.postalCode forKey:kTWPShippingPostalCode];
    [mutableDict setValue:self.code forKey:kTWPShippingCode];
    [mutableDict setValue:self.addressTwo forKey:kTWPShippingAddressTwo];
    [mutableDict setValue:self.fullName forKey:kTWPShippingFullName];
    [mutableDict setValue:self.meta forKey:kTWPShippingMeta];
    [mutableDict setValue:self.addressOne forKey:kTWPShippingAddressOne];
    [mutableDict setValue:self.state forKey:kTWPShippingState];

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

    self.city = [aDecoder decodeObjectForKey:kTWPShippingCity];
    self.postalCode = [aDecoder decodeObjectForKey:kTWPShippingPostalCode];
    self.code = [aDecoder decodeObjectForKey:kTWPShippingCode];
    self.addressTwo = [aDecoder decodeObjectForKey:kTWPShippingAddressTwo];
    self.fullName = [aDecoder decodeObjectForKey:kTWPShippingFullName];
    self.meta = [aDecoder decodeObjectForKey:kTWPShippingMeta];
    self.addressOne = [aDecoder decodeObjectForKey:kTWPShippingAddressOne];
    self.state = [aDecoder decodeObjectForKey:kTWPShippingState];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_city forKey:kTWPShippingCity];
    [aCoder encodeObject:_postalCode forKey:kTWPShippingPostalCode];
    [aCoder encodeObject:_code forKey:kTWPShippingCode];
    [aCoder encodeObject:_addressTwo forKey:kTWPShippingAddressTwo];
    [aCoder encodeObject:_fullName forKey:kTWPShippingFullName];
    [aCoder encodeObject:_meta forKey:kTWPShippingMeta];
    [aCoder encodeObject:_addressOne forKey:kTWPShippingAddressOne];
    [aCoder encodeObject:_state forKey:kTWPShippingState];
}
-(void)saveShippingDict{
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archiveData forKey:@"currentShipment"];
    [defaults synchronize];
}
+(TWPShipping*)getStoredShippingDict{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedObject = [defaults objectForKey:@"currentShipment"];
    if (archivedObject == nil) {
        return nil;
    }
    TWPShipping *obj = (TWPShipping *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
    return obj;
}


@end
