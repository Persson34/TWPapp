//
//  SingleStampViewController.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/4/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "SingleStampViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CheckoutViewController.h"
#import "DMActivityInstagram.h"
#import "ImageDownloadEngine.h"
#import "KxMenu.h"

@interface SingleStampViewController () <UIDocumentInteractionControllerDelegate>
{
    __weak IBOutlet UIImageView *selectedImgView;
    __weak IBOutlet UIImageView *backImgView;
    __weak IBOutlet UIView *stampView;
    __weak IBOutlet UIButton *sendBtn;
    UIActivityViewController *anActivityController;
    UIImage *imageToShare;
    __weak IBOutlet UIButton *buyBtn;
}
@property (strong , nonatomic) UIDocumentInteractionController *dic;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)sendBtnTapped:(id)sender;
- (IBAction)buyBtnTapped:(id)sender;

@end

@implementation SingleStampViewController
@synthesize selectedImageURL,selectedStampNo,currentUser;

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
    
    [selectedImgView setImageWithURL:[NSURL URLWithString:selectedImageURL]];
    [[ImageDownloadEngine sharedEngine]imageAtURL:[NSURL URLWithString:selectedImageURL] completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        imageToShare = fetchedImage;
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
    // Initiate UIImage download for this.
    buyBtn.titleLabel.font = [UIFont fontWithName:@"LucidaGrande-Bold" size:16.0f];
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendBtnTapped:(id)sender {
    
    DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
    
    //NSString *shareText = @"CatPaint #catpaint";
    //NSURL *shareURL = [NSURL URLWithString:@"http://catpaint.info"];
    
   // NSArray *activityItems = @[self.imageView.image, shareText, shareURL];
    
//    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[instagramActivity]];
//    [self presentViewController:activityController animated:YES completion:nil];
    
    NSString *textToShare = @"Created with the new Travel World Passport app";
    anActivityController = [[UIActivityViewController alloc]initWithActivityItems:@[imageToShare,textToShare] applicationActivities:@[instagramActivity]];
    anActivityController.completionHandler = ^(NSString *activityType, BOOL completed){
    };
    [self presentViewController:anActivityController animated:YES completion:nil];
    // Changed
//    [KxMenu showMenuInView:self.view fromRect:sendBtn.frame menuItems:@[[KxMenuItem menuItem:@"Facebook" image:nil target:self action:@selector(fbBtnTapped:)],[KxMenuItem menuItem:@"Twitter" image:nil target:self action:@selector(twitterBtnTapped:)],[KxMenuItem menuItem:@"Instagram" image:nil target:self action:@selector(instaBtnTapped:)]]];
}

- (IBAction)buyBtnTapped:(id)sender {
    CheckoutViewController *aController = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
    [aController setCurrentUser:currentUser];
    [aController setSelectedStampNo:selectedStampNo];
    [self.navigationController pushViewController:aController animated:YES];
//    self.paymentViewController = [BTPaymentViewController paymentViewControllerWithVenmoTouchEnabled:YES];
//    
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

- (void)fbBtnTapped:(KxMenuItem*)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Check this out!"];
        [controller addImage:selectedImgView.image];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        UIAlertView *fbAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You need to connect to Facebook to share. Go to your phone's Settings and select Facebook. Sign-in and then return to TWP" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [fbAlert show];
    }

}

- (void)twitterBtnTapped:(KxMenuItem*)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Check this out!"];
        [tweetSheet addImage:selectedImgView.image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        UIAlertView *twtrAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You need to connect to Twitter to share. Go to your phone's Settings and select Twitter. Sign-in and then return to TWP" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [twtrAlert show];
    }
}

- (void)instaBtnTapped:(KxMenuItem*)sender {
    [self shareInInstagram];
}

