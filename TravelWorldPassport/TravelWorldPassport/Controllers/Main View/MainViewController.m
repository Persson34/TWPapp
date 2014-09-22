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
#import "UIImage+RoundedCorner.h"
#import "UIImage+Resize.h"
#import "StampCell.h"
#import "NewStampViewController.h"
#import "SingleStampViewController.h"
#import "EditProfileViewController.h"
#import "AppDelegate.h"
#import "ImageDownloadEngine.h"
#import "TWPEngine.h"
#import "MBProgressHUD.h"

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    __weak IBOutlet UICollectionView *stampsCollectionView;
    
    IBOutletCollection(UILabel) NSArray *allLabels;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [stampsCollectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [stampsCollectionView registerNib:[UINib nibWithNibName:@"StampCell" bundle:nil] forCellWithReuseIdentifier:@"StampCell"];
    // Do any additional setup after loading the view from its nib.
    [self configureView];
    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.currentUser = appDelegate.loggedUser;
    SideMenuViewController *sideController = (SideMenuViewController*)[self.menuContainerViewController leftMenuViewController];
    [sideController configureForUser:self.currentUser];
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] leftSideMenuController] updateMenuView];
    for (UILabel *aLabel in allLabels) {
        aLabel.font = [UIFont fontWithName:@"LucidaGrande" size:10.0f];
    }
    usernameLabel.font = [UIFont fontWithName:@"LucidaGrande" size:14.0f];
    stampCountLabel.font = [UIFont fontWithName:@"LucidaGrande" size:26.0f];
    followerCounLbl.font =[UIFont fontWithName:@"LucidaGrande" size:26.0f];
    
}

- (IBAction)menuBtnTapped:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)addBtnTapped:(id)sender {
    NewStampViewController *aNewStampController = [[NewStampViewController alloc]initWithNibName:@"NewStampViewController" bundle:nil];
    [aNewStampController setTheUser:self.currentUser];
    [self presentViewController:aNewStampController animated:YES completion:nil];
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Stamps *currentStamp = [self.currentUser.stamps objectAtIndex:indexPath.row];
    SingleStampViewController *aController = [[SingleStampViewController alloc] initWithNibName:@"SingleStampViewController" bundle:nil];
    [aController setSelectedStampNo:indexPath.row];
    [aController setCurrentUser:self.currentUser];
    [aController setSelectedImageURL:currentStamp.stampUrl];
    [self.navigationController pushViewController:aController animated:YES];
}

- (void)configureCell:(StampCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    Stamps *currentStamp = [self.currentUser.stamps objectAtIndex:indexPath.row];
   // NSLog(@"Stamp details %@",currentStamp);
    [cell configureForStamp:currentStamp];
    cell.onDeleteTap = ^(StampCell *selectedCell){
        // Delete the same from the stamps and reload the collection
        NSIndexPath *currentPath =[stampsCollectionView indexPathForCell:selectedCell];
//        NSLog(@"Index path %d, and index path %d",indexPath.row,currentPath.row);
        Stamps *stampToDelete = [self.currentUser.stamps objectAtIndex:currentPath.row];
        NSString *stampIdString =[NSString stringWithFormat:@"%f",stampToDelete.stampId];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[TWPEngine sharedEngine]deleteStampWithId:stampIdString onCompletion:^(NSData *responseString, NSError *theError) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *resp = [[NSString alloc]initWithData:responseString encoding:NSUTF8StringEncoding];
            NSLog(@"Response from server %@",resp);
            [self.currentUser.stamps removeObjectAtIndex:currentPath.row];
            [stampsCollectionView deleteItemsAtIndexPaths:@[currentPath]];
            
        }];
       
        
        
    };
}

# pragma mark - UICustomization
- (void)configureView {
    
    usernameLabel.text = [self.currentUser getFullName];
    stampCountLabel.text = [NSString stringWithFormat:@"%d",(int)self.currentUser.stampCount];
    followerCounLbl.text = [NSString stringWithFormat:@"%d",(int)self.currentUser.followersCount];
    
    [[ImageDownloadEngine sharedEngine]imageAtURL:[NSURL URLWithString:self.currentUser.userProfile] completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        UIImage *roundedImage  = [fetchedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(172, 172) interpolationQuality:kCGInterpolationHigh];
        roundedImage = [roundedImage roundedCornerImage:86.0f borderSize:1.0f];
        
       // UIImage *resultImage= [fetchedImage roundedCornerImage:12.0f borderSize:1];
        userprofileImgView.image = roundedImage;//[roundedImage imageWithBorderFromImage:roundedImage];
//        userprofileImgView.layer.borderWidth = 2.0f;
//        userprofileImgView.layer.borderColor = [UIColor colorWithRed:255/256.0f green:255/256.0f blue:254/256.0f alpha:1.0f].CGColor;
//        userprofileImgView.layer.cornerRadius = roundf(userprofileImgView.frame.size.width/2.0);
//        userprofileImgView.layer.masksToBounds = YES;
       
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
  //  [userprofileImgView setImageFromURL:[NSURL URLWithString:self.currentUser.userProfile]];
    
}

- (void)editProfile {
    if ([[[self.navigationController viewControllers] lastObject] isKindOfClass:[EditProfileViewController class]]) {
        return;
    }
    EditProfileViewController *aController = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    aController.onUserUpdate = ^(TWPUser *updatedUser){
        self.currentUser = updatedUser;
        [self configureView];
        SideMenuViewController *sideController = (SideMenuViewController*)[self.menuContainerViewController leftMenuViewController];
        [sideController configureForUser:self.currentUser];
    };
    [aController setTheUser:self.currentUser];
    [self.navigationController pushViewController:aController animated:YES];
}

@end
