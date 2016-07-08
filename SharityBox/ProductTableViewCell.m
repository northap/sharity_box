//
//  ProductTableViewCell.m
//  SharityBox
//
//  Created by North on 5/9/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "AppDelegate.h"

@implementation ProductTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [_btnBid setImage:[UIImage imageNamed:@"icon_auction.png"]
             forState:UIControlStateNormal];
    [_btnBid setTitle:@"Auction" forState:UIControlStateNormal];
    [_btnBid setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    int topButton = (_btnBid.frame.size.height - 16) / 2;
    int leftButton = (_btnBid.frame.size.width - 14 ) /2;
    [_btnBid setImageEdgeInsets:UIEdgeInsetsMake(topButton + 2 , leftButton - 23, topButton - 2, leftButton + 23)];
    
    [_btnWatch setImage:[UIImage imageNamed:@"logo_watching.png"]
             forState:UIControlStateNormal];
    [_btnWatch setTitle:@"Watch  " forState:UIControlStateNormal];
    [_btnWatch setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    int topButton2 = (_btnWatch.frame.size.height - 9) / 2;
    int leftButton2 = (_btnWatch.frame.size.width - 16 ) /2;
    [_btnWatch setImageEdgeInsets:UIEdgeInsetsMake(topButton2, leftButton2 - 23, topButton2, leftButton + 23)];
    
    [appDelegate changeFontOfView:self.contentView :@"Thai Sans Lite"];
    
     _productImage.contentMode = UIViewContentModeScaleAspectFill;
    [_productImage setClipsToBounds:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
