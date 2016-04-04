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
#import <Stripe/Stripe.h>

#define STAMP_COST 0.5 // 50 cents per stamp

@interface PaymentViewController () <UITextFieldDelegate, UIAlertViewDelegate, STPPaymentCardTextFieldDelegate> {
    
    
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

@property(nonatomic) STPPaymentCardTextField *paymentTextField;

- (IBAction)goBackTapped:(id)sender;
- (IBAction)payTapped:(id)sender;

@end

@implementation PaymentViewController

#pragma mark - UIViewController

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
    
    self.paymentTextField = [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(15, 107, CGRectGetWidth(self.view.frame) - 30, 44)];
    _paymentTextField.delegate = self;
    [bgScrollView addSubview:_paymentTextField];
   
    // Configure a tool bar for postalcode since its number input
    UIToolbar *aToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem *toolBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"LucidaGrande" size:14.0]} forState:UIControlStateNormal];
    [aToolBar setTintColor:[UIColor grayColor]];
    [aToolBar setItems:@[flexSpace, toolBarItem]];
    postalCodeLabel.inputAccessoryView = aToolBar;
    payLabel.text = [NSString stringWithFormat:@"PAY $%0.2f",[self.stampsToOrder count]*0.5f];
//    [VTClient sharedVTClient].delegate = self;

    // Get user shipping address
    // Get the user address from the site.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([TWPShipping getStoredShippingDict]==nil){
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
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        currentShipping = [TWPShipping getStoredShippingDict];
        [self configureAddressElements];
    }
    
    [_paymentTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

-(void)configureAddressElements{
    address1Label.text = currentShipping.addressOne;
    address2Label.text = currentShipping.addressTwo;
    cityLabel.text = currentShipping.city;
    stateLabel.text = currentShipping.state;
    postalCodeLabel.text = currentShipping.postalCode;
}

-(void)doneTapped{
    [postalCodeLabel resignFirstResponder];
}

- (IBAction)goBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

/*
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
 */

#pragma mark - UITextFieldDelegate

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

/******************************************************** STRIPE ********************************************************/

#pragma mark - Stripe

- (IBAction)payTapped:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[STPAPIClient sharedClient] createTokenWithCard:_paymentTextField.cardParams completion:^(STPToken *token, NSError *error) {
        if (error)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else
        {
            [self createBackendChargeWithToken:token completion:^(BOOL success) {
                if (success)
                {
                    [self sendAndPlaceOrder];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSLog(@"SUCCESS");
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                }
            }];
         }
     }];
}


- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(BOOL success))completion {
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *urlString = [@"http://testtravelworldpassport.herokuapp.com" stringByAppendingPathComponent:@"charge"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postBody = [NSString stringWithFormat:@"stripeToken=%@&amount=%@", token.tokenId, @1000];
    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                          
                                                          if (!error && httpResponse.statusCode != 200)
                                                          {
                                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                                                              error = [NSError errorWithDomain:StripeDomain
                                                                                          code:STPInvalidRequestError
                                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
                                                          }
                                                          
                                                          if (!error)
                                                          {
                                                              completion(YES);
                                                          }
                                                          else
                                                          {
                                                              completion(NO);
                                                          }
                                                      }];
    
    [uploadTask resume];
}

#pragma mark STPPaymentCardTextFieldDelegate

- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    // Toggle navigation, for example
}

/***********************************************************************************************************************/

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSArray *vcArray = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[vcArray objectAtIndex:1] animated:YES];
}

@end
