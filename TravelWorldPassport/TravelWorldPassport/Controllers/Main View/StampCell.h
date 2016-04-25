//
//  StampCell.h
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/19/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloadEngine.h"
@class Stamps;

@interface StampCell : UICollectionViewCell{
    
    __weak IBOutlet UIButton *deleteBtn;
    __weak IBOutlet UIImageView *stampImageView;
    MKNetworkOperation *downloadOp;
    BOOL isDeleteMode;
}
@property (nonatomic,strong)void(^onDeleteTap)(StampCell *cell);
-(void)configureForStamp:(id)theStamp;


@end
