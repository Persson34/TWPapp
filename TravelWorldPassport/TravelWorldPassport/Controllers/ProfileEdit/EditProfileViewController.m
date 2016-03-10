//
//  EditProfileViewController.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/7/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "EditProfileViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TWPUser.h"
#import "MBProgressHUD.h"

#import "Reachability.h"
#import "TWPEngine.h"
#import "DataModels.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Resize.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+UIImage_fixOrientation.h"
#import "ADDeviceUtil.h"


@import AddressBook;  

#import <ARAnalytics/ARAnalytics.h>

@interface EditProfileViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    __weak IBOutlet UITextField *pinField;
    __weak IBOutlet UITextField *stateField;
    __weak IBOutlet UITextField *cityField;
    __weak IBOutlet UITextField *streetField;
    __weak IBOutlet UIButton *saveBtn;
    IBOutletCollection(UILabel) NSArray *infoLabels;
    IBOutletCollection(UILabel) NSArray *boldTitles;
    __weak IBOutlet UIButton *profileBtn;
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *surnameField;
    __weak IBOutlet UITextField *addressField;
    UITextField *currentField;
    NSString *cityStr;
    NSString *countryStr;
    Reachability *internetReachable;
    TWPShipping *currentShipping;
    UIImage *originalUserImage;
    __weak IBOutlet UIScrollView *bgscroll;
 
}
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)profileImageBtnTapped:(id)sender;
- (IBAction)saveBtnTapped:(id)sender;
@end

@implementation EditProfileViewController
@synthesize theUser;

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
    [self startUpdatingLocation];
    [ARAnalytics pageView:@"Edit Profile View"];

    NSLog(@"%@",theUser);
    // Do any additional setup after loading the view from its nib.
    saveBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:19.0f];
    nameField.text = [self.theUser name];
    surnameField.text=[self.theUser surname];
    if (! [ADDeviceUtil isIPhone5]) {
       
          bgscroll.contentSize = CGSizeMake(320, 670.0f);
    }
    else{
         bgscroll.contentSize = CGSizeMake(320, 600.0f);
    }
    
//    [[TWPEngine sharedEngine]imageAtURL:[NSURL URLWithString:theUser.userProfile] completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//         dispatch_async(dispatch_get_main_queue(), ^{
//             
//             UIImage *roundedImage  = [fetchedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(160, 160) interpolationQuality:kCGInterpolationHigh];
//             roundedImage = [roundedImage roundedCornerImage:80.0f borderSize:1.0f];
//            
//             [profileBtn setImage:roundedImage forState:UIControlStateNormal];});
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        
//    }];
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:theUser.userProfile] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        originalUserImage = image;
        UIImage *roundedImage  = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(168, 168) interpolationQuality:kCGInterpolationHigh];
        roundedImage = [roundedImage roundedCornerImage:84.0f borderSize:1.0f];
        
        
        [profileBtn setImage:roundedImage forState:UIControlStateNormal];
     
    }];
    // Get the user address from the site.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    if([TWPShipping getStoredShippingDict]==nil){
        // Call , get and store the shipping address
        [[TWPEngine sharedEngine]getUserAddress:[NSString stringWithFormat:@"%d",(int)theUser.userId] onCompletion:^(NSData *responseString, NSError *theError) {
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:responseString options:NSJSONReadingAllowFragments error:nil];
            currentShipping = [TWPShipping modelObjectWithDictionary:respDict];
            [currentShipping saveShippingDict];
             [self configureAddressElements];
             });
        }];
//    }
//    else{
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        currentShipping = [TWPShipping getStoredShippingDict];
//        [self configureAddressElements];
//    }
    
    
    for (UILabel *anInfo in infoLabels) {
        anInfo.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0f];
    }
    for (UILabel *header in  boldTitles) {
        header.font = [UIFont fontWithName:@"AvenirNext-Bold" size:12.0f];
    }
    
    // Configure the done button for pin code.
    // Configure a tool bar for postalcode since its number input
    UIToolbar *aToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem *toolBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"LucidaGrande" size:14.0]} forState:UIControlStateNormal];
    [aToolBar setTintColor:[UIColor grayColor]];
    [aToolBar setItems:@[flexSpace, toolBarItem]];
    pinField.inputAccessoryView = aToolBar;
    
    
    // Adding dummy values
    self.userLocation = [[CLLocation alloc]initWithLatitude:29.23f longitude:67.4f]; //CLLocationCoordinate2DMake(29.23f, 67.4f);
    cityStr = @"Bangalore";
    countryStr = @"IN";
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)profileImageBtnTapped:(id)sender {
    [ARAnalytics event:@"Attempt to change profile picture"];
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"Take Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take new picture",@"Select from photo gallery", nil];
    [aSheet showInView:self.view];
}

