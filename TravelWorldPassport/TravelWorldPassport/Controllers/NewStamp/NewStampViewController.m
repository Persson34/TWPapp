//
//  NewStampViewController.m
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/20/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "NewStampViewController.h"
#import "AVCamCaptureManager.h"
#import "MBProgressHUD.h"
#import "TWPEngine.h"
#import "TWPUser.h"
#import "Stamps.h"
#import "AppDelegate.h"
#import "UIImage+UIImage_fixOrientation.h"
#import "ARAnalytics.h"
#import "UIImage+Resize.h"
#import "KxMenu.h"

@import AddressBook;
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSUInteger, LocationOption) {
    Shooted,
    Current,
    Custom
};

@interface NewStampViewController ()<AVCamCaptureManagerDelegate, UITextFieldDelegate,
        UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate> {
    
    __weak IBOutlet UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
    __weak IBOutlet UIImageView *imgView;
    __weak IBOutlet UILabel *swipeLabel;
            __weak IBOutlet UILabel *loc0Lbl;
    __weak IBOutlet UILabel *stamp1Lbl;
    __weak IBOutlet UILabel *stamp2Lbl;
    __weak IBOutlet UILabel *loc2Lbl;
    __weak IBOutlet UILabel *loc3Lbl;
    __weak IBOutlet UILabel *loc4Lbl;
    __weak IBOutlet UILabel *loc5Lbl;
    __weak IBOutlet UILabel *loc6Lbl;
    __weak IBOutlet UILabel *loc7Lbl;
    __weak IBOutlet UILabel *loc8Lbl;
    __weak IBOutlet UILabel *loc9Lbl;
    __weak IBOutlet UILabel *loc10Lbl;
    __weak IBOutlet UILabel *loc11Lbl;
    __weak IBOutlet UILabel *loc12Lbl;
    __weak IBOutlet UIButton *galleryBtn;
    __weak IBOutlet UIButton *cameraBtn;
    __weak IBOutlet UIButton *crossBtn;
    __weak IBOutlet UIButton *shareBtn;
    __weak IBOutlet UIView *stamp6EditView;
    __weak IBOutlet UIView *stamp7EditView;
    __weak IBOutlet UILabel *stamp6Lbl1;
    __weak IBOutlet UILabel *stamp6Lbl2;
    __weak IBOutlet UILabel *stamp7Lbl1;
    __weak IBOutlet UILabel *stamp7Lbl2;
    __weak IBOutlet UILabel *stamp8Lbl1;
    __weak IBOutlet UILabel *stamp8Lbl2;
    __weak IBOutlet UILabel *stamp8Lbl3;
    __weak IBOutlet UILabel *stamp9Lbl1;
    __weak IBOutlet UILabel *stamp9Lbl2;
    __weak IBOutlet UILabel *stamp10Lbl1;
    __weak IBOutlet UILabel *stamp10Lbl2;
    __weak IBOutlet UILabel *stamp11Lbl1;
    __weak IBOutlet UILabel *stamp11Lbl2;
    __weak IBOutlet UILabel *stamp11Lbl3;
    __weak IBOutlet UILabel *stamp12Lbl1;
            IBOutlet UIView *_contentView;
    int selectedLblTag;
    UIImage *takenPicture;
    AVCamCaptureManager *captureManager;
    UITextField *hiddenTextField;
    
    // Share options
//    UIActivityViewController *anActivityController;
}

@property (strong, nonatomic) IBOutlet UIButton *locationButton;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (assign, nonatomic) LocationOption option;
@property (strong, nonatomic) CLLocation *shootedLocation;
@property (strong, nonatomic) NSString *customLocation;
@property (strong, nonatomic) UIAlertView *customLocationAlerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint11;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint12;

@property (nonatomic) BOOL isCameraLoaded;

- (IBAction)goBackTapped:(id)sender;
- (IBAction)crossBtnTapped:(id)sender;
- (IBAction)shareBtnTapped:(id)sender;
- (IBAction)pageControlTapped:(id)sender;

@end

