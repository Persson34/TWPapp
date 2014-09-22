//
//  TWPLoginViewController.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 2/4/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWPLoginViewController : UIViewController
{
    
    __weak IBOutlet UIButton *forgotPwdBtn;
    __weak IBOutlet UIButton *registerBtn;
}

- (IBAction)registerBtnTapped:(id)sender;
- (IBAction)signInBtnTapped:(id)sender;
-(void)sendLoginWithFBRequest;

@end
