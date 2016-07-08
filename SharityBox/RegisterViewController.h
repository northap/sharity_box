//
//  RegisterViewController.h
//  SharityBox
//
//  Created by North on 5/29/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<NSURLConnectionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelRegister;
@property (strong, nonatomic) IBOutlet UILabel *labelRegisterFirstName;
@property (strong, nonatomic) IBOutlet UILabel *labelRegisterLastName;
@property (strong, nonatomic) IBOutlet UILabel *labelRegisterPersonalId;
@property (strong, nonatomic) IBOutlet UILabel *labelRegisterEmail;
@property (strong, nonatomic) IBOutlet UILabel *labelRegisterPhone;
@property (strong, nonatomic) IBOutlet UILabel *labelRegisterPass;
@property (strong, nonatomic) IBOutlet UILabel *labelRegisterConPass;
@property (strong, nonatomic) IBOutlet UILabel *labelRegisterAvartar;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
- (IBAction)btnRegisterClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtRegisterFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtRegisterLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtRegisterPerID;
@property (strong, nonatomic) IBOutlet UITextField *txtRegisterEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtRegisterPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtRegisterPass;
@property (strong, nonatomic) IBOutlet UITextField *txtRegisterConPass;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewAvatar;

@end
