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

@import AddressBook;

@interface NewStampViewController ()<AVCamCaptureManagerDelegate, UITextFieldDelegate> {
    
    __weak IBOutlet UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
    __weak IBOutlet UIImageView *imgView;
    __weak IBOutlet UILabel *swipeLabel;
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
    __weak IBOutlet UIButton *galleryBtn;
    __weak IBOutlet UIButton *cameraBtn;
    __weak IBOutlet UIButton *crossBtn;
    __weak IBOutlet UIButton *shareBtn;
    __weak IBOutlet UIView *stamp6EditView;
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
    int selectedLblTag;
    UIImage *takenPicture;
    AVCamCaptureManager *captureManager;
    UITextField *hiddenTextField;
}

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
//    for (NSString* family in [UIFont familyNames])
//    {
//         NSLog(@"%@", family);
//
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//         {
//                NSLog(@"  %@", name);
//           }
//     }
    [super viewDidLoad];
    shareBtn.hidden = YES;
    crossBtn.hidden = YES;
    pageControlBeingUsed =NO;
    selectedLblTag = 0;
    hiddenTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, -100, 0, 0)];
    hiddenTextField.delegate = self;
    [self.view addSubview:hiddenTextField];
    [self.view sendSubviewToBack:hiddenTextField];
    [self startUpdatingLocation];
    [self setupLabelFonts];
    [stampsScroll setContentSize:CGSizeMake(3522, 405)];
    // Do any additional setup after loading the view from its nib.
    swipeLabel.font = [UIFont fontWithName:@"Intro" size:16.0f];
   // [swipeLabel sizeToFit];
  //  stampsScroll.userInteractionEnabled = YES;
   // [stampsScroll setBackgroundColor:[UIColor redColor]];
    self.videoPreviewView.userInteractionEnabled = YES;
    
    
    // Start of camera code
		captureManager = [[AVCamCaptureManager alloc] init];
		
        [captureManager setDelegate:self];
      //  [self applyDefaults];
        
        
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
                //            NSLog(@"video supported ios 6");
                if ([newCapture.connection isVideoOrientationSupported])
                {
                    [newCapture.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                    
                }
            }
            else
            {
                //            NSLog(@"Deprecated earlier version");
                // Deprecated in 6.0; here for backward compatibility
                if ([newCapture isOrientationSupported])
                {
                    [newCapture setOrientation:AVCaptureVideoOrientationPortrait];
                }
            }
            
            
            [newCapture setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            
            [viewLayer insertSublayer:newCapture below:[[viewLayer sublayers] objectAtIndex:0]];
            
            
        }
      //  [self initializeSubviews];
        
        // Do any additional setup after loading the view, typically from a nib.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[captureManager session] startRunning];
        
        
    });
    
     // End of capture code
}

- (void)setupLabelFonts {
    //set font
    stamp1Lbl.font = [UIFont fontWithName:@"Metropolis1920" size:40.0f];
    stamp2Lbl.font = [UIFont fontWithName:@"Metropolis1920" size:40.0f];
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
    
    stamp6EditView.layer.borderWidth = 2.0f;
    stamp6EditView.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp6Lbl1 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp6Lbl2 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp7Lbl1 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp7Lbl2 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp8Lbl1 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp8Lbl2 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp8Lbl3 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp9Lbl1 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp9Lbl2 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp10Lbl1 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp10Lbl2 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp11Lbl1 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp11Lbl2 addGestureRecognizer:recognizer];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [stamp11Lbl3 addGestureRecognizer:recognizer];
}

- (void)startUpdatingLocation {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // locationManager update as location
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startUpdatingLocation];
}

