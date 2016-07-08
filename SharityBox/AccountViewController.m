//
//  AccountViewController.m
//  SharityBox
//
//  Created by North on 6/14/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

#define CAMERA_BUTTON_INDEX 0
#define PHOTO_LIBRARY_BUTTON_INDEX 1

@interface AccountViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation AccountViewController

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
    
    self.navigationItem.titleView = [appDelegate addTitleApp :@"Account Setting"];
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
    [_imageViewAvatar setClipsToBounds:YES];
    
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    [self setupImageView];
    
     [self loadProfile];
}

-(void)loadProfile
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [prefs objectForKey:@"userId"];
    
    NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/index/id/%@.json?x-api-key=%@", BASE_URL, userId, API_KEY]];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *error = [jsonObjects objectForKey:@"error"];
    
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        _txtFirstname.text =  [NSString stringWithFormat:@"%@", [jsonObjects objectForKey:@"user_first_name"]];
        _txtLastname.text = [NSString stringWithFormat:@"%@", [jsonObjects objectForKey:@"user_last_name"]];;
        _txtTelephone.text = [NSString stringWithFormat:@"%@", [jsonObjects objectForKey:@"user_phone"]];;
        
        NSString *imName =[[NSString alloc] initWithFormat:@"%@/files/avatar_images/%@", BASE_URL, [jsonObjects objectForKey:@"user_avatar"]];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imName]];
        _imageViewAvatar.image = [[UIImage alloc] initWithData:imageData];
        
        CALayer *imageLayer = _imageViewAvatar.layer;
        [imageLayer setCornerRadius:_imageViewAvatar.frame.size.width/2];
        [imageLayer setMasksToBounds:YES];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)setupImageView
{
    self.imageViewAvatar.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped1)];
    
    [self.imageViewAvatar addGestureRecognizer:tapGesture1];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
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

- (void)imageViewTapped1
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == CAMERA_BUTTON_INDEX) {
        [self callImagePickerWithSourceType:CAMERA_BUTTON_INDEX];
    } else if (buttonIndex == PHOTO_LIBRARY_BUTTON_INDEX) {
        [self callImagePickerWithSourceType:PHOTO_LIBRARY_BUTTON_INDEX];
    }
}

-(void)callImagePickerWithSourceType:(NSUInteger)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    
    if(type == CAMERA_BUTTON_INDEX && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageViewAvatar.image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSaveClicked:(id)sender
{
    if ([_txtFirstname.text isEqual:@""] ||
        [_txtLastname.text isEqual:@""] ||
        [_txtTelephone.text isEqual:@""])
    {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    if (!_imageViewAvatar.image) {
        [appDelegate alertBox:@"Oops!" :@"Please add avatar"];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    
    alert.delegate = self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    else if (buttonIndex == 1)
    {
        [self saveChange];
    }
}

-(void)saveChange
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[prefs objectForKey:@"userId"] forKey:@"user_id"];
    [params setObject:_txtFirstname.text forKey:@"user_first_name"];
    [params setObject:_txtLastname.text forKey:@"user_last_name"];
    [params setObject:_txtTelephone.text forKey:@"user_phone"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSData *imageData = UIImageJPEGRepresentation(_imageViewAvatar.image, 1.0);
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/update.json", BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"user_avatar" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //id jsonObjects = [appDelegate parseJson:[operation responseString]];
         
         //NSString *message = [jsonObjects objectForKey:@"message"];
         
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         //[alert show];
         
         //alert.delegate = self;
         
         [self.navigationController popViewControllerAnimated:YES];
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
