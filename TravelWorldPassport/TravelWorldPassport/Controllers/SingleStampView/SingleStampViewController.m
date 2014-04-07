//
//  SingleStampViewController.m
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/4/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "SingleStampViewController.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "KxMenu.h"

@interface SingleStampViewController () <UIDocumentInteractionControllerDelegate>
{
    __weak IBOutlet UIImageView *selectedImgView;
    __weak IBOutlet UIImageView *backImgView;
    __weak IBOutlet UIView *stampView;
    __weak IBOutlet UIButton *sendBtn;
}
@property (strong , nonatomic) UIDocumentInteractionController *dic;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)sendBtnTapped:(id)sender;
- (IBAction)buyBtnTapped:(id)sender;

@end

@implementation SingleStampViewController
@synthesize selectedImageURL;

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
    [selectedImgView setImageFromURL:[NSURL URLWithString:selectedImageURL]];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendBtnTapped:(id)sender {
    [KxMenu showMenuInView:self.view fromRect:sendBtn.frame menuItems:@[[KxMenuItem menuItem:@"Facebook" image:nil target:self action:@selector(fbBtnTapped:)],[KxMenuItem menuItem:@"Twitter" image:nil target:self action:@selector(twitterBtnTapped:)],[KxMenuItem menuItem:@"Instagram" image:nil target:self action:@selector(instaBtnTapped:)]]];
}

- (IBAction)buyBtnTapped:(id)sender {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
