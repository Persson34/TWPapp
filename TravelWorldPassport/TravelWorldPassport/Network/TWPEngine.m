//
//  TWPEngine.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 3/12/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//
 //

#import "TWPEngine.h"

@implementation TWPEngine

+ (TWPEngine *)sharedEngine
{
    static TWPEngine * instance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        // --- call to super avoids a deadlock with the above allocWithZone
        instance = [[super allocWithZone:nil] init];
        [instance useCache];
    });
    
    return instance;
}

-(void)loginWithUserName:(NSString*)userName andPassword:(NSString*)password onCompletion:(TWPResponse)theResponse
{
    NSDictionary *paramDict = @{@"email":userName,@"pwd":password};
    MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/nl/app/login" params:paramDict httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        NSLog(@"Response String %@",[completedOperation responseString]);
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
}

- (void)uploadStamp:(NSString *)userId andImage:(UIImage*)uploadImg onCompletion:(TWPResponse)theResponse{
    NSData *data = UIImagePNGRepresentation(uploadImg);
    NSDictionary *paramDict = @{@"userId": userId};
    MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/nl/app/savestamp" params:paramDict httpMethod:@"POST"];
    [op addData:data forKey:@"imageData" mimeType:@"image/png" fileName:@"upload.png"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
}

- (void)editProfile:(NSString *)userId andName:(NSString *)fName andSurname:(NSString *)sName andImage:(UIImage *)profileImg andCountry:(NSString*)countryStr andCity:(NSString *)cityStr andLat:(float)lat andLong:(float)lng nCompletion:(TWPResponse)theResponse
 {
     NSData *data = UIImagePNGRepresentation(profileImg);
    NSDictionary *paramDict = @{@"userid":userId,@"name":fName,@"surname":sName,@"country":countryStr,@"city":cityStr,@"lat":[NSString stringWithFormat:@"%f",lat],@"long":[NSString stringWithFormat:@"%f",lng]};
         MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/edituser" params:paramDict httpMethod:@"POST"];
     
     [op addData:data forKey:@"picture" mimeType:@"image/png" fileName:@"upload.png"];
      
     [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
         theResponse([completedOperation responseData],nil);
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
         theResponse(nil,error);
     }];
     
     [self enqueueOperation:op];
}

-(void)getUserAddress:(NSString*)userId onCompletion:(TWPResponse)theResponse{
    NSDictionary *paramDict = @{@"userid": userId};
    MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/getshipping" params:paramDict httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
}

-(void)loginWithFBID:(NSString*)fbId onCompletion:(TWPResponse)theResponse{
    NSDictionary *paramDict = @{@"fbid": fbId};
    MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/loginfb" params:paramDict httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
}

-(void)updateShippingAddress:(NSDictionary*)shippingDetails onCompletion:(TWPResponse)theResponse{
    MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/setshipping" params:shippingDetails httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
    
}
-(void)savePaymentInformation:(NSDictionary*)paramDict onCompletion:(TWPResponse)theResponse{
    MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/savecc" params:paramDict httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
}

-(void)placeAndSaveOrder:(NSDictionary*)orderParams onCompletion:(TWPResponse)theResponse{

    MKNetworkOperation *op = [self operationWithURLString:@"http://beat.test.travelworldpassport.com/app_dev.php/nl/app/placeorder" params:orderParams httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
}
-(void)registerUser:(NSDictionary *)userDictionary onCompletion:(TWPResponse)theResponse{
    //
    MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/register" params:userDictionary httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
    
    
}

-(void)deleteStampWithId:(NSString *)stampId onCompletion:(TWPResponse)theResponse{
    NSDictionary *paramDict = @{@"stamp_id":stampId};
    MKNetworkOperation *op = [self operationWithURLString:@"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/deletestamp" params:paramDict httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    [self enqueueOperation:op];
}

@end
