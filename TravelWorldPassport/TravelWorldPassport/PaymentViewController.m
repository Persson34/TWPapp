//
//  PaymentViewController.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/24/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//
/*
 beta.test.travelworldpassport.com/app_dev.php/nl/app/usecc
 input:
 amount
 payment_method_code
 output:
 ok/error
 200/400
 response - response from breintree
 */

#import <ARAnalytics/ARAnalytics.h>
#import "PaymentViewController.h"
#import "TWPEngine.h"
#import "DataModels.h"
#import "MBProgressHUD.h"

#define STAMP_COST 0.5 // 50 cents per stamp

@interface PaymentViewController ()<BTPaymentFormViewDelegate,UITextFieldDelegate,VTClientDelegate,UIAlertViewDelegate>{
    
    
    __weak IBOutlet UITextField *postalCodeLabel;
    __weak IBOutlet UITextField *stateLabel;
    __weak IBOutlet UITextField *cityLabel;
    __weak IBOutlet UITextField *address2Label;
    __weak IBOutlet UITextField *address1Label;
    __weak IBOutlet UIScrollView *bgScrollView;
    __weak IBOutlet UILabel *payLabel;
    __weak IBOutlet UIButton *payBtn;
    
    TWPShipping *currentShipping;
}
- (IBAction)goBackTapped:(id)sender;
- (IBAction)payTapped:(id)sender;

@end

@implementation PaymentViewController

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
    [ARAnalytics pageView:@"Payment View"];

    //  aPaymentForm.frame = CGRectMake(0, 0, 320, 40);
    self.navigationItem.title = @"Purchase";
    payLabel.font = [UIFont fontWithName:@"LucidaGrande" size:19.0f];
    payBtn.enabled = NO;
    [bgScrollView setContentSize:CGSizeMake(320, 700)];
    self.aPaymentForm = [BTPaymentFormView paymentFormView];
    self.aPaymentForm.delegate = self;
    self.aPaymentForm.requestsZip =NO;//self.requestsZipInManualCardEntry;
    self.aPaymentForm.backgroundColor = [UIColor clearColor];
    self.aPaymentForm.UKSupportEnabled = YES;//self.UKSupportEnabled;
    [bgScrollView addSubview:self.aPaymentForm];
    [self.aPaymentForm setOrigin:CGPointMake(10, 105)];
    
    [self.aPaymentForm.cardNumberTextField becomeFirstResponder];
   
    // Configure a tool bar for postalcode since its number input
    UIToolbar *aToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem *toolBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"LucidaGrande" size:14.0]} forState:UIControlStateNormal];
    [aToolBar setTintColor:[UIColor grayColor]];
    [aToolBar setItems:@[flexSpace, toolBarItem]];
    postalCodeLabel.inputAccessoryView = aToolBar;
    payLabel.text = [NSString stringWithFormat:@"PAY $%0.2f",[self.stampsToOrder count]*0.5f];
    [VTClient sharedVTClient].delegate = self;
    
    self.aPaymentForm.cardNumberTextField.inputAccessoryView = aToolBar;
    self.aPaymentForm.monthYearTextField.inputAccessoryView = aToolBar;
//    self.aPaymentForm.zipTextField.inputAccessoryView  = aToolBar;
    // Get user shipping address
    // Get the user address from the site.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if([TWPShipping getStoredShippingDict]==nil){
        // Call , get and store the shipping address
        [[TWPEngine sharedEngine]getUserAddress:[NSString stringWithFormat:@"%d",(int)self.currentUser.userId] onCompletion:^(NSData *responseString, NSError *theError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
                currentShipping = [TWPShipping modelObjectWithDictionary:respDict];
                [currentShipping saveShippingDict];
                [self configureAddressElements];
            });
        }];
    }
    else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        currentShipping = [TWPShipping getStoredShippingDict];
        [self configureAddressElements];
    }
    
