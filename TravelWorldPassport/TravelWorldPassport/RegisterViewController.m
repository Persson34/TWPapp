//
//  RegisterViewController.m
//  TravelWorldPassport
//
//  Created by Naresh Kumar on 5/5/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "RegisterViewController.h"
#import "ADDeviceUtil.h"
#import "TWPEngine.h"
#import "MBProgressHud.h"
#import "UIViewController+MFSideMenuAdditions.h"
#import "MFSideMenuContainerViewController.h"


@interface RegisterViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    
    __weak IBOutlet UIScrollView *bgScrollView;
    __weak IBOutlet UITextField *repeatPwdField;
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UITextField *mailField;
    __weak IBOutlet UITextField *surnameField;
    __weak IBOutlet UITextField *nameField;
}
- (IBAction)saveTapped:(id)sender;

@end

@implementation RegisterViewController

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
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBarHidden = NO;
    
     self.navigationItem.title = @"REGISTER";
    //Careful about this in iOS 6
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor ],NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:19.0f]}];
    [self.view removeGestureRecognizer:self.menuContainerViewController.panGestureRecognizer];
    bgScrollView.contentSize = CGSizeMake(320.0f, 580.0f);
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
     // Need to improve the scroll view.
    if (textField == passwordField || textField == repeatPwdField) {
        // Scroll view to get bigger
        [bgScrollView setContentOffset:CGPointMake(0, 220) animated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == passwordField || textField == repeatPwdField) {
        // Scroll view to get bigger
        [bgScrollView setContentOffset:CGPointMake(0, -30) animated:YES];
    }
    return YES;
}
- (IBAction)saveTapped:(id)sender {
    // Validate the form
    if([nameField.text isEqualToString:@""]){
        [self alertMessage:@"Please enter Name!" andMakeFirst:nameField];
        return;
    }
    if ([surnameField.text isEqualToString:@""]) {
        [self alertMessage:@"Please enter Surname" andMakeFirst:surnameField];
        return;
    }
    if ([mailField.text isEqualToString:@""]) {
        [self alertMessage:@"Please enter Email" andMakeFirst:mailField];
        return;
    }
    if ([self validateEmail:mailField.text] == NO) {
        [self alertMessage:@"Please enter valid email id" andMakeFirst:mailField];
        return;
    }
    
    if (![passwordField.text isEqualToString:repeatPwdField.text]) {
        [self alertMessage:@"Passwords not matching" andMakeFirst:passwordField];
        return;
    }
    if ([passwordField.text isEqualToString:@""] && [repeatPwdField.text isEqualToString:@""]) {
        [self alertMessage:@"Please enter password" andMakeFirst:passwordField];
        return;
    }
    // Email validation
    
    // Comes here after all validations.
    // Prepare the dictionary
    //email, pwd, name, lastname
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *userDictionary = @{@"email":mailField.text,@"pwd":passwordField.text,@"name":surnameField.text,@"lastname":nameField.text};
    [[TWPEngine sharedEngine]registerUser:userDictionary onCompletion:^(NSData *responseString, NSError *theError) {
        NSString *response = [[NSString alloc]initWithData:responseString encoding:NSUTF8StringEncoding];
        NSLog(@"Response from server %@",response);
         dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSDictionary *resultDict  = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
             if ([resultDict[@"meta"] isEqualToString:@"OK"]) {
                 UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"You are registered successfully. Please login again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [successAlert show];
             }
             
         });
        
    }];
   
    
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(void)alertMessage:(NSString *)message andMakeFirst:(UITextField*)theField{
    UIAlertView *anAlert = [[UIAlertView alloc]initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [anAlert show];
    [theField becomeFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}


@end