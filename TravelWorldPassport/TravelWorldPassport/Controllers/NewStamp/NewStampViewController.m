//
//  NewStampViewController.m
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/20/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "NewStampViewController.h"
#import "AVCamCaptureManager.h"

@interface NewStampViewController ()<AVCamCaptureManagerDelegate>{
    
    __weak IBOutlet UILabel *swipeLabel;
    AVCamCaptureManager *captureManager;
}

@end

@implementation NewStampViewController

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
    [stampsScroll setContentSize:CGSizeMake(1280, 405)];
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
-(void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager{
    UIImage *pictureTaken = [captureManager takenImage];
    
}

@end
