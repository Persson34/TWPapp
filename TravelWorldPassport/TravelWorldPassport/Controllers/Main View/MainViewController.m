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
#import "UIImageView+MKNetworkKitAdditions.h"
#import "StampCell.h"


@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    __weak IBOutlet UICollectionView *stampsCollectionView;
    
    __weak IBOutlet UIImageView *userprofileImgView;
    __weak IBOutlet UILabel *usernameLabel;
    __weak IBOutlet UILabel *stampCountLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *followerCounLbl;
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
    [stampsCollectionView registerNib:[UINib nibWithNibName:@"StampCell" bundle:nil] forCellWithReuseIdentifier:@"StampCell"];
    // Do any additional setup after loading the view from its nib.
    [self configureView];
    SideMenuViewController *sideController = (SideMenuViewController*)[self.menuContainerViewController leftMenuViewController];
    [sideController configureForUser:self.currentUser];
    
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

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.currentUser.stamps count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StampCell *cell =(StampCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"StampCell" forIndexPath:indexPath];
    
    [self configureCell:cell forItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(StampCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    Stamps *currentStamp = [self.currentUser.stamps objectAtIndex:indexPath.row];
   // NSLog(@"Stamp details %@",currentStamp);
    [cell configureForStamp:currentStamp];
    
}



# pragma mark - UICustomization
- (void)configureView {
    
    usernameLabel.text = self.currentUser.username;
    stampCountLabel.text = self.currentUser.stampCount;
    followerCounLbl.text = self.currentUser.followersCount;
    [userprofileImgView setImageFromURL:[NSURL URLWithString:self.currentUser.userProfile]];
    
}

@end
