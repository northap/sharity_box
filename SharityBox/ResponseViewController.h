//
//  ResponseViewController.h
//  SharityBox
//
//  Created by North on 6/15/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponseViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *orderId;
@property BOOL isBidder;
@property (strong, nonatomic) IBOutlet UIButton *btnAcceptReturn;
@property (strong, nonatomic) IBOutlet UILabel *labelOr;
- (IBAction)btnAcceptReturnClicked:(id)sender;
- (IBAction)btnSendMessageClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtResponseMessage;
@property (strong, nonatomic) IBOutlet UITableView *tableViewMessage;

@end