-(void)shareInInstagram
{
    NSData *imageData = UIImagePNGRepresentation(selectedImgView.image); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    
    NSLog(@"image saved");
    
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndImageContext();
    NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
    NSLog(@"jpg path %@",jpgPath);
    NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
    NSLog(@"with File path %@",newJpgPath);
    NSURL *igImageHookFile = [[NSURL alloc] initFileURLWithPath:newJpgPath];
    NSLog(@"url Path %@",igImageHookFile);
    
    self.dic.UTI = @"com.instagram.exclusivegram";
    self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
    self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    [self.dic presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

//#pragma mark - BTPaymentViewControllerDelegate
//
//#pragma mark - BTPaymentViewControllerDelegate
//
//// When a user types in their credit card information correctly, the BTPaymentViewController sends you
//// card details via the `didSubmitCardWithInfo` delegate method.
////
//// NB: you receive raw, unencrypted info in the `cardInfo` dictionary, but
//// for easy PCI Compliance, you should use the `cardInfoEncrypted` dictionary
//// to securely pass data through your servers to the Braintree Gateway.
//- (void)paymentViewController:(BTPaymentViewController *)paymentViewController
//        didSubmitCardWithInfo:(NSDictionary *)cardInfo
//         andCardInfoEncrypted:(NSDictionary *)cardInfoEncrypted {
//    NSLog(@"didSubmitCardWithInfo %@ andCardInfoEncrypted %@", cardInfo, cardInfoEncrypted);
//    [self savePaymentInfoToServer:cardInfoEncrypted]; // send card through your server to Braintree Gateway
////       [[VTClient sharedVTClient] refresh];
////    [self dismissViewControllerAnimated:YES completion:^(void) {
////        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Saved your card!" delegate:nil
////                          cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
////     
////    }];
//}
//
//// When a user adds a saved card from Venmo Touch to your app, the BTPaymentViewController sends you
//// a paymentMethodCode that you can pass through your servers to the Braintree Gateway to
//// add the full card details to your Vault.
//- (void)paymentViewController:(BTPaymentViewController *)paymentViewController
//didAuthorizeCardWithPaymentMethodCode:(NSString *)paymentMethodCode {
//    NSLog(@"didAuthorizeCardWithPaymentMethodCode %@", paymentMethodCode);
//    // Create a dictionary of POST data of the format
//    // {"payment_method_code": "[encrypted payment_method_code data from Venmo Touch client]"}
//    NSMutableDictionary *paymentInfo = [NSMutableDictionary dictionaryWithObject:paymentMethodCode
//                                                                          forKey:@"payment_method_code"];
//    [self savePaymentInfoToServer:paymentInfo]; // send card through your server to Braintree Gateway
//}
//
//#pragma mark - Networking
//
//// The following example code demonstrates how to pass encrypted card data from the app to your
//// server (your server will then have to send it to the Braintree Gateway). For a fully working
//// example of how to proxy data through your server to the Braintree Gateway, see:
////    1. the braintree_ios Server Side Integration tutorial [https://touch.venmo.com/server-side-changes/]
////    2. and the sample-checkout-heroku Github project [https://github.com/venmo/sample-checkout-heroku]
//
//#define SAMPLE_CHECKOUT_BASE_URL @"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/savecc"//@"http://venmo-sdk-sample-two.herokuapp.com"
//#define USE_CARD_BASE_URL @"http://beta.test.travelworldpassport.com/app_dev.php/nl/app/usecc"
////#define SAMPLE_CHECKOUT_BASE_URL @"http://localhost:4567"
//
//// Pass payment info (eg card data) from the client to your server (and then to the Braintree Gateway).
//// If card data is valid and added to your Vault, display a success message, and dismiss the BTPaymentViewController.
//// If saving to your Vault fails, display an error message to the user via `BTPaymentViewController showErrorWithTitle`
//// Saving to your Vault may fail, for example when
//// * CVV verification does not pass
//// * AVS verification does not pass
//// * The card number was a valid Luhn number, but nonexistent or no longer valid
//- (void) savePaymentInfoToServer:(NSDictionary *)paymentInfo {
//    
//    NSURL *url;
//    if ([paymentInfo objectForKey:@"payment_method_code"]) {
//        url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", USE_CARD_BASE_URL]];
//    } else {
//        url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", SAMPLE_CHECKOUT_BASE_URL]];
//    }
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    
//    // You need a customer id in order to save a card to the Braintree vault.
//    // Here, for the sake of example, we set customer_id to device id.
//    // In practice, this is probably whatever user_id your app has assigned to this user.
//    NSString *customerId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
//    [paymentInfo setValue:customerId forKey:@"customer_id"];
//    [paymentInfo setValue:@"10" forKey:@"amount"];
//    
//    request.HTTPBody = [self postDataFromDictionary:paymentInfo];
//    request.HTTPMethod = @"POST";
//    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
//     {
//         NSError *err = nil;
//         if (!response && requestError) {
//             NSLog(@"requestError: %@", requestError);
//             [self.paymentViewController showErrorWithTitle:@"Error" message:@"Unable to reach the network."];
//             return;
//         }
//         NSLog(@"%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
//         NSDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&err]objectForKey:@"response"];
//         NSLog(@"saveCardToServer: paymentInfo: %@ response: %@, error: %@", paymentInfo, responseDictionary, requestError);
//         
//         if ([[responseDictionary valueForKey:@"success"] isEqualToNumber:@1]) { // Success!
//             // Don't forget to call the cleanup method,
//             // `prepareForDismissal`, on your `BTPaymentViewController`
//             [self.paymentViewController prepareForDismissal];
//             // Now you can dismiss and tell the user everything worked.
//             [self dismissViewControllerAnimated:YES completion:^(void) {
//                 [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Saved your card!" delegate:nil
//                                   cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                 [[VTClient sharedVTClient] refresh];
//             }];
//             
//         } else { // The card did not save correctly, so show the error from server with convenenience method `showErrorWithTitle`
//             [self.paymentViewController showErrorWithTitle:@"Error saving your card" message:[self messageStringFromResponse:responseDictionary]];
//         }
//     }];
//}
//
//// Some boiler plate networking code below.
//
//- (NSString *) messageStringFromResponse:(NSDictionary *)responseDictionary {
//    return [responseDictionary valueForKey:@"message"];
//}
//
//// Construct URL encoded POST data from a dictionary
//- (NSData *)postDataFromDictionary:(NSDictionary *)params {
//    NSMutableString *data = [NSMutableString string];
//    
//    for (NSString *key in params) {
//        NSString *value = [params objectForKey:key];
//        if (value == nil) {
//            continue;
//        }
//        if ([value isKindOfClass:[NSString class]]) {
//            value = [self URLEncodedStringFromString:value];
//        }
//        
//        [data appendFormat:@"%@=%@&", [self URLEncodedStringFromString:key], value];
//    }
//    
//    return [data dataUsingEncoding:NSUTF8StringEncoding];
//}
//
//// This, from CSKit, is free for use:
//// https://github.com/codenauts/CNSKit/blob/master/Classes/Categories/NSString%2BCNSStringAdditions.m
//// NSString *encoded = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$&’()*+,;='"), kCFStringEncodingUTF8);
//
//- (NSString *) URLEncodedStringFromString: (NSString *)string {
//    NSMutableString * output = [NSMutableString string];
//    const unsigned char * source = (const unsigned char *)[string UTF8String];
//    size_t sourceLen = strlen((const char *)source);
//    for (int i = 0; i < sourceLen; ++i) {
//        const unsigned char thisChar = source[i];
//        if (thisChar == ' '){
//            [output appendString:@"+"];
//        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
//                   (thisChar >= 'a' && thisChar <= 'z') ||
//                   (thisChar >= 'A' && thisChar <= 'Z') ||
//                   (thisChar >= '0' && thisChar <= '9')) {
//            [output appendFormat:@"%c", thisChar];
//        } else {
//            [output appendFormat:@"%%%02X", thisChar];
//        }
//    }
//    return output;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
