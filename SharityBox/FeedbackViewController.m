//
//  FeedbackViewController.m
//  SharityBox
//
//  Created by North on 5/29/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface FeedbackViewController ()
{
    NSMutableArray *myFeedback;
    
    NSDictionary *dictFeedback;
    
    NSDictionary *tmpDictFeedback;
    
    NSString *feedbackName;
    NSString *feedbackEnum;
    
    AppDelegate *appDelegate;

}

@end

@implementation FeedbackViewController

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
    // Do any additional setup after loading the view.
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    feedbackName = @"feedback_name";
    feedbackEnum = @"feedback_enum";
    
    myFeedback = [[NSMutableArray alloc] init];
    
    [_imageViewProduct setClipsToBounds:YES];
    
    self.navigationItem.titleView = [appDelegate addTitleApp :@"Confirm Receive & Feedback"];
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    dictFeedback = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Positive", feedbackName,
                    @"POSITIVE", feedbackEnum,
                    nil];
    [myFeedback addObject:dictFeedback];
    
    dictFeedback = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Natural", feedbackName,
                    @"NATURAL", feedbackEnum,
                    nil];
    [myFeedback addObject:dictFeedback];
    
    dictFeedback = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Negative", feedbackName,
                    @"NEGATIVE", feedbackEnum,
                    nil];
    [myFeedback addObject:dictFeedback];
    
    NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/product_images/%@", BASE_URL, self.productImage];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imName]];
    
    _imageViewProduct.image = [[UIImage alloc] initWithData:imageData];
    _labelProductName.text = self.productName;
    _labelProductPrice.text = [NSString stringWithFormat: @"฿ %@",self.productPrice];

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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet == _actionSheetFeedback) {
        tmpDictFeedback = [myFeedback objectAtIndex:buttonIndex];
        [_btnFeedbackPoint setTitle:[tmpDictFeedback objectForKey:feedbackName] forState:UIControlStateNormal];
    }
    
}

- (IBAction)btnFeedbackPointClicked:(id)sender
{
    _actionSheetFeedback = [[UIActionSheet alloc] initWithTitle:@"Payment Method" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *item in myFeedback)
    {
        [_actionSheetFeedback addButtonWithTitle:[item objectForKey:feedbackName]];
    }
    
    [_actionSheetFeedback addButtonWithTitle:@"Cancel"];
    _actionSheetFeedback.cancelButtonIndex = [myFeedback count];
    
    [_actionSheetFeedback showInView:self.view];
}
- (IBAction)btnFeedbackClicked:(id)sender
{
    if ([_txtFeedbackNote.text isEqual:@""] ||
        !_btnFeedbackPoint.titleLabel.text) {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.productId forKey:@"product_id"];
    [params setObject:self.auctionId forKey:@"auction_id"];
    [params setObject:[tmpDictFeedback objectForKey:feedbackEnum] forKey:@"rate"];
    [params setObject:_txtFeedbackNote.text forKey:@"feedback"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/product/feedback.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         [appDelegate setOrderStatus:self.orderId :@"5"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         alert.delegate = self;
         
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         NSString *message = [jsonObjects objectForKey:@"message"];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         alert.delegate = nil;
     }];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *_currentView in actionSheet.subviews) {
        if ([_currentView isKindOfClass:[UIButton class]]) {
            [((UIButton *)_currentView).titleLabel setFont:[UIFont fontWithName:@"Thai Sans Lite" size:20]];
        }
        if ([_currentView isKindOfClass:[UILabel class]]) {
            [((UILabel *)_currentView) setFont:[UIFont fontWithName:@"Thai Sans Lite" size:15]];
        }
    }
}
@end