@implementation NewStampViewController
@synthesize userLocation;
@synthesize locationManager;
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
    
    _isCameraLoaded = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    _widthConstraint0.constant = screenWidth;
    _widthConstraint1.constant = screenWidth;
    _widthConstraint2.constant = screenWidth;
    _widthConstraint3.constant = screenWidth;
    _widthConstraint4.constant = screenWidth;
    _widthConstraint5.constant = screenWidth;
    _widthConstraint6.constant = screenWidth;
    _widthConstraint7.constant = screenWidth;
    _widthConstraint8.constant = screenWidth;
    _widthConstraint9.constant = screenWidth;
    _widthConstraint10.constant = screenWidth;
    _widthConstraint11.constant = screenWidth;
    _widthConstraint12.constant = screenWidth;

    shareBtn.hidden = YES;
    crossBtn.hidden = YES;
    pageControlBeingUsed =NO;
    selectedLblTag = 0;
    hiddenTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, -100, 0, 0)];
    hiddenTextField.delegate = self;
    [self.view addSubview:hiddenTextField];
    [self.view sendSubviewToBack:hiddenTextField];
    [stampsScroll addSubview:_contentView];
//    stampsScroll.contentSize=_contentView.bounds.size;
    [self startUpdatingLocation];
    [self setupLabelFonts];
    
    // Do any additional setup after loading the view from its nib.
//    swipeLabel.font = [UIFont fontWithName:@"Intro" size:16.0f];
   // [swipeLabel sizeToFit];
  //  stampsScroll.userInteractionEnabled = YES;
   // [stampsScroll setBackgroundColor:[UIColor redColor]];
    self.videoPreviewView.userInteractionEnabled = YES;
    
    [ARAnalytics pageView:@"New Stamp View"];
    
    _option = Current;
    
    for (int i =0; i<=12; i++) {
        if (i==1)continue;
        NSString* str=[NSString stringWithFormat:@"loc%iLbl",i];
        UILabel*locLabel=[self valueForKey:str];
        locLabel.text = nil;
    }
    
    stamp1Lbl.text = nil;
    stamp2Lbl.text = nil;
    
    // End of capture code
}

- (void)viewDidLayoutSubviews {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenWidth = screenRect.size.width;
    CGRect frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, screenWidth, screenHeight);
    self.view.frame = frame;
    
    NSInteger numOfSlides=13;
    pageControl.numberOfPages=numOfSlides;
    [stampsScroll setContentSize:CGSizeMake(numOfSlides * self.view.frame.size.width, 387)]; // Need to change this.
    

    if (!_isCameraLoaded)
    {
        [self setupCamera];
        _isCameraLoaded = YES;

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _isCameraLoaded = NO;
}

- (void)setupCamera {
    captureManager = [[AVCamCaptureManager alloc] init];
    
    [captureManager setDelegate:self];
    
    
    if ([captureManager setupSession])
    {
        AVCaptureVideoPreviewLayer *newCapture=[[AVCaptureVideoPreviewLayer alloc] initWithSession:[captureManager session]];
        UIView *view = [self videoPreviewView];
        CALayer *viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        CGRect bounds = [view bounds];
        [newCapture setFrame:bounds];
        
        if ([newCapture respondsToSelector:@selector(connection)])
        {
            if ([newCapture.connection isVideoOrientationSupported])
            {
                [newCapture.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                
            }
        }
        else
        {
            if ([newCapture isOrientationSupported])
            {
                [newCapture setOrientation:AVCaptureVideoOrientationPortrait];
            }
        }
        
        [newCapture setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [viewLayer insertSublayer:newCapture below:[[viewLayer sublayers] objectAtIndex:0]];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[captureManager session] startRunning];
    });
    
    
    
    
//    for (int i = 0; i < [[_contentView subviews] count]; i++)
//    {
//        if ([[[_contentView subviews] objectAtIndex:i] isKindOfClass:[UIView class]])
//        {
//            UIView *currentView = (UIView*)[[_contentView subviews] objectAtIndex:pageControl.currentPage];
//            UIView *view = (UIView*)[[_contentView subviews] objectAtIndex:i];
//            if ([view isEqual:currentView])
//            {
//                CGRect frame = view.frame;
//                frame = CGRectMake(0, 0, self.view.frame.size.width, frame.size.height);
//                view.frame = frame;
//            }
//        }
//    }
}

