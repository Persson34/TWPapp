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

@interface TWPLoginViewController ()
{
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
    [self.view addSubview:loginView];
    loginView.alpha = 0.0f;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)registerBtnTapped:(id)sender {
    
}

- (IBAction)signInBtnTapped:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        loginView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)fogotPwdBtnTapped:(id)sender {
    
}

- (IBAction)loginWithFbBtnTapped:(id)sender {
    
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
    [[TWPEngine sharedEngine] loginWithUserName:unameField.text andPassword:pwdField.text onCompletion:^(NSString *responseData, NSError *theError) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responseData);
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",responseDict);
        MainViewController *mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:mainController animated:YES];
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
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
