//
//  LoginViewController.h
//  SharityBox
//
//  Created by North on 5/29/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelLoginSignIn;
@property (strong, nonatomic) IBOutlet UILabel *labelLoginEmail;
@property (strong, nonatomic) IBOutlet UILabel *labelLoginPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldLoginEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldLoginPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLoginSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnLoginRegister;
@property (strong, nonatomic) IBOutlet UILabel *labelLoginOr;
- (IBAction)btnLoginClicked:(id)sender;

@end
