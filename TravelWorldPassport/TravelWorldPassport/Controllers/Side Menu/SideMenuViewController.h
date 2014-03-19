//
//  SideMenuViewController.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 3/11/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TWPUser;
@interface SideMenuViewController : UIViewController
-(void)configureForUser:(TWPUser*)theUser;

@end
