//
//  OpenDisputeViewController.m
//  SharityBox
//
//  Created by North on 6/15/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "OpenDisputeViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@interface OpenDisputeViewController ()
{
    NSMutableArray *myProblem;
    
    NSString *tmpDictProblem;
    
    AppDelegate *appDelegate;
}

@end

@implementation OpenDisputeViewController

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
    myProblem = [[NSMutableArray alloc] init];
    
    [_imageViewProduct setClipsToBounds:YES];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationItem.titleView = [appDelegate addTitleApp :@"Open Dispute"];
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/product_images/%@", BASE_URL, self.productImage];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imName]];
    
    _imageViewProduct.image = [[UIImage alloc] initWithData:imageData];
    _labelProductName.text = self.productName;
    _labelProductPrice.text = [NSString stringWithFormat: @"฿ %@",self.productPrice];
    
    [myProblem addObject:@"I have not received the product."];
    [myProblem addObject:@"This Product is not same as the picture."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet == _actionSheetProblem) {
        tmpDictProblem = [myProblem objectAtIndex:buttonIndex];
        [_btnProblem setTitle:tmpDictProblem forState:UIControlStateNormal];
    }
    
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

- (IBAction)btnProblemClicked:(id)sender
{
    _actionSheetProblem = [[UIActionSheet alloc] initWithTitle:@"What is your problem?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *item in myProblem)
    {
        [_actionSheetProblem addButtonWithTitle:item];
    }
    
    [_actionSheetProblem addButtonWithTitle:@"Cancel"];
    _actionSheetProblem.cancelButtonIndex = [myProblem count];
    
    [_actionSheetProblem showInView:self.view];
}

- (IBAction)btnSendClicked:(id)sender
{
    if ([_txtNote.text isEqual:@""] ||
        !_btnProblem.titleLabel.text) {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.orderId forKey:@"order_id"];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%@ %@", tmpDictProblem, _txtNote.text] forKey:@"message_detail"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/purchase/send_message.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         //NSString *message = [jsonObjects objectForKey:@"message"];
         
         [appDelegate setOrderStatus:self.orderId :@"6"];
         
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         //[alert show];
         
         //alert.delegate = self;
         
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
