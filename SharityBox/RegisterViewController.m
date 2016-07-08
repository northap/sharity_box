//
//  RegisterViewController.m
//  SharityBox
//
//  Created by North on 5/29/2557 BE.
//  Copyright (c) 2557 North. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

#define CAMERA_BUTTON_INDEX 0
#define PHOTO_LIBRARY_BUTTON_INDEX 1

@interface RegisterViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation RegisterViewController

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
    
    self.navigationItem.titleView = [appDelegate addTitleApp :@"Register"];
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.topItem.title = @"";
    }
   
    [appDelegate changeFontOfView:self.view :@"Thai Sans Lite"];
    
    [_imageViewAvatar setClipsToBounds:YES];
    
    [self setupImageView];
}

-(void)setupImageView
{
    self.imageViewAvatar.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped1)];
    
    [self.imageViewAvatar addGestureRecognizer:tapGesture1];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _txtRegisterPerID) {
        NSUInteger newLength = [textField.text length] + [string length] -range.length;
        return (newLength > 13) ? NO : YES;
    }
    else {
        return YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)btnRegisterClicked:(id)sender
{
    if ([_txtRegisterFirstName.text isEqual:@""] ||
        [_txtRegisterLastName.text isEqual:@""] ||
        [_txtRegisterPerID.text isEqual:@""] ||
        [_txtRegisterEmail.text isEqual:@""] ||
        [_txtRegisterPass.text isEqual:@""] ||
        [_txtRegisterPhone.text isEqual:@""] ||
        [_txtRegisterConPass.text isEqual:@""])
    {
        [appDelegate alertBox:@"Oops!" :@"Please fill in all fields"];
        return;
    }
    
    if (!_imageViewAvatar.image) {
        [appDelegate alertBox:@"Oops!" :@"Please add avatar"];
        return;
    }
    
    if (![_txtRegisterPass.text isEqual:_txtRegisterConPass.text]) {
        [appDelegate alertBox:@"Oops!" :@"Password does not math the confirm password"];
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
        [self sendRegister];
    }
}

-(void)sendRegister
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:_txtRegisterFirstName.text forKey:@"user_first_name"];
    [params setObject:_txtRegisterLastName.text forKey:@"user_last_name"];
    [params setObject:_txtRegisterPerID.text forKey:@"user_personal_id"];
    [params setObject:_txtRegisterEmail.text forKey:@"user_email"];
    [params setObject:_txtRegisterPass.text forKey:@"user_password"];
    [params setObject:_txtRegisterPhone.text forKey:@"user_phone"];
    [params setObject:API_KEY forKey:@"x-api-key"];
    
    NSData *imageData = UIImageJPEGRepresentation(_imageViewAvatar.image, 1.0);
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/create.json", BASE_URL];
    
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField != _txtRegisterPerID) {
        CGRect aRect = self.view.frame;
        aRect.origin.y -= 60;
        self.view.frame = aRect;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField != _txtRegisterPerID) {
        CGRect aRect = self.view.frame;
        aRect.origin.y += 60;
        self.view.frame = aRect;
    }
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
