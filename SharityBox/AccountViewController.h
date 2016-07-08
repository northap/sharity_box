//
//  AccountViewController.h
//  SharityBox
//
//  Created by North on 6/14/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelFirstname;
@property (strong, nonatomic) IBOutlet UILabel *labelLastname;
@property (strong, nonatomic) IBOutlet UILabel *labelTelephone;
@property (strong, nonatomic) IBOutlet UILabel *labelAvatar;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnSaveClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstname;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (strong, nonatomic) IBOutlet UITextField *txtTelephone;

@end
