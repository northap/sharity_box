//
//  ImageFullViewController.h
//  SharityBox
//
//  Created by North on 6/24/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageFullViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageViewFull;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *productName;

@end
