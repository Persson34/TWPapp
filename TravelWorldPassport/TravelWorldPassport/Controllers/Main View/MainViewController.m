//
//  MainViewController.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 3/11/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "MainViewController.h"
#import "SideMenuViewController.h"
#import "MFSideMenu.h"

@interface MainViewController ()
{
    
}

- (IBAction)menuBtnTapped:(id)sender;
- (IBAction)addBtnTapped:(id)sender;

@end

@implementation MainViewController

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

- (IBAction)menuBtnTapped:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)addBtnTapped:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
