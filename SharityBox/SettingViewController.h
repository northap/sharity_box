//
//  SettingViewController.h
//  SharityBox
//
//  Created by North on 6/14/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btnAccount;
@property (strong, nonatomic) IBOutlet UIButton *btnPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) IBOutlet UIButton *btnAbout;
- (IBAction)btnLogoutClicked:(id)sender;

@end
