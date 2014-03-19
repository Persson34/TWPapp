//
//  TWPEngine.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 3/12/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
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
    MKNetworkOperation *op = [self operationWithURLString:@"http://test.travelworldpassport.com/nl/app/login" params:paramDict httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        theResponse([completedOperation responseData],nil);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        theResponse(nil,error);
    }];
    
    [self enqueueOperation:op];
}
@end
