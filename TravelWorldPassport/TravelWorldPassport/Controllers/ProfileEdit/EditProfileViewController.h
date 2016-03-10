//
//  EditProfileViewController.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/7/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class TWPUser;
@interface EditProfileViewController : UIViewController <CLLocationManagerDelegate>
{
    
}
@property (nonatomic,strong)void (^onUserUpdate)(TWPUser *updatedUser);
@property (strong, nonatomic) CLLocation *userLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) TWPUser *theUser;
@property (strong, nonatomic) NSArray *selectedStamps;
@end