//    
//    
//    [[TWPEngine sharedEngine]getUserAddress:[NSString stringWithFormat:@"%d",(int)self.currentUser.userId]  onCompletion:^(NSData *responseString, NSError *theError) {
//        if (theError) {
//            NSLog(@"Error getting the data");
//        }
//        else{
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
//                currentShipping = [TWPShipping modelObjectWithDictionary:respDict];
//                [self configureAddressElements];
//            });
//            
//        }
//    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
   // Log all stamp ids
 
    
}
-(void)configureAddressElements{
    address1Label.text = currentShipping.addressOne;
    address2Label.text = currentShipping.addressTwo;
    cityLabel.text = currentShipping.city;
    stateLabel.text = currentShipping.state;
    postalCodeLabel.text = currentShipping.postalCode;
}
#pragma mark - Payment Form delegate methods
- (void)paymentFormView:(BTPaymentFormView *)paymentFormView didModifyCardInformationWithValidity:(BOOL)isValid{
    if (isValid) {
        NSLog(@"Entered valid credit card info");
        [paymentFormView.zipTextField resignFirstResponder];
        postalCodeLabel.text = paymentFormView.zipTextField.text;
        [address1Label becomeFirstResponder];
        
    }
    payBtn.enabled = isValid;
}

#pragma mark -UITextField Delegate methods

-(void)doneTapped{
    [postalCodeLabel resignFirstResponder];
    [self.aPaymentForm.cardNumberTextField resignFirstResponder];
    [self.aPaymentForm.monthYearTextField resignFirstResponder];
    [self.aPaymentForm.zipTextField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == cityLabel || textField == stateLabel|| textField== address2Label) {
         // Shift the scroll view a little up
        [bgScrollView setContentOffset:CGPointMake(0, 95)];
    }
    if (textField == postalCodeLabel) {
        // Shift another level up
         [bgScrollView setContentOffset:CGPointMake(0, 200)];// Keyboard and tool bar also
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == cityLabel || textField == stateLabel || textField == postalCodeLabel) {
        [bgScrollView setContentOffset:CGPointMake(0, 0)];
    }
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Methods

- (IBAction)goBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)payTapped:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // This is where the action goes.
    NSDictionary *cardInfo = [self.aPaymentForm cardEntry];
    NSDictionary *cardInfoEncrypted;
   cardInfoEncrypted =  [[VTClient sharedVTClient]encryptedCardDataAndVenmoSDKSessionWithCardDictionary:cardInfo];
    // amount
    // payment_method_code
    NSString *amount = [NSString stringWithFormat:@"%0.1f",[self.stampsToOrder count]*STAMP_COST];
    NSDictionary *params = @{@"amount":amount,@"payment_method_code":cardInfoEncrypted};
    [cardInfoEncrypted setValue:amount forKey:@"amount"];
    [[TWPEngine sharedEngine]savePaymentInformation:cardInfoEncrypted onCompletion:^(NSData *responseString, NSError *theError) {
        NSString *resp = [[NSString alloc]initWithData:responseString encoding:NSUTF8StringEncoding];
        NSLog(@"Response is %@",resp);
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
        if ([[[responseDict objectForKey:@"response"]objectForKey:@"success"]isEqualToNumber:@1]) {
            NSLog(@"Transaction was successful");
          
            [self sendAndPlaceOrder];
        }
    }];
    
}

-(void)sendAndPlaceOrder{

//     beat.test.travelworldpassport.com/app_dev.php/nl/app/placeorder
    // userid
    // stamps (ids array)
    NSArray *stamIdArray=  [self.stampsToOrder valueForKeyPath:@"stampId"];
    
    NSString *stampIdString = [stamIdArray componentsJoinedByString:@","];
    NSDictionary *params = @{@"userid":@(self.currentUser.userId),@"stamps":stampIdString };
    // Now send it back to the server
    [[TWPEngine sharedEngine]placeAndSaveOrder:params onCompletion:^(NSData *responseString, NSError *theError) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
        if ([[respDict objectForKey:@"meta"]isEqualToString:@"OK"]) {
            UIAlertView *anAlert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your order has been placed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [anAlert show];
            
        }
        else{
            UIAlertView *anAlert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Something went wrong with your order." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [anAlert show];
        }
//        NSString *resp = [[NSString alloc]initWithData:responseString encoding:NSUTF8StringEncoding];
       
    }];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSArray *vcArray = [self.navigationController viewControllers];
    
    [self.navigationController popToViewController:[vcArray objectAtIndex:1] animated:YES];
}


- (void)client:(VTClient *)client approvedPaymentMethodWithCode:(NSString *)paymentMethodCode {
    NSLog(@"Payment code %@",paymentMethodCode);
}
@end
