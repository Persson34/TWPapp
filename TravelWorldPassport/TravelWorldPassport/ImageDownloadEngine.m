//
//  ImageDownloadEngine.m
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/18/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "ImageDownloadEngine.h"

@implementation ImageDownloadEngine
+ (ImageDownloadEngine *)sharedEngine
{
    static ImageDownloadEngine * instance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        // --- call to super avoids a deadlock with the above allocWithZone
        instance = [[super allocWithZone:nil] init];
        [instance useCache];
    });
    
    return instance;
}
-(NSString *)cacheDirectoryName{
    static NSString *cacheDirectoryName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"TWPEngineCache"];
         
    });
    
    return cacheDirectoryName;
    
}

@end
