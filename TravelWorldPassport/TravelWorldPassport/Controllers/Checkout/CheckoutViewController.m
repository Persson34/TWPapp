//
//  CheckoutViewController.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/22/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <ARAnalytics/ARAnalytics.h>
#import "CheckoutViewController.h"
#import "StampCell.h"
#import "PaymentViewController.h"

@interface CheckoutViewController ()
{
    __weak IBOutlet UIButton *checkoutBtn;
    __weak IBOutlet UICollectionView *stampsCollectionView;
    __weak IBOutlet UILabel *staticLbl;
    NSMutableArray *selectedArr;
    int selectedImgCount;
}
- (IBAction)checkoutBtnTapped:(id)sender;
- (IBAction)backBtnTapped:(id)sender;
@end

@implementation CheckoutViewController
@synthesize selectedStampNo,currentUser;

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
    [ARAnalytics pageView:@"Checkout View"];

    selectedImgCount = 1;
    staticLbl.font = [UIFont fontWithName:@"Avenir-Roman" size:14.0f];
    [stampsCollectionView registerNib:[UINib nibWithNibName:@"StampCell" bundle:nil] forCellWithReuseIdentifier:@"StampCell"];
    stampsCollectionView.allowsMultipleSelection = YES;
    
    selectedArr = [[NSMutableArray alloc] initWithCapacity:currentUser.stamps.count];
    for (int i = 0; i < currentUser.stamps.count; i++)
    {
        if (i == selectedStampNo)
        {
            [selectedArr addObject:@YES];
        }
        else
        {
            [selectedArr addObject:@NO];
        }
    }
    
    checkoutBtn.alpha = 0.6;
}

