//
//  StampCell.m
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/19/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "StampCell.h"
#import "DataModels.h"
#import "UIImageView+MKNetworkKitAdditions.h"

@implementation StampCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)configureForStamp:(Stamps *)theStamp{
//    stampImageView.contentMode = UIViewContentModeCenter;
    [stampImageView setImageFromURL:[NSURL URLWithString:theStamp.stampUrl]];
}

@end
