//
//  PasswordViewController.h
//  SharityBox
//
//  Created by North on 6/14/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelCurPass;
@property (strong, nonatomic) IBOutlet UILabel *labelNewPass;
@property (strong, nonatomic) IBOutlet UILabel *labelConPass;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnSaveClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtCurPass;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPass;
@property (strong, nonatomic) IBOutlet UITextField *txtConPass;

@end
