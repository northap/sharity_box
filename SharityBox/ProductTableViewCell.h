//
//  ProductTableViewCell.h
//  SharityBox
//
//  Created by North on 5/9/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelTrackingCode;
@property (strong, nonatomic) IBOutlet UILabel *labelOrderCode;
@property (strong, nonatomic) IBOutlet UILabel *productBids;

@property (strong, nonatomic) IBOutlet UIButton *btnBid;
@property (strong, nonatomic) IBOutlet UILabel *productTime;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UIButton *btnWatch;
@property (strong, nonatomic) IBOutlet UIButton *btnStatusLeft;
@property (strong, nonatomic) IBOutlet UIButton *btnStatusRight;
@property (strong, nonatomic) IBOutlet UILabel *labelOrderStatus;

@end
