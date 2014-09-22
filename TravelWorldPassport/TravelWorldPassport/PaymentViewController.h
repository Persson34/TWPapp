//
//  PaymentViewController.h
//  TravelWorldPassport
//
//  Created by Chirag Patel on 4/24/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPaymentFormView.h"
#import <VenmoTouch/VenmoTouch.h>
#import "DataModels.h"
@interface PaymentViewController : UIViewController
@property (nonatomic,strong)BTPaymentFormView *aPaymentForm;;
@property (nonatomic,strong)TWPUser *currentUser;
@property (nonatomic,strong)NSMutableArray *stampsToOrder;
@end