#pragma mark  location manager delegates

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    CLLocation* location = [locations lastObject];
    self.userLocation = location;
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
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
            if (city == nil) {
                stamp1Lbl.text = state;
                stamp2Lbl.text = state;
                loc2Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc3Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc4Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc5Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc6Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc7Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc8Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc9Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc10Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
                loc11Lbl.text = [NSString stringWithFormat:@"%@, %@",state,country];
            }
            else {
                stamp1Lbl.text = city;
                stamp2Lbl.text = state;
                loc2Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc3Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc4Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc5Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc6Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc7Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc8Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc9Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc10Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
                loc11Lbl.text = [NSString stringWithFormat:@"%@, %@",city,country];
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to find user's location" message:@"Please try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
    [alert show];
    [locationManager stopUpdatingLocation];
    //    locationManager.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)captureImage:(id)sender {
    [captureManager captureStillImage];
}

- (IBAction)galleryTapped:(id)sender {
}

# pragma mark - AVCamCaptureDelegate
-(void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager1{
    takenPicture = [captureManager1 takenImage];
    imgView.image = [self imageByCropping:[self imageByScaling:takenPicture] toRect:CGRectMake(14, 57, 286, 335)];
    //[self.view bringSubviewToFront:imgView];
    cameraBtn.hidden = YES;
    galleryBtn.hidden = YES;
    shareBtn.hidden = NO;
    crossBtn.hidden = NO;
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
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (IBAction)crossBtnTapped:(id)sender {
    cameraBtn.hidden = NO;
    galleryBtn.hidden = NO;
    shareBtn.hidden = YES;
    crossBtn.hidden = YES;
    imgView.image = nil;
//    [self.view sendSubviewToBack:imgView];
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

    for (int i = 0; i < [[stampsScroll subviews] count]; i++) {
        if ([[[stampsScroll subviews] objectAtIndex:i] isKindOfClass:[UIView class]]) {
            UIView *currentView = (UIView*)[[stampsScroll subviews] objectAtIndex:pageControl.currentPage];
            UIView *view = (UIView*)[[stampsScroll subviews] objectAtIndex:i];
            if ([view isEqual:currentView]) {
//                NSLog(@"view tag is %d",view.tag);
//                NSLog(@"%@",NSStringFromCGRect(view.frame));
                UIGraphicsBeginImageContext(view.frame.size);//CGSizeMake(284, 332)
                [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                UIImage *img = [self drawImage:[self imageByCropping:viewImage toRect:CGRectMake(14, 14, 284, 332)] inImage:imgView.image atPoint:CGPointMake(0, 0)];
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
                [self uploadStamp:img];
                return;
            }
        }
    }
}

- (UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
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
        [theUser.stamps addObject:newStamp];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
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
    selectedLblTag = [[recognizer view] tag];
    hiddenTextField.text = nil;
    hiddenTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [hiddenTextField resignFirstResponder];
    [hiddenTextField becomeFirstResponder];
}

#pragma mark UITextField delegate methods

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [hiddenTextField becomeFirstResponder];
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (selectedLblTag) {
        case 1:
            stamp6Lbl1.text = searchStr;
            break;
        case 2:
            stamp6Lbl2.text = searchStr;
            break;
        case 3:
            stamp7Lbl1.text = searchStr;
            break;
        case 4:
            stamp7Lbl2.text = searchStr;
            break;
        case 5:
            stamp8Lbl1.text = searchStr;
            break;
        case 6:
            stamp8Lbl2.text = searchStr;
            break;
        case 7:
            stamp8Lbl3.text = searchStr;
            break;
        case 8:
            stamp9Lbl1.text = searchStr;
            break;
        case 9:
            stamp9Lbl2.text = searchStr;
            break;
        case 10:
            stamp10Lbl1.text = searchStr;
            break;
        case 11:
            stamp10Lbl2.text = searchStr;
            break;
        case 12:
            stamp11Lbl1.text = searchStr;
            break;
        case 13:
            stamp11Lbl2.text = searchStr;
            break;
        case 14:
            stamp11Lbl3.text = searchStr;
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [hiddenTextField resignFirstResponder];
    return YES;
}

@end
