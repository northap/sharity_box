//
//  FeedbackViewController.h
//  SharityBox
//
//  Created by North on 5/29/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productPrice;
@property (strong, nonatomic) NSString *productImage;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *auctionId;
@property (strong, nonatomic) NSString *orderId;

@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelProductPrice;

@property (strong, nonatomic) IBOutlet UILabel *labelFeedbackPrice;

@property (strong, nonatomic) IBOutlet UILabel *labelFeedbackPoint;
@property (strong, nonatomic) IBOutlet UILabel *labelFeedbackNote;
@property (strong, nonatomic) IBOutlet UIButton *btnFeedback;
@property (strong, nonatomic) IBOutlet UIButton *btnFeedbackPoint;
- (IBAction)btnFeedbackPointClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProduct;
- (IBAction)btnFeedbackClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtFeedbackNote;

@property UIActionSheet *actionSheetFeedback;

@end
