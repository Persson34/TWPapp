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
@end