- (IBAction)saveBtnTapped:(id)sender {
    //update profile to server
    [self updateProfileToServer];
//    internetReachable = [Reachability reachabilityForInternetConnection];
//    if ([internetReachable isReachable]) {
//        
//    }
//    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
//    }

}

- (void)updateProfileToServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [profileBtn imageForState:UIControlStateNormal];
    [[TWPEngine sharedEngine] editProfile:[NSString stringWithFormat:@"%d",(int)theUser.userId] andName:nameField.text andSurname:surnameField.text andImage:originalUserImage andCountry:countryStr andCity:cityField.text andLat:self.userLocation.coordinate.latitude andLong:self.userLocation.coordinate.longitude nCompletion:^(NSData *responseData, NSError *theError) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (theError || responseData == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            return;
        }
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"Response dict %@",responseDictionary);
        if ([responseDictionary[@"meta"]isEqualToString:@"OK"]) {
            
            TWPUser *updatedUser = [TWPUser modelObjectWithDictionary:responseDictionary];
            self.onUserUpdate(updatedUser);
            NSLog(@"User is %@",updatedUser);
            // Change the user name etc in this
            // Navigate back
            // Probably will also need to update shipping address.
            [[TWPEngine sharedEngine]updateShippingAddress:[self getUpdatedShippingAddress] onCompletion:^(NSData *responseString, NSError *theError) {
                NSLog(@"update shipping address complete.");
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
    }];
}

-(void)configureAddressElements{
    streetField.text = currentShipping.addressOne;
    addressField.text = currentShipping.addressTwo;
    cityField.text = currentShipping.city;
    stateField.text = currentShipping.state;
    pinField.text = currentShipping.postalCode;
}

-(NSDictionary *)getUpdatedShippingAddress{
    NSDictionary *shippingDictionary = @{@"userid":@(theUser.userId) ,@"addressOne":streetField.text,@"addressTwo":addressField.text,@"city":cityField.text,@"state":stateField.text,@"postalCode":pinField.text};
    return shippingDictionary;
}

#pragma mark UIActionSheet Delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"camera");
        [self selectPhotoFrom:0];
    }
    else if (buttonIndex == 1) {
        [self selectPhotoFrom:1];
    }
    else {
        NSLog(@"cancel");
    }
}

- (void)selectPhotoFrom:(int)tag {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init] ;
    imagePicker.delegate = self;
    if (tag == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - UIImagePickerControllerDelegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get the selected image.
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    originalUserImage = [[image fixOrientation]resizedImage:CGSizeMake(320, 320) interpolationQuality:kCGInterpolationHigh];;
    UIImage *roundedImage  = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(160, 160) interpolationQuality:kCGInterpolationHigh];
    roundedImage = [roundedImage roundedCornerImage:80.0f borderSize:1.0f];
    
    [profileBtn setImage:roundedImage forState:UIControlStateNormal];
   // profileBtn.layer.borderColor = [UIColor whiteColor].CGColor;
   // profileBtn.layer.borderWidth = 1.0f;
   // profileBtn.layer.cornerRadius = 10.0f;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate methods

-(void)doneTapped{
    [pinField resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    currentField = textField;
    [self animateView];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    return YES;
}

- (void)animateView {
    if (currentField == nameField) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    else if(currentField == pinField){
        self.view.frame = CGRectMake(0, -230, self.view.frame.size.width, self.view.frame.size.height);
    }
    else {
        self.view.frame = CGRectMake(0, -210, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)startUpdatingLocation {
    // locationManager update as location
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startUpdatingLocation];
}

#pragma mark  location manager delegates

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    self.userLocation = location;
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:self.userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        if (placemarks && placemarks.count > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            
            NSDictionary *addressDictionary =
            placemark.addressDictionary;
            
            NSLog(@"%@ ", addressDictionary);
            NSString *country = [addressDictionary
                                 objectForKey:(NSString *)kABPersonAddressCountryKey];
            NSString *city = [addressDictionary
                              objectForKey:(NSString *)kABPersonAddressCityKey];
            NSString *state = [addressDictionary
                               objectForKey:(NSString *)kABPersonAddressStateKey];
            
            NSLog(@"%@ %@ %@", country,city, state);
            if (city != nil) {
                cityStr = city;
            }
            else {
                cityStr = @"N/A";
            }
            if (country != nil) {
                countryStr = country;
            }
            else {
                countryStr = @"N/A";
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to find user's location" message:@"Please try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
    [alert show];
    [self.locationManager stopUpdatingLocation];
    //    locationManager.delegate = nil;
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //cancel
    }
    else{
        self.locationManager = nil;
        [self startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
