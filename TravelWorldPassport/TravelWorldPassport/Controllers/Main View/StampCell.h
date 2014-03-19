//
//  StampCell.h
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/19/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Stamps;

@interface StampCell : UICollectionViewCell{
    
    __weak IBOutlet UIImageView *stampImageView;
}
-(void)configureForStamp:(Stamps*)theStamp;
@end
