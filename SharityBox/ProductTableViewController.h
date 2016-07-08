//
//  ProductTableViewController.h
//  SharityBox
//
//  Created by North on 5/9/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewController : UITableViewController <UITabBarControllerDelegate>

@property NSCache *imageCache;
@property NSOperationQueue *imageDownloadingQueue;
@property NSTimer *timer;

@end
