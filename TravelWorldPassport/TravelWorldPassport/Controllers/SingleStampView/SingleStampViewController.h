//
//  SingleStampViewController.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/4/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "DataModels.h"

@interface SingleStampViewController : UIViewController
{
    
}
@property (nonatomic, strong) NSString *selectedImageURL;
@property (nonatomic, assign) int selectedStampNo;
@property (nonatomic,strong)TWPUser *currentUser;
@end
