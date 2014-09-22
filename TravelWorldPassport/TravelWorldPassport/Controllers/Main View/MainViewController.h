//
//  MainViewController.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 3/11/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModels.h"

@interface MainViewController : UIViewController
{
    
}
@property (nonatomic,strong)TWPUser *currentUser;
- (void)editProfile;
@end
