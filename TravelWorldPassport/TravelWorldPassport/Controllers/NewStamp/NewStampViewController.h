//
//  NewStampViewController.h
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/20/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewStampViewController : UIViewController{
    
    __weak IBOutlet UIScrollView *stampsScroll;
    
}
@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;
- (IBAction)captureImage:(id)sender;
- (IBAction)galleryTapped:(id)sender;

@end
