//
//  ResponseViewController.m
//  SharityBox
//
//  Created by North on 6/15/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "ResponseViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MessageTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"

@interface ResponseViewController ()
{
    AppDelegate *appDelegate;
    
    NSMutableArray *myMessage;
    
    NSDictionary *dict;
    
    NSString *orderMessage;
    NSString *orderUserName;

}
@end

@implementation ResponseViewController

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
    
    orderMessage = @"order_message";
    orderUserName = @"user_first_name";
    
    myMessage = [[NSMutableArray alloc] init];
    
    self.navigationItem.titleView = [appDelegate addTitleApp :@"Response"];
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
    self.tableViewMessage.separatorColor = [UIColor clearColor];
    self.tableViewMessage.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    if (self.isBidder) {
        [_labelOr setHidden:YES];
        [_btnAcceptReturn setHidden:YES];
    }
    
    self.tableViewMessage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped1)];
    
    [self.tableViewMessage addGestureRecognizer:tapGesture1];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self loadMessage];
}

-(void)tableViewTapped1
{
    [self.view endEditing:YES];
}

-(void)loadMessage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/purchase/message_list/oid/%@/file.json?x-api-key=%@", BASE_URL, self.orderId, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [myMessage removeAllObjects];
    
    @try {
        
        for (NSDictionary *dataDict in jsonObjects)
        {
            NSString *strMessage = [dataDict objectForKey:orderMessage];
            NSString *strName = [dataDict objectForKey:orderUserName];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    strMessage, orderMessage,
                    strName, orderUserName,
                    nil];
            [myMessage addObject:dict];
        }
    }
    @catch (NSException *exception)
    {
        NSString *error = [jsonObjects objectForKey:@"error"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myMessage.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    MessageTableViewCell *cell = (MessageTableViewCell *) [tableView dequeueReusableCellWithIdentifier : CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *tmpDict = [myMessage objectAtIndex:indexPath.row];
    
    cell.labelMessage.text = [NSString stringWithFormat: @"%@ : %@",[tmpDict objectForKey:orderUserName], [tmpDict objectForKey:orderMessage]];
    
    CGSize maxLabelSize = CGSizeMake(280, FLT_MAX);
    CGSize expectedLabelSize = [cell.labelMessage.text sizeWithFont:cell.labelMessage.font constrainedToSize:maxLabelSize lineBreakMode:cell.labelMessage.lineBreakMode];
    CGRect newFrame = cell.labelMessage.frame;
    newFrame.size.height = expectedLabelSize.height;
    cell.labelMessage.frame = newFrame;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MessageTableViewCell *cell = (MessageTableViewCell *) [tableView dequeueReusableCellWithIdentifier : CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *tmpDict = [myMessage objectAtIndex:indexPath.row];
  
    NSString *msg = [NSString stringWithFormat: @"%@ : %@",[tmpDict objectForKey:orderUserName], [tmpDict objectForKey:orderMessage]];
    
    CGSize maxLabelSize = CGSizeMake(280, FLT_MAX);
    CGSize expectedLabelSize = [msg sizeWithFont:cell.labelMessage.font constrainedToSize:maxLabelSize lineBreakMode:cell.labelMessage.lineBreakMode];
    
    return  expectedLabelSize.height + 10;
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

- (IBAction)btnAcceptReturnClicked:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [appDelegate setOrderStatus:self.orderId :@"7"];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSendMessageClicked:(id)sender
{
    if ([_txtResponseMessage.text isEqual:@""]) {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.orderId forKey:@"order_id"];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:_txtResponseMessage.text forKey:@"message_detail"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/purchase/send_message.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         //NSString *message = [jsonObjects objectForKey:@"message"];
         
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         //[alert show];
         
         [self loadMessage];
         [_tableViewMessage reloadData];
         
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect aRect = self.view.frame;
    aRect.origin.y -= 100;
    self.view.frame = aRect;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect aRect = self.view.frame;
    aRect.origin.y += 100;
    self.view.frame = aRect;
}

@end
