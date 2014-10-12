//
//  TWPLoginViewController.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 2/4/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "TWPLoginViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "TWPEngine.h"
#import "TWPUser.h"
#import "ADDeviceUtil.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "MFSideMenuContainerViewController.h"


@interface TWPLoginViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UILabel *signInLabel;
    __weak IBOutlet UIView *loginView;
    __weak IBOutlet UITextField *unameField;
    __weak IBOutlet UITextField *pwdField;
    Reachability *internetReachable;
}

- (IBAction)fogotPwdBtnTapped:(id)sender;
- (IBAction)loginBtnTapped:(id)sender;
- (IBAction)loginWithFbBtnTapped:(id)sender;

@end

@implementation TWPLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"";

    loginView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:loginView];
    loginView.alpha = 0.0f;
    // Do any additional setup after loading the view from its nib.
    signInLabel.font = [UIFont fontWithName:@"LucidaGrande" size:14.0f];
    unameField.font =[UIFont fontWithName:@"LucidaGrande" size:14.0f];
    pwdField.font = [UIFont fontWithName:@"LucidaGrande" size:14.0f];
    registerBtn.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:14.0f];
    forgotPwdBtn.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:14.0f];
    MFSideMenuContainerViewController* menuContainerViewController=[UIApplication sharedApplication].keyWindow.rootViewController;
    menuContainerViewController.panMode=MFSideMenuPanModeNone;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
}

- (IBAction)registerBtnTapped:(id)sender {
    RegisterViewController *aRegistration = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:aRegistration animated:YES];
    
}

