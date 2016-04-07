//
//  TWPEngine.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 3/12/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "MKNetworkEngine.h"
typedef void (^TWPResponse)(NSData* responseString,NSError *theError);
@interface TWPEngine : MKNetworkEngine {
    
}

+ (TWPEngine *)sharedEngine;

-(void)loginWithUserName:(NSString*)userName andPassword:(NSString*)password onCompletion:(TWPResponse)theResponse ;
- (void)uploadStamp:(NSString *)userId andImage:(UIImage*)uploadImg onCompletion:(TWPResponse)theResponse;
- (void)editProfile:(NSString *)userId andName:(NSString *)fName andSurname:(NSString *)sName andImage:(UIImage *)profileImg andCountry:(NSString*)countryStr andCity:(NSString *)cityStr andLat:(float)lat andLong:(float)lng nCompletion:(TWPResponse)theResponse;

-(void)loginWithFBID:(NSString*)fbId onCompletion:(TWPResponse)theResponse;

-(void)getUserAddress:(NSString*)userId onCompletion:(TWPResponse)theResponse;

-(void)updateShippingAddress:(NSDictionary*)shippingDetails onCompletion:(TWPResponse)theResponse;

-(void)savePaymentInformation:(NSDictionary*)paramDict onCompletion:(TWPResponse)theResponse;
-(void)createBackendChargeWithParameters:(NSDictionary*)orderParams onCompletion:(TWPResponse)theResponse;
-(void)placeAndSaveOrder:(NSDictionary*)orderParams onCompletion:(TWPResponse)theResponse;
-(void)registerUser:(NSDictionary *)userDictionary picture:(UIImage*)profileImage onCompletion:(TWPResponse)theResponse;
-(void)deleteStampWithId:(NSString *)stampId onCompletion:(TWPResponse)theResponse;
@end
