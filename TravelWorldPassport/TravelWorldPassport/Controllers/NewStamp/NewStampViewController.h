//
//  NewStampViewController.h
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/20/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class TWPUser;

@interface NewStampViewController : UIViewController <CLLocationManagerDelegate>
{
    __weak IBOutlet UIScrollView *stampsScroll;
    CLLocation *userLocation;
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) TWPUser *theUser;

- (IBAction)captureImage:(id)sender;
- (IBAction)galleryTapped:(id)sender;

@end
