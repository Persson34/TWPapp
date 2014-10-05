//
//  SideMenuViewController.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 3/11/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "SideMenuViewController.h"
#import "DataModels.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "ImageDownloadEngine.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "MainViewController.h"
#import "MFSideMenu.h"
#import "TWPUser.h"

@interface SideMenuViewController ()
{
    IBOutletCollection(UIButton) NSArray *allButtons;

    __weak IBOutlet UIImageView *userProfilePic;
    __weak IBOutlet UILabel *usernameLabel;
    TWPUser *currentUser;
    UIActivityViewController *anActivityController;
}

- (IBAction)editBtnTapped:(id)sender;
- (IBAction)billingBtnTapped:(id)sender;
- (IBAction)inviteBtnTapped:(id)sender;
- (IBAction)aboutBtnTapped:(id)sender;

@end

@implementation SideMenuViewController

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
    for (UIButton *aBtn in allButtons) {
        aBtn.titleLabel.font = [UIFont fontWithName:@"LucidaGrande" size:15.0f];
    }
    usernameLabel.font =  [UIFont fontWithName:@"LucidaGrande" size:14.0f];
}

-(void)configureForUser:(TWPUser *)theUser{
    currentUser = theUser;
    //[userProfilePic setImageFromURL:[NSURL URLWithString:theUser.userProfile]];
    [[ImageDownloadEngine sharedEngine]imageAtURL:[NSURL URLWithString:theUser.userProfile] completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        UIImage *roundedImage  = [fetchedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(112, 112) interpolationQuality:kCGInterpolationHigh];
        roundedImage = [roundedImage roundedCornerImage:56.0f borderSize:0.0f];
        
        // UIImage *resultImage= [fetchedImage roundedCornerImage:12.0f borderSize:1];
        userProfilePic.image = roundedImage;
//        userProfilePic.layer.borderWidth = 3.0f;
//        userProfilePic.layer.borderColor = [UIColor whiteColor].CGColor;
//        userProfilePic.layer.cornerRadius = roundf(userProfilePic.frame.size.width/2.0);
//        userProfilePic.layer.masksToBounds = YES;
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    usernameLabel.text = [theUser getFullName];
}


#pragma mark UI button actions

- (IBAction)editBtnTapped:(id)sender {
    if ([_delegate respondsToSelector:@selector(requestProfileEdit)]) {
        [_delegate requestProfileEdit];
    }
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)billingBtnTapped:(id)sender {
    
}

- (IBAction)inviteBtnTapped:(id)sender {
    // Need to show the sharing screen.
    
    NSString *textToShare = [NSString stringWithFormat:@"%@ wants you to checkout this new app. It's a visual journal and allows you to create beautiful stamps for your Travel World Passport. Never heard of it? Find out more here (link: http://www.travelworldpassport.com/)",currentUser.name ];
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.travelworldpassport.com/"];
    anActivityController= [[UIActivityViewController alloc]initWithActivityItems:@[textToShare,urlToShare] applicationActivities:nil];
    anActivityController.completionHandler=^(NSString *activityType, BOOL completed){
        NSLog(@"finished");
    };
    
    [self presentViewController:anActivityController animated:YES completion:nil];
}

- (IBAction)aboutBtnTapped:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.travelworldpassport.com"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
