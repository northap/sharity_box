//
//  AttitudeTableViewController.h
//  SharityBox
//
//  Created by North on 6/22/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttitudeTableViewController : UITableViewController

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;

@property NSCache *imageCache;
@property NSOperationQueue *imageDownloadingQueue;

@end
