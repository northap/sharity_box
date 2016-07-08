//
//  OpenDisputeViewController.h
//  SharityBox
//
//  Created by North on 6/15/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenDisputeViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productPrice;
@property (strong, nonatomic) NSString *productImage;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *orderId;

@property (strong, nonatomic) IBOutlet UITextField *txtNote;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProduct;
@property (strong, nonatomic) IBOutlet UILabel *labelCurrentPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelProblem;
@property (strong, nonatomic) IBOutlet UILabel *labelNote;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnProblem;
- (IBAction)btnProblemClicked:(id)sender;
- (IBAction)btnSendClicked:(id)sender;

@property UIActionSheet *actionSheetProblem;

@end
