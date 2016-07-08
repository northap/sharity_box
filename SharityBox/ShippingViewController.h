//
//  ShippingViewController.h
//  SharityBox
//
//  Created by North on 6/17/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productPrice;
@property (strong, nonatomic) NSString *productImage;
@property (strong, nonatomic) NSString *orderId;
@property BOOL isBidder;

@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProduct;
@property (strong, nonatomic) IBOutlet UITextField *txtTrackingCode;
- (IBAction)btnShipClicked:(id)sender;

@end
