//
//  StampCell.m
//  TravelWorldPassport
//
//  Created by Naresh Kumar D on 3/19/14.
//  Copyright (c) 2014 Chirag Patel. All rights reserved.
//

#import "StampCell.h"
#import "DataModels.h"
//#import "UIImageView+MKNetworkKitAdditions.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (!selected) {
        [(UIImageView*)[self.contentView viewWithTag:100] setImage:nil];
    }
    else {
        [(UIImageView*)[self.contentView viewWithTag:100] setImage:[UIImage imageNamed:@"checkmark.png"]];
    }
}

-(void)configureForStamp:(id)theStamp{
    
    isDeleteMode = NO;
    deleteBtn.hidden = YES;
    UILongPressGestureRecognizer *aPressRecog = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(enterDeleteMode)];
    aPressRecog.minimumPressDuration = 1.0f;
    
    [self addGestureRecognizer:aPressRecog];
    
    if ([theStamp isMemberOfClass:[Stamps class]])
    {
        Stamps *currentStamp = (Stamps *)theStamp;
        stampImageView.alpha = 1.0;
        [stampImageView setImageWithURL:[NSURL URLWithString:currentStamp.stampUrl]];
    }
    else if ([theStamp isMemberOfClass:[UIImage class]])
    {
        UIImage *currentStamp = (UIImage *)theStamp;
        stampImageView.alpha = 0.3;
        stampImageView.image = currentStamp;
    }
}

-(void)prepareForReuse{
    if ([downloadOp isExecuting]) {
        [downloadOp cancel];
    }
    [super prepareForReuse];
    stampImageView.image = nil;
    isDeleteMode = NO;
    deleteBtn.hidden = YES;
}

-(IBAction)deleteTapped:(id)sender{
    NSLog(@"Delete tapped");
    self.onDeleteTap(self);
}

-(void)enterDeleteMode{
    //NSLog(@"Enter delete mode");
    if (isDeleteMode == NO) {
        isDeleteMode = YES;
        // Do in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            deleteBtn.hidden = NO;
        });
        
    }
}

@end