- (void)setupLabelFonts {
//    //set font
    stamp1Lbl.font = [UIFont fontWithName:@"Metropolis1920" size:40.0f];
    stamp2Lbl.font = [UIFont fontWithName:@"Metropolis1920" size:40.0f];
    loc0Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc2Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc3Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc4Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc5Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc6Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc7Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc8Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc9Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc10Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc11Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    loc12Lbl.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0f];
    stamp6Lbl1.font = [UIFont fontWithName:@"Intro-Inline" size:20.0f];
    stamp6Lbl2.font = [UIFont fontWithName:@"Intro-Inline" size:20.0f];
    stamp7Lbl1.font = [UIFont fontWithName:@"BebasNeue" size:30.0f];
    stamp7Lbl2.font = [UIFont fontWithName:@"Intro-Inline" size:20.0f];
    stamp8Lbl1.font = [UIFont fontWithName:@"Metropolis1920" size:30.0f];
    stamp8Lbl2.font = [UIFont fontWithName:@"Lobster" size:20.0f];
    stamp8Lbl3.font = [UIFont fontWithName:@"Intro" size:20.0f];
    stamp9Lbl1.font = [UIFont fontWithName:@"Oranienbaum-Regular" size:30.0f];
    stamp9Lbl2.font = [UIFont fontWithName:@"Intro-Inline" size:20.0f];
    stamp10Lbl1.font = [UIFont fontWithName:@"Intro" size:25.0f];
    stamp10Lbl2.font = [UIFont fontWithName:@"Lobster" size:20.0f];
    stamp11Lbl1.font = [UIFont fontWithName:@"Intro" size:25.0f];
    stamp11Lbl2.font = [UIFont fontWithName:@"Lobster" size:20.0f];
    stamp11Lbl3.font = [UIFont fontWithName:@"Intro" size:25.0f];
    stamp12Lbl1.font = [UIFont fontWithName:@"Metropolis1920" size:40.0f];
    
    stamp6EditView.layer.borderWidth = 2.0f;
    stamp6EditView.layer.borderColor = [UIColor whiteColor].CGColor;
    // Naresh taken out - Chirag taken out as weel
    NSArray* interactiveLabels=@[stamp6Lbl1,stamp6Lbl2,stamp7Lbl1,stamp7Lbl2,stamp8Lbl1,stamp8Lbl2,stamp8Lbl3,
            stamp9Lbl1,stamp9Lbl2,stamp10Lbl1,stamp10Lbl2,stamp11Lbl1,stamp11Lbl2,stamp11Lbl3,stamp12Lbl1];

    for(UILabel *label in interactiveLabels)
    {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        recognizer.numberOfTapsRequired = 1;
        [label addGestureRecognizer:recognizer];
        label.text=@"Type here";
    }

}

- (void)startUpdatingLocation {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // locationManager update as location
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = 100;
    [locationManager startUpdatingLocation];
}

#pragma mark - Actions

- (IBAction)locationButtonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Shooted location"
                     image:nil
                    target:self
                    action:@selector(shootedLocationTapped)],
      
      [KxMenuItem menuItem:@"Current location"
                     image:nil
                    target:self
                    action:@selector(currentLocationTapped)],
      
      [KxMenuItem menuItem:@"Custom location"
                     image:nil
                    target:self
                    action:@selector(customLocationTapped)]
      ];
    
    [KxMenu showMenuInView:[[UIApplication sharedApplication] keyWindow]
                  fromRect:CGRectMake(23, self.view.frame.size.height - 50, 10, 10)
                 menuItems:menuItems];
}

