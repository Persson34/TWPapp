//
//  AppDelegate.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 2/4/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class SideMenuViewController;
@class TWPUser;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *navController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SideMenuViewController *leftSideMenuController;
@property (strong, nonatomic) TWPUser *loggedUser; // This is requred for all round access

@end
