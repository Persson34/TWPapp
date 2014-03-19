//
//  ImageDownloadEngine.h
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/18/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//
// This engine is created separately for images download. This will handle the image requests independently.

#import "MKNetworkEngine.h"

@interface ImageDownloadEngine : MKNetworkEngine
+ (ImageDownloadEngine *)sharedEngine;
@end