- (void)shootedLocationTapped {
    _option = Shooted;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    if (_shootedLocation)
    {
        [geoCoder reverseGeocodeLocation:self.shootedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
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
                UILabel*lbl=[self valueForKey:@"loc2Lbl"];
                lbl.text=state;
                
                for (int i =0; i<=12; i++) {
                    if (i==1)continue;
                    NSString* str=[NSString stringWithFormat:@"loc%iLbl",i];
                    UILabel*locLabel=[self valueForKey:str];
                    
                    if (city)
                    {
                        locLabel.text = [NSString stringWithFormat:@"%@, %@",city,country];
                    }
                    else
                    {
                        locLabel.text = [NSString stringWithFormat:@"%@, %@",state,country];
                    }
                    
                    if (_option == Custom) {
                        locLabel.text = _customLocation;
                    }
                }
                
                if (city == nil) {
                    stamp1Lbl.text = state;
                    stamp2Lbl.text = state;
                }
                else {
                    stamp1Lbl.text = city;
                    stamp2Lbl.text = state;
                }
            }
        }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Unable to get shooted location" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    NSLog(@"shootedLocationTapped");
}

- (void)currentLocationTapped {
    _option = Current;
    
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
            UILabel*lbl=[self valueForKey:@"loc2Lbl"];
            lbl.text=state;
            
            for (int i =0; i<=12; i++) {
                if (i==1)continue;
                NSString* str=[NSString stringWithFormat:@"loc%iLbl",i];
                UILabel*locLabel=[self valueForKey:str];
                
                if (city)
                {
                    locLabel.text = [NSString stringWithFormat:@"%@, %@",city,country];
                }
                else
                {
                    locLabel.text = [NSString stringWithFormat:@"%@, %@",state,country];
                }
                
                if (_option == Custom) {
                    locLabel.text = _customLocation;
                }
            }
            
            if (city == nil) {
                stamp1Lbl.text = state;
                stamp2Lbl.text = state;
            }
            else {
                stamp1Lbl.text = city;
                stamp2Lbl.text = state;
            }
        }
    }];
    
    NSLog(@"currentLocationTapped");
}