- (IBAction)checkoutBtnTapped:(id)sender {
    if (selectedImgCount < 12){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please select 12 stamps before proceeding" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    PaymentViewController *aPaymentController = [[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
    
    // Get the stamps out
    NSMutableArray *stampsToOrder = [@[]mutableCopy];
    
    for (int i = 0; i < [selectedArr count]; i++)
    {
        NSNumber *selected = (NSNumber *)selectedArr[i];
        if ([selected boolValue] == YES)
        {
            Stamps *aStamp = [self.currentUser.stamps objectAtIndex:i];
            [stampsToOrder addObject:aStamp];
        }
    }

    UINavigationController *paymentNavigationController = [[UINavigationController alloc] initWithRootViewController:aPaymentController];
    aPaymentController.currentUser = self.currentUser;
    aPaymentController.stampsToOrder = stampsToOrder;
    [self.navigationController pushViewController:aPaymentController animated:YES];
    
    //[self presentViewController:paymentNavigationController animated:YES completion:nil];

//    self.paymentViewController = [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:YES];
//    
//    self.paymentViewController.checkboxView.hidden = NO;
//    self.paymentViewController.delegate = self;
//
//    // Add paymentViewController to a navigation controller.
//    UINavigationController *paymentNavigationController =
//    [[UINavigationController alloc] initWithRootViewController:self.paymentViewController];
//
//    // Add the cancel button
//    self.paymentViewController.navigationItem.leftBarButtonItem =
//    [[UIBarButtonItem alloc]
//     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:paymentNavigationController
//     action:@selector(dismissModalViewControllerAnimated:)];
//
//    [self presentViewController:paymentNavigationController animated:YES completion:^{
//    }];
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.currentUser.stamps count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StampCell *cell =(StampCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"StampCell" forIndexPath:indexPath];
   
    [self configureCell:cell forItemAtIndexPath:indexPath];
    
    if (indexPath.row == selectedStampNo)
    {
        [cell setSelected:YES];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected = [[selectedArr objectAtIndex:indexPath.row] boolValue];
    
    if (isSelected == NO)
    {
        selectedImgCount++;
    }
    else
    {
        selectedImgCount--;
    }
    
    if (selectedImgCount >= 12)
    {
        [checkoutBtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
        checkoutBtn.alpha = 1.0;
    }
    else
    {
        [checkoutBtn setBackgroundImage:[UIImage imageNamed:@"checkout-disable.png"] forState:UIControlStateNormal];
        checkoutBtn.alpha = 0.6;
    }
    
    [selectedArr replaceObjectAtIndex:indexPath.row withObject:@(!isSelected)];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected = [[selectedArr objectAtIndex:indexPath.row] boolValue];
    
    if (isSelected == NO)
    {
        selectedImgCount++;
    }
    else
    {
        selectedImgCount--;
    }
    
    if (selectedImgCount >= 12)
    {
        [checkoutBtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
        checkoutBtn.alpha = 1.0;
    }
    else
    {
        [checkoutBtn setBackgroundImage:[UIImage imageNamed:@"checkout-disable.png"] forState:UIControlStateNormal];
        checkoutBtn.alpha = 0.6;
    }
    
    [selectedArr replaceObjectAtIndex:indexPath.row withObject:@(!isSelected)];
}

- (void)configureCell:(StampCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    Stamps *currentStamp = [self.currentUser.stamps objectAtIndex:indexPath.row];
    // NSLog(@"Stamp details %@",currentStamp);
    [cell configureForStamp:currentStamp];
}

#pragma mark - BTPaymentViewControllerDelegate

#pragma mark - BTPaymentViewControllerDelegate

// When a user types in their credit card information correctly, the BTPaymentViewController sends you
// card details via the `didSubmitCardWithInfo` delegate method.
//
// NB: you receive raw, unencrypted info in the `cardInfo` dictionary, but
// for easy PCI Compliance, you should use the `cardInfoEncrypted` dictionary
// to securely pass data through your servers to the Braintree Gateway.
/*
- (void)paymentViewController:(BTPaymentViewController *)paymentViewController
        didSubmitCardWithInfo:(NSDictionary *)cardInfo
         andCardInfoEncrypted:(NSDictionary *)cardInfoEncrypted {
    NSLog(@"didSubmitCardWithInfo %@ andCardInfoEncrypted %@", cardInfo, cardInfoEncrypted);
    [self saveCardInfoToServer:cardInfoEncrypted];
    
  //  [self savePaymentInfoToServer:cardInfoEncrypted]; // send card through your server to Braintree Gateway
    //       [[VTClient sharedVTClient] refresh];
    //    [self dismissViewControllerAnimated:YES completion:^(void) {
    //        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Saved your card!" delegate:nil
    //                          cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //
    //    }];
}

// When a user adds a saved card from Venmo Touch to your app, the BTPaymentViewController sends you
// a paymentMethodCode that you can pass through your servers to the Braintree Gateway to
// add the full card details to your Vault.

- (void)paymentViewController:(BTPaymentViewController *)paymentViewController
didAuthorizeCardWithPaymentMethodCode:(NSString *)paymentMethodCode {
    NSLog(@"didAuthorizeCardWithPaymentMethodCode %@", paymentMethodCode);
    // Create a dictionary of POST data of the format
    // {"payment_method_code": "[encrypted payment_method_code data from Venmo Touch client]"}
    NSMutableDictionary *paymentInfo = [NSMutableDictionary dictionaryWithObject:paymentMethodCode
                                                                          forKey:@"payment_method_code"];
    [self savePaymentInfoToServer:paymentInfo]; // send card through your server to Braintree Gateway
}
 */

#pragma mark - Networking

// The following example code demonstrates how to pass encrypted card data from the app to your
// server (your server will then have to send it to the Braintree Gateway). For a fully working
// example of how to proxy data through your server to the Braintree Gateway, see:
//    1. the braintree_ios Server Side Integration tutorial [https://touch.venmo.com/server-side-changes/]
//    2. and the sample-checkout-heroku Github project [https://github.com/venmo/sample-checkout-heroku]

#define SAVE_CARD_URL @"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/savecc"//@"http://venmo-sdk-sample-two.herokuapp.com"
#define USE_CARD_BASE_URL @"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/usecc"

//#define STAMP_RATE
//#define SAMPLE_CHECKOUT_BASE_URL @"http://localhost:4567"

// Pass payment info (eg card data) from the client to your server (and then to the Braintree Gateway).
// If card data is valid and added to your Vault, display a success message, and dismiss the BTPaymentViewController.
// If saving to your Vault fails, display an error message to the user via `BTPaymentViewController showErrorWithTitle`
// Saving to your Vault may fail, for example when
// * CVV verification does not pass
// * AVS verification does not pass
// * The card number was a valid Luhn number, but nonexistent or no longer valid

/*
- (void) savePaymentInfoToServer:(NSDictionary *)paymentInfo {
    
    NSURL *url;
    if ([paymentInfo objectForKey:@"payment_method_code"]) {
        url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", USE_CARD_BASE_URL]];
    } else {
        url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", SAVE_CARD_URL]];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // You need a customer id in order to save a card to the Braintree vault.
    // Here, for the sake of example, we set customer_id to device id.
    // In practice, this is probably whatever user_id your app has assigned to this user.
    NSString *customerId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    [paymentInfo setValue:customerId forKey:@"customer_id"];
    
    
    [paymentInfo setValue:@"6" forKey:@"amount"];
    
    request.HTTPBody = [self postDataFromDictionary:paymentInfo];
    request.HTTPMethod = @"POST";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
     {
         NSError *err = nil;
         if (!response && requestError) {
             NSLog(@"requestError: %@", requestError);
             [self.paymentViewController showErrorWithTitle:@"Error" message:@"Unable to reach the network."];
             return;
         }
         NSLog(@"%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
         NSDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&err]objectForKey:@"response"];
         NSLog(@"saveCardToServer: paymentInfo: %@ response: %@, error: %@", paymentInfo, responseDictionary, requestError);
         
         if ([[responseDictionary valueForKey:@"success"] isEqualToNumber:@1]) { // Success!
             // Don't forget to call the cleanup method,
             // `prepareForDismissal`, on your `BTPaymentViewController`
             [self.paymentViewController prepareForDismissal];
             // Now you can dismiss and tell the user everything worked.
             [self dismissViewControllerAnimated:YES completion:^(void) {
                 [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Saved your card!" delegate:nil
                                   cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                 [[VTClient sharedVTClient] refresh];
             }];
             
         } else { // The card did not save correctly, so show the error from server with convenenience method `showErrorWithTitle`
             [self.paymentViewController showErrorWithTitle:@"Error saving your card" message:[self messageStringFromResponse:responseDictionary]];
         }
     }];
}

-(void)saveCardInfoToServer:(NSDictionary*)cardInfo{
    // Get the card information and send it to server.
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", SAVE_CARD_URL]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // You need a customer id in order to save a card to the Braintree vault.
    // Here, for the sake of example, we set customer_id to device id.
    // In practice, this is probably whatever user_id your app has assigned to this user.
    NSString *customerId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    [cardInfo setValue:customerId forKey:@"customer_id"];
    [cardInfo setValue:@"6" forKey:@"amount"];
    
    request.HTTPBody = [self postDataFromDictionary:cardInfo];
    request.HTTPMethod = @"POST";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
     {
         NSError *err = nil;
         if (!response && requestError) {
             NSLog(@"requestError: %@", requestError);
             [self.paymentViewController showErrorWithTitle:@"Error" message:@"Unable to reach the network."];
             return;
         }
         NSLog(@"%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
         NSDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&err]objectForKey:@"response"];
         NSLog(@"saveCardToServer: paymentInfo: %@ response: %@, error: %@", cardInfo, responseDictionary, requestError);
         
         if ([[responseDictionary valueForKey:@"success"] isEqualToNumber:@1]) { // Success!
             // Don't forget to call the cleanup method,
             // `prepareForDismissal`, on your `BTPaymentViewController`
//             [self.paymentViewController prepareForDismissal];
//             // Now you can dismiss and tell the user everything worked.
//             [self dismissViewControllerAnimated:YES completion:^(void) {
//                 [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Saved your card!" delegate:nil
//                                   cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                 [[VTClient sharedVTClient] refresh];
//             }];
             
         } else { // The card did not save correctly, so show the error from server with convenenience method `showErrorWithTitle`
             [self.paymentViewController showErrorWithTitle:@"Error saving your card" message:[self messageStringFromResponse:responseDictionary]];
         }
     }];

}
 */

// Some boiler plate networking code below.

- (NSString *) messageStringFromResponse:(NSDictionary *)responseDictionary {
    return [responseDictionary valueForKey:@"message"];
}

// Construct URL encoded POST data from a dictionary
- (NSData *)postDataFromDictionary:(NSDictionary *)params {
    NSMutableString *data = [NSMutableString string];
    
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        if (value == nil) {
            continue;
        }
        if ([value isKindOfClass:[NSString class]]) {
            value = [self URLEncodedStringFromString:value];
        }
        
        [data appendFormat:@"%@=%@&", [self URLEncodedStringFromString:key], value];
    }
    
    return [data dataUsingEncoding:NSUTF8StringEncoding];
}

// This, from CSKit, is free for use:
// https://github.com/codenauts/CNSKit/blob/master/Classes/Categories/NSString%2BCNSStringAdditions.m
// NSString *encoded = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$&’()*+,;='"), kCFStringEncodingUTF8);

- (NSString *) URLEncodedStringFromString: (NSString *)string {
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[string UTF8String];
    size_t sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
