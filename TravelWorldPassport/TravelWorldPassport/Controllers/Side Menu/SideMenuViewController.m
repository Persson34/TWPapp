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

@interface SideMenuViewController ()
{
    
    __weak IBOutlet UIImageView *userProfilePic;
    __weak IBOutlet UILabel *usernameLabel;
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
}

-(void)configureForUser:(TWPUser *)theUser{
    [userProfilePic setImageFromURL:[NSURL URLWithString:theUser.userProfile]];
    usernameLabel.text = theUser.username;
}

#pragma mark UI button actions

- (IBAction)editBtnTapped:(id)sender {
    
}

- (IBAction)billingBtnTapped:(id)sender {
    
}

- (IBAction)inviteBtnTapped:(id)sender {
    
}

- (IBAction)aboutBtnTapped:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