- (void)customLocationTapped {
    _option = Custom;
    
    self.customLocationAlerView = [[UIAlertView alloc] initWithTitle:@"Enter new folder name"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"ОК", nil];
    [_customLocationAlerView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [_customLocationAlerView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [_customLocationAlerView show];
    
    NSLog(@"customLocationTapped");
}

#pragma mark  location manager delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    CLLocation* location = [locations lastObject];
    self.userLocation = location;
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *selectedLocation;
    if (_option == Current) {
        selectedLocation = self.userLocation;
    } else if (_option == Shooted) {
        selectedLocation = _shootedLocation;
    } else if (_option == Custom) {
        
    }
    
    [geoCoder reverseGeocodeLocation:selectedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
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
            UILabel*lbl=[self valueForKey:@"loc2Lbl"];
            lbl.text=state;

            for (int i =0; i<=12; i++) {
                if (i==1)continue;
                NSString* str=[NSString stringWithFormat:@"loc%iLbl",i];
                UILabel*locLabel=[self valueForKey:str];

                if (city)
                {
                    locLabel.text = [NSString stringWithFormat:@"%@, %@",city,country];
                }
                else
                {
                    locLabel.text = [NSString stringWithFormat:@"%@, %@",state,country];
                }
                
                if (_option == Custom) {
                    locLabel.text = _customLocation;
                }
            }
            
            if (city == nil) {
                stamp1Lbl.text = state;
                stamp2Lbl.text = state;
            }
            else {
                stamp1Lbl.text = city;
                stamp2Lbl.text = state;
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to find user's location" message:@"Please try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
    alert.delegate=self;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _customLocationAlerView)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            NSString *text = [alertView textFieldAtIndex:0].text;
            self.customLocation = text;
            
            
            for (int i =0; i<=12; i++)
            {
                if (i==1)continue;
                NSString* str=[NSString stringWithFormat:@"loc%iLbl",i];
                UILabel*locLabel=[self valueForKey:str];
                if (_option == Custom)
                {
                    locLabel.text = _customLocation;
                    stamp1Lbl.text = _customLocation;
                    stamp2Lbl.text = _customLocation;
                }
            }
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput)
    {
        if ([[[alertView textFieldAtIndex:0] text] length] >= 1)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView != _customLocationAlerView)
    {
        if (buttonIndex==1)
        {
            [self startUpdatingLocation];
        }
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)captureImage:(id)sender {
    [self.videoPreviewView drawViewHierarchyInRect:self.videoPreviewView.bounds afterScreenUpdates:YES];
    [captureManager captureStillImage];
}

- (IBAction)galleryTapped:(id)sender {
    
    UIImagePickerController *anImagePicker= [[UIImagePickerController alloc]init];
    anImagePicker.delegate = self;
    anImagePicker.allowsEditing = YES;
   
    anImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:anImagePicker animated:YES completion:nil];
}

# pragma mark - AVCamCaptureDelegate
-(void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager1{
    takenPicture = [[captureManager1 takenImage] fixOrientation];
    CGFloat imgWidth=CGImageGetWidth(takenPicture.CGImage);
    CGFloat imgHeight=CGImageGetHeight(takenPicture.CGImage);
    CGFloat ratio=imgHeight/imgWidth;

    takenPicture= [takenPicture resizedImage:CGSizeMake(640, 640*ratio) interpolationQuality:kCGInterpolationHigh];
    imgView.image = [self imageByCropping2:takenPicture toRect:CGRectApplyAffineTransform(imgView.frame, CGAffineTransformMakeScale(2.0, 2.0))];
    //[self.view bringSubviewToFront:imgView];
    cameraBtn.hidden = YES;
    galleryBtn.hidden = YES;
    shareBtn.hidden = NO;
    crossBtn.hidden = NO;
    [ARAnalytics event:@"New Stamp Photo" withProperties:@{@"source":@"camera"}];
}

- (UIImage *)imageByScaling:(UIImage*)imageToScale {
    CGSize destinationSize = self.view.frame.size;
    UIGraphicsBeginImageContext(destinationSize);
    [imageToScale drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGFloat imgWidth=CGImageGetWidth(imageToCrop.CGImage);
    CGFloat imgHeight=CGImageGetHeight(imageToCrop.CGImage);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    if (rect.size.height>imgHeight) {
        imgWidth=imgWidth*rect.size.height/imgHeight;
        imgHeight=rect.size.height;

    }
    [imageToCrop drawInRect:CGRectMake((rect.size.width-imgWidth)/2,(rect.size.height-imgHeight)/2,imgWidth,imgHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
    
}

-(UIImage *)imageByCropping2:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (IBAction)goBackTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)crossBtnTapped:(id)sender {
    cameraBtn.hidden = NO;
    galleryBtn.hidden = NO;
    shareBtn.hidden = YES;
    crossBtn.hidden = YES;
    imgView.image = nil;
//    [self.view sendSubviewToBack:imgView];
    _shootedLocation = nil;
}

- (IBAction)pageControlTapped:(id)sender {
    CGRect frame;
    frame.origin.x = stampsScroll.frame.size.width * pageControl.currentPage;
    frame.origin.y = 25;
    frame.size = stampsScroll.frame.size;
    [stampsScroll scrollRectToVisible:frame animated:YES];
}

- (IBAction)shareBtnTapped:(id)sender {
//    UIGraphicsBeginImageContext(imgView.frame.size);
//    [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self uploadStamp:viewImage];
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ARAnalytics event:@"New Stamp Share" withProperties:@{@"template_id":@(pageControl.currentPage)}];
    for (int i = 0; i < [[_contentView subviews] count]; i++) {
        if ([[[_contentView subviews] objectAtIndex:i] isKindOfClass:[UIView class]]) {
            UIView *currentView = (UIView*)[[_contentView subviews] objectAtIndex:pageControl.currentPage];
            UIView *view = (UIView*)[[_contentView subviews] objectAtIndex:i];
            if ([view isEqual:currentView]) {
//                 UIGraphicsBeginImageContext(view.frame.size);//CGSizeMake(284, 332)
                UIGraphicsBeginImageContextWithOptions(view.frame.size, FALSE, 0.0);
               CGContextRef context = UIGraphicsGetCurrentContext();
                // Get all the subviews
                for (id aSubView  in view.subviews) {
                    NSLog(@"Class %@",[aSubView class]);
                    if ([aSubView isKindOfClass:[UILabel class]]) {
                        NSLog(@"Label got");
                        UILabel *theLabel = (UILabel*)aSubView;
                        NSString *theText = theLabel.text;
                        /*[theText drawAtPoint:CGPointMake(x, y)
                         withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:8], NSForegroundColorAttributeName:[UIColor whiteColor] }];
                         */
                        /// Make a copy of the default paragraph style
                        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                        /// Set line break mode
                        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
                        /// Set text alignment
                        paragraphStyle.alignment = theLabel.textAlignment;
                        [theText drawInRect:theLabel.frame withAttributes:@{NSFontAttributeName:theLabel.font,NSForegroundColorAttributeName:theLabel.textColor,NSParagraphStyleAttributeName:paragraphStyle}]; // Draw text instead of label
                    }
                   else if ([aSubView isKindOfClass:[UIImageView class]]) {
                        UIImageView *theImage = (UIImageView*)aSubView;
                        UIImage *stampBg =theImage.image;
                        [stampBg drawInRect:CGRectMake(0, 0, stampBg.size.width, stampBg.size.height)];
                    }
                   else if ([aSubView isKindOfClass:[UIView class]]) {
                        NSLog(@"UIView with some subviews"); // This case happens with only one of the templates
                        UIView *singleSubView = (UIView*)aSubView;
                       if (aSubView == stamp6EditView) {
                           // Get the frame and draw a rectangle with that dimension
                           CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
                           CGContextSetLineWidth(context, 2.0f);
                           CGContextStrokeRect(context, singleSubView.frame);
                       }
                       if (aSubView == stamp7EditView) {
                           CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
                           CGContextSetLineWidth(context, 2.0f);
                           CGContextFillRect(context, singleSubView.frame);
                       }
                       
                        

                    }
                    
                }
//                NSLog(@"view tag is %d",view.tag);
//                NSLog(@"%@",NSStringFromCGRect(view.frame));
               
              //  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//                UIImage *stampImg = [UIImage imageNamed:@"Stamp1.png"];
//                [stampImg drawInRect:CGRectMake(0, 0, stampImg.size.width, stampImg.size.height)];
//                UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 100.0f, 20.0f)];
//                aLabel.text = @"Hello";
//                [aLabel.text drawAtPoint:CGPointMake(40, 50) withAttributes:nil];
                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
              
                UIGraphicsEndImageContext();
//                UIImage *img = [self drawImage:[self imageByCropping:viewImage toRect:CGRectMake(14, 14, 284, 332)] inImage:imgView.image atPoint:CGPointMake(0, 0)];
                 UIImage *img = [self drawImage:[self imageByCropping2:viewImage toRect:CGRectMake(28, 28, 568, 664)] inImage:imgView.image atPoint:CGPointMake(0, 0)];
                NSLog(@"Image size %@ and scale is %f",NSStringFromCGSize(img.size),img.scale);
             
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
                
                if ([TWPEngine sharedEngine].isInternetAvailable)
                {
                    [self uploadStamp:img];
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    [[TWPEngine sharedEngine].unsavedStamps addObject:img];
                    
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[TWPEngine sharedEngine].unsavedStamps];

                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUnsavedStamps];
                    
                    NSLog(@"[UNSAVED STAMPS]: add image, total: %lu", (unsigned long)[[TWPEngine sharedEngine].unsavedStamps count]);

                    [[[UIAlertView alloc] initWithTitle:@"Info" message:@"Your stamp saved locally and will be synced automatically when it will be possible" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
                return;
            }
        }
    }
}

- (UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
   // UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    CGRect newRect = CGRectMake(0, 0, CGImageGetWidth(bgImage.CGImage), CGImageGetHeight(bgImage.CGImage));
    UIGraphicsBeginImageContext(newRect.size );
    [bgImage drawInRect:CGRectMake( 0, 0,  CGImageGetWidth(bgImage.CGImage), CGImageGetHeight(bgImage.CGImage))];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)uploadStamp:(UIImage*)stampImage {

    [[TWPEngine sharedEngine] uploadStamp:[NSString stringWithFormat:@"%d",(int)theUser.userId] andImage:stampImage onCompletion:^(NSData *responseData, NSError *theError) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (theError || responseData == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            return;
        }
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseDictionary);
        Stamps *newStamp = [[Stamps alloc] initWithDictionary:responseDictionary];
        theUser.stampCount+=1;
        [theUser.stamps addObject:newStamp];
        AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate serializeLoggedUser];
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
        // Show the share stuff
//    dispatch_async(dispatch_get_main_queue(), ^{
//        anActivityController =[[UIActivityViewController alloc]initWithActivityItems:@[stampImage] applicationActivities:nil];
//        [self presentViewController:anActivityController animated:YES completion:nil];
//        anActivityController.completionHandler = ^(NSString *activityType, BOOL completed){
//            
//        };
//        
//    });
       
    }];
}

#pragma mark - UIImagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [ARAnalytics event:@"New Stamp Photo" withProperties:@{@"source":@"gallery"}];
    // Put the image here.
    takenPicture = [info objectForKey:UIImagePickerControllerEditedImage ];//[captureManager1 takenImage];
//    UIImage*scaled=[self imageByScaling:takenPicture];
    UIImage*cropped=[self imageByCropping:takenPicture toRect:CGRectMake(0, 0, 572, 670)];
    imgView.image = cropped;
    //[self.view bringSubviewToFront:imgView];
    cameraBtn.hidden = YES;
    galleryBtn.hidden = YES;
    shareBtn.hidden = NO;
    crossBtn.hidden = NO;
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:info[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
        if (asset)
        {
            CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
            if (location)
            {
                self.shootedLocation = location;
            }
        }
    }
                 failureBlock:^(NSError *err) {
                     NSLog(@"Error: %@", [err localizedDescription]);
                 }];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = stampsScroll.frame.size.width;
    int page = floor((stampsScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
    NSLog(@"%d",[[recognizer view] tag]);
    [hiddenTextField resignFirstResponder];
    selectedLblTag = [[recognizer view] tag];
    hiddenTextField.text = nil;
    hiddenTextField.autocorrectionType = UITextAutocorrectionTypeNo;

    [hiddenTextField becomeFirstResponder];
}

#pragma mark UITextField delegate methods

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [hiddenTextField becomeFirstResponder];
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UILabel*label=[self labelForTag:selectedLblTag];
    label.layer.borderWidth=1.0f;
    label.layer.borderColor=[UIColor colorWithRed:17/255.0 green:168/255.0 blue:171/255.0 alpha:1.0].CGColor;

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UILabel*label=[self labelForTag:selectedLblTag];
    label.layer.borderWidth=0.0f;
    label.layer.borderColor=[UIColor colorWithRed:17/255.0 green:168/255.0 blue:171/255.0 alpha:1.0].CGColor;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [[self labelForTag:selectedLblTag] setText:searchStr];
    return YES;
}

-(UILabel*)labelForTag:(NSUInteger)tag
{
    switch (tag) {
        case 1:
            return stamp6Lbl1;
            break;
        case 2:
            return stamp6Lbl2;
            break;
        case 3:
            return stamp7Lbl1;
            break;
        case 4:
            return stamp7Lbl2;
            break;
        case 5:
            return stamp8Lbl1;
            break;
        case 6:
            return stamp8Lbl2;
            break;
        case 7:
            return stamp8Lbl3;
            break;
        case 8:
            return stamp9Lbl1;
            break;
        case 9:
            return stamp9Lbl2;
            break;
        case 10:
            return stamp10Lbl1;
            break;
        case 11:
            return stamp10Lbl2;
            break;
        case 12:
            return stamp11Lbl1;
            break;
        case 13:
            return stamp11Lbl2;
            break;
        case 14:
            return stamp11Lbl3;
            break;
        case 15:
            return stamp12Lbl1;
            
        default:
            break;
    }
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [hiddenTextField resignFirstResponder];
    return YES;
}

@end
