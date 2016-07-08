//
//  LoginViewController.m
//  SharityBox
//
//  Created by North on 5/29/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "Reachability.h"

@interface LoginViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation LoginViewController

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
    self.navigationItem.titleView = [appDelegate addTitleIconApp];
    
    if (IS_OS_7_OR_LATER) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_bg.fw.png"] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:165.0f/255.0f blue:197.0f/255.0f alpha:1.0f];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.0f/255.0f green:165.0f/255.0f blue:197.0f/255.0f alpha:1.0f]}];
        //[self.navigationController.navigationBar setTranslucent:NO];
    }


    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
   
    Reachability *network = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [network currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Internet Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        alert.delegate = self;
        
        return;
    }
 
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs objectForKey:@"userId"]) {
        [self navigateToTapBarMain];
        return;
    }
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

- (IBAction)btnLoginClicked:(id)sender
{
    if ([_txtfieldLoginEmail.text isEqual:@""] || [_txtfieldLoginPassword.text isEqual:@""]) {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:_txtfieldLoginEmail.text forKey:@"user_email"];
    [params setObject:_txtfieldLoginPassword.text forKey:@"user_password"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/login.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        id jsonObjects = [appDelegate parseJson:[operation responseString]];
        
        //NSString *message = [jsonObjects objectForKey:@"message"];
        
        NSDictionary *userData = [jsonObjects objectForKey:@"user_data"];
        NSString *userId = [userData objectForKey:@"user_id"];
        
        [prefs setObject:userId forKey:@"userId"];
        
        [self navigateToTapBarMain];
        
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
        exit(0);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)navigateToTapBarMain
{
    UIStoryboard *storyboard = self.navigationController.storyboard;
    UIViewController *addAuction = [storyboard instantiateViewControllerWithIdentifier:@"TapBarMain"];
    [self.navigationController pushViewController:addAuction animated:YES];
}

@end
