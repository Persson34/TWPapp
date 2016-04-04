//
//  CheckoutViewController.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/22/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModels.h"

@interface CheckoutViewController : UIViewController 
{
    
}

@property (nonatomic, assign) int selectedStampNo;
@property (nonatomic,strong)TWPUser *currentUser;

@end
