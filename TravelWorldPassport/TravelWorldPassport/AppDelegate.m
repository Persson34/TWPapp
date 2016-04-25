//
//  AppDelegate.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 2/4/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "AppDelegate.h"
#import "TWPLoginViewController.h"
#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "ImageDownloadEngine.h"
#import "TWPEngine.h"
#import "DataModels.h"
#import "MainViewController.h"
#import "ARAnalytics.h"
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <Stripe/Stripe.h>

static NSString* const kUserProfileKey=@"kUserProfileKey";
static NSString* const kStripeDeveloperTestKey=@"pk_test_Winqv9mEOSROfFdbHxwPts1K";
static NSString* const kStripeTestKey=@"pk_test_YkQiDre7NJuGQFjIG6g9OkgX";
static NSString* const kStripeLiveKey=@"pk_live_lAC0ZBRgQkahLq6qZloahz5w";

@interface AppDelegate()
{

}
@property (strong, nonatomic) SideMenuViewController *leftSideMenuController;
@property (strong, nonatomic) MFSideMenuContainerViewController* rootController;
@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    TWPLoginViewController *loginController = [[TWPLoginViewController alloc] initWithNibName:@"TWPLoginViewController" bundle:nil];
     navController= [[UINavigationController alloc] initWithRootViewController:loginController];
    navController.navigationBarHidden = YES;
    _leftSideMenuController = [[SideMenuViewController alloc] initWithNibName:@"SideMenuViewController" bundle:nil];
    self.rootController= [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navController
                                                    leftMenuViewController:_leftSideMenuController
                                                    rightMenuViewController:nil];

    self.rootController.panMode=MFSideMenuPanModeNone;
    self.window.rootViewController = self.rootController;
    self.window.backgroundColor = [UIColor whiteColor];


    [self.window makeKeyAndVisible];

    NSData* userData=[[NSUserDefaults standardUserDefaults] objectForKey:kUserProfileKey];
    if(userData)
    {
        TWPUser *user=[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if(user)
        {
            self.loggedUser=user;
            [self showHome];
        }
    }
    [UIImageView setDefaultEngine:[ImageDownloadEngine sharedEngine]];
    //[self addDummyAddress];
//    [self initVTClient];
//    [self printAllFonts];
//    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    // Facebook thing
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
//                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    [ARAnalytics setupGoogleAnalyticsWithID:@"UA-34990766-3"];
    
    [Crashlytics startWithAPIKey:@"c5af9152500a53488ccbf8f3dadd2ed418c66d28"];
    
    [Stripe setDefaultPublishableKey:kStripeLiveKey];
    
    [Fabric with:@[[STPAPIClient class]]];
    
    [TWPEngine sharedEngine];
    
    return YES;
}

- (void)setLoggedUser:(TWPUser *)loggedUser {
    _loggedUser = loggedUser;
    [self serializeLoggedUser];
}

-(void)showHome
{
    MainViewController *mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    mainController.currentUser = self.loggedUser;
    navController=[[UINavigationController alloc] initWithRootViewController:mainController];
    self.rootController.centerViewController=navController;
    navController.navigationBarHidden = YES;
    self.rootController.panMode=MFSideMenuPanModeDefault;
    self.leftSideMenuController.delegate=mainController;
}

-(void)showLogin
{
    TWPLoginViewController *loginController = [[TWPLoginViewController alloc] initWithNibName:@"TWPLoginViewController" bundle:nil];
    navController= [[UINavigationController alloc] initWithRootViewController:loginController];
    navController.navigationBarHidden = YES;
    self.rootController.menuState=MFSideMenuStateClosed;
    self.rootController.centerViewController=navController;
    self.rootController.panMode=MFSideMenuPanModeNone;
}

- (void)logOut {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserProfileKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self showLogin];
}

/*
- (void)initVTClient {
    if ([BT_ENVIRONMENT isEqualToString:@"sandbox"]) {
        NSLog(@"sandbox environment, merchant_id %@", BT_SANDBOX_MERCHANT_ID);
        [VTClient
         startWithMerchantID:BT_SANDBOX_MERCHANT_ID
         customerEmail:nil
         braintreeClientSideEncryptionKey:BT_SANDBOX_CLIENT_SIDE_ENCRYPTION_KEY
         environment:VTEnvironmentSandbox];
    } else {
        NSLog(@"production environment, merchant_id %@", BT_PRODUCTION_MERCHANT_ID);
        [VTClient
         startWithMerchantID:BT_PRODUCTION_MERCHANT_ID
         customerEmail:nil
         braintreeClientSideEncryptionKey:BT_PRODUCTION_CLIENT_SIDE_ENCRYPTION_KEY
         environment:VTEnvironmentSandbox];
    }
}
 */

#pragma mark - PrintFonts
-(void)printAllFonts{
        for (NSString* family in [UIFont familyNames])
            {
                 NSLog(@"%@", family);
        
                for (NSString* name in [UIFont fontNamesForFamilyName: family])
                 {
                        NSLog(@"  %@", name);
                   }
             }

}

-(void)addDummyAddress{
    NSDictionary *params = @{
                             @"userid":@5,
                             @"fullName":@"Naresh Kumar",
                             @"addressOne":@"No.27, 18th Main, 3rd B cross",
                             @"addressTwo":@"BTM 2nd Stage",
                             @"city":@"Bangalore",
                             @"state":@"Karnataka",
                             @"postalCode":@656767
                             };
    [[TWPEngine sharedEngine]updateShippingAddress:params onCompletion:^(NSData *responseString, NSError *theError) {
        NSLog(@"Update address finished");
        NSString *resp = [[NSString alloc]initWithData:responseString encoding:NSUTF8StringEncoding];
        NSLog(@"Response from server %@",resp);
    }];
}

#pragma mark - Facebook utility
// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
       // [self userLoggedIn];
        TWPLoginViewController *topController =(TWPLoginViewController*) [navController topViewController];
        [topController sendLoginWithFBRequest];
      //  NSLog(@"top class %@",[topController class] );
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
       // [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
           // [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
            //    [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
             //   [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
      // [self userLoggedOut];
    }
}

#pragma mark - AppDelegate Life cycle
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Note this handler block should be the exact same as the handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self serializeLoggedUser];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)serializeLoggedUser {
    NSData* userData= [NSKeyedArchiver archivedDataWithRootObject:self.loggedUser];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:kUserProfileKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setStatusBarHidden:YES];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
