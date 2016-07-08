//
//  ImageFullViewController.m
//  SharityBox
//
//  Created by North on 6/24/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "ImageFullViewController.h"
#import "AppDelegate.h"

@interface ImageFullViewController ()
{
    CGFloat lastScale;
    
    AppDelegate *appDelegate;
}
@end

@implementation ImageFullViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.    appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationItem.titleView = [appDelegate addTitleApp :self.productName];
    
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
    [self initImageView];
    [self addPinchGesture];
}

-(void)initImageView {
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.imagePath]];
    UIImage *theImage = [[UIImage alloc] initWithData:imageData];
    
    self.imageViewFull.image = theImage;
    self.imageViewFull.userInteractionEnabled = YES;

}

-(void)addPinchGesture {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandle:)];
    [self.imageViewFull addGestureRecognizer:pinchGesture];
}


-(void)pinchGestureHandle:(UIPinchGestureRecognizer *)gesture {
    [self.view bringSubviewToFront:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (lastScale - gesture.scale);
    
    CGAffineTransform currentTransform = gesture.view.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    gesture.view.transform = newTransform;
    
    lastScale = gesture.scale;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
