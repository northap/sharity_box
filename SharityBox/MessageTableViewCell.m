//
//  MessageTableViewCell.m
//  SharityBox
//
//  Created by North on 6/17/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "AppDelegate.h"

@implementation MessageTableViewCell

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
    
    [appDelegate changeFontOfView:self.contentView :@"Thai Sans Lite"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