- (IBAction)signInBtnTapped:(id)sender {
    NSLayoutConstraint *centerX=[NSLayoutConstraint constraintWithItem:loginView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *centerY=[NSLayoutConstraint constraintWithItem:loginView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *widths=[NSLayoutConstraint constraintWithItem:loginView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *heights=[NSLayoutConstraint constraintWithItem:loginView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [self.view  addConstraints:@[centerY,centerX,widths,heights]];
    [UIView animateWithDuration:0.3 animations:^{
        loginView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)fogotPwdBtnTapped:(id)sender {
    
}

-(void)sendLoginWithFBRequest{
    // Have to get the basic information for the
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            // Get the facebook id
            NSDictionary *resultDict = (NSDictionary*)result;
//            NSLog(@"user info: %@", resultDict[@"id"]);
            [[TWPEngine sharedEngine]loginWithFBID:resultDict[@"id"] onCompletion:^(NSData *responseString, NSError *theError) {
//                NSString *loginResponse = [[NSString alloc]initWithData:responseString encoding:NSUTF8StringEncoding];
//                NSLog(@"Login Response is %@",loginResponse);
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
                if ([responseDictionary[@"code"]isEqualToString:@"400"]) {
                    NSLog(@"Login failed");
                    UIAlertView *loginFailed =[[UIAlertView alloc]initWithTitle:@"Error" message:@"You are not registered with your facebook id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [loginFailed show];
                }
                else{
                    NSLog(@"Logged in properly");
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
                    TWPUser *theUser = [TWPUser modelObjectWithDictionary:responseDictionary];
                
                    MainViewController *mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
                    mainController.currentUser = theUser;
                    [self.navigationController pushViewController:mainController animated:YES];
                }
                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
         
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

- (IBAction)loginWithFbBtnTapped:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (status == FBSessionStateOpen) {
            NSLog(@"My code here");
            [self sendLoginWithFBRequest];
        }
        else{
            NSLog(@"Something went wrong");
        }
    }];
    // Open session with basic_info (required) and user_birthday read permissions
//    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
//                                       allowLoginUI:YES
//                                  completionHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         __block NSString *alertText;
//         __block NSString *alertTitle;
//         if (!error){
//             // If the session was opened successfully
//             if (state == FBSessionStateOpen){
//                 // Your code here
//                 
//             } else {
//                 // There was an error, handle it
//                 if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
//                     // Error requires people using an app to make an action outside of the app to recover
//                     // The SDK will provide an error message that we have to show the user
////                     alertTitle = @"Something went wrong";
////                     alertText = [FBErrorUtility userMessageForError:error];
////                     [[[UIAlertView alloc] initWithTitle:title
////                                                 message:text
////                                                delegate:self
////                                       cancelButtonTitle:@"OK!"
////                                       otherButtonTitles:nil] show];
//                     
//                 } else {
//                     // If the user cancelled login
//                     if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
////                         alertTitle = @"Login cancelled";
////                         alertText = @"Your birthday will not be entered in our calendar because you didn't grant the permission.";
////                         [[[UIAlertView alloc] initWithTitle:title
////                                                     message:text
////                                                    delegate:self
////                                           cancelButtonTitle:@"OK!"
////                                           otherButtonTitles:nil] show];
//                     
//                     } else {
//                         // For simplicity, in this sample, for all other errors we show a generic message
//                         // You can read more about how to handle other errors in our Handling errors guide
//                         // https://developers.facebook.com/docs/ios/errors/
////                         NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]
////                                                            objectForKey:@"body"]
////                                                           objectForKey:@"error"];
////                         alertTitle = @"Something went wrong";
////                         alertText = [NSString stringWithFormat:@"Please retry. \n
////                                      If the problem persists contact us and mention this error code: %@", 
////                                      [errorInformation objectForKey:@"message"]];
////                         [[[UIAlertView alloc] initWithTitle:title
////                                                     message:text
////                                                    delegate:self
////                                           cancelButtonTitle:@"OK!"
////                                           otherButtonTitles:nil] show];
//                     }
//                 }
//             }
//             
//         }];
}

- (IBAction)loginBtnTapped:(id)sender {
    if (![self validateFields]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information" message:@"Please fill the details correctly." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    //login
    internetReachable = [Reachability reachabilityForInternetConnection];
    if ([internetReachable isReachable]) {
        [self makeLoginCall];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)makeLoginCall {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [unameField resignFirstResponder];
    [pwdField resignFirstResponder];
    [[TWPEngine sharedEngine] loginWithUserName:unameField.text andPassword:pwdField.text onCompletion:^(NSData *responseData, NSError *theError) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (theError || responseData == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            return;
        }
//        NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",responseString);
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Response dictionary %@",responseDictionary);
        TWPUser *theUser = [TWPUser modelObjectWithDictionary:responseDictionary];
//        [TWPShipping getStoredShippingDict];
      //  NSLog(@"Shipping %@",[TWPShipping getStoredShippingDict]);
        if([TWPShipping getStoredShippingDict]==nil){
            // Call , get and store the shipping address
            [[TWPEngine sharedEngine]getUserAddress:[NSString stringWithFormat:@"%d",(int)theUser.userId] onCompletion:^(NSData *responseString, NSError *theError) {
                NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
                TWPShipping *currentShipping = [TWPShipping modelObjectWithDictionary:respDict];
                [currentShipping saveShippingDict];
            }];
        }
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];//)
        appDelegate.loggedUser = theUser;
        [appDelegate showHome];
    }];
}

- (BOOL)validateFields {
    if ([unameField.text length] <= 0 || [pwdField.text length] <= 0) {
        return NO;
    }
    return YES;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == pwdField) {
        if (![ADDeviceUtil isIPhone5]) {
            // Need to raise the login view.
            loginView.frame = CGRectMake(loginView.frame.origin.x, loginView.frame.origin.y+40, loginView.frame.size.width, loginView.frame.size.height);
        }
    }
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == pwdField) {
        if (![ADDeviceUtil isIPhone5]) {
            // Need to raise the login view.
            loginView.frame = CGRectMake(loginView.frame.origin.x, loginView.frame.origin.y-40, loginView.frame.size.width, loginView.frame.size.height);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
