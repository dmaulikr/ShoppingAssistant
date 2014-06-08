//
//  ZKSetAvatarViewController.m
//  ShoppingAssistant
//
//  Created by zikong on 14/6/6.
//  Copyright (c) 2014年 zikong. All rights reserved.
//

#import "ZKSetAvatarViewController.h"

@interface ZKSetAvatarViewController () <LXActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionTaskDelegate>
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) LXActionSheet *actionSheet;
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
@end

@implementation ZKSetAvatarViewController
#pragma mark - Accesser
- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avator"]];
    }
    return _avatarView;
}

- (UIButton *)setButton
{
    if (!_setButton) {
        _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setButton setTitle:@"设置头像" forState:UIControlStateNormal];
        [_setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_setButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.69f blue:0.28f alpha:1.00f]] forState:UIControlStateNormal];
        [_setButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.03f green:0.59f blue:0.28f alpha:1.00f]] forState:UIControlStateHighlighted];
        [_setButton addTarget:self action:@selector(setAvatar:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setButton;
}

#pragma mark - Life Circle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [self.view addSubview:self.avatarView];
    [self.view addSubview:self.setButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    self.avatarView.frame = CGRectMake(53, 93, 215, 215);
    self.setButton.frame = CGRectMake(53, 335, 215, 44);
}

#pragma mark - Private Method

- (void)setAvatar:(id)sender
{
    self.actionSheet = [[LXActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册选择"]];
    [self.actionSheet showInView:self.view];
}

- (void)postImage:(UIImage *)image
{
    [SVProgressHUD show];
    // Build the request body
    NSString *boundary = @"SportuondoFormBoundary";
    NSMutableData *body = [NSMutableData data];
    NSString *username = [ZKConstValue getLoginStatus];
    if (!username && [username isEqualToString:@""]) {
        NSLog(@"ERROR: postImage,username is valide");
        return;
    }

    // Body part for "deviceId" parameter. This is a string.
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"username"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", username] dataUsingEncoding:NSUTF8StringEncoding]];
    // Body part for the attachament. This is an image.
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/pngs\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Setup the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Accept"        : @"application/json",
                                                   @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
                                                   };
    
    // We can use the delegate to track upload progress
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/avatar?username=%@",SERVER_URL,username]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSError *err = nil;
                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
                if ([[dict objectForKey:@"code"] intValue] == 1) {
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:^{
                            self.setAvatarBlock(YES);
                            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:nil];
                            [ZKConstValue setLogin:YES];
                        }];
                    });
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
                    NSLog(@"上传头像失败:%@",[dict objectForKey:@"msg"]);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
            });
        }
    }];
    [uploadTask resume];
}
#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%f",(double)totalBytesSent / (double)totalBytesExpectedToSend);
    });
}

#pragma mark - LXActionSheetDlegate
- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    switch ((int)buttonIndex) {
        case 0:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSLog(@"sorry, no camera or camera is unavailable.");
                return;
            }
            //获得相机模式下支持的媒体类型
            NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            BOOL canTakePicture = NO;
            for (NSString* mediaType in availableMediaTypes) {
                if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
                    //支持拍照
                    canTakePicture = YES;
                    break;
                }
            }
            //检查是否支持拍照
            if (!canTakePicture) {
                NSLog(@"sorry, taking picture is not supported.");
                return;
            }
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
            break;
        case 1:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"get the media info: %@", info);
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage* editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            self.avatarView.image = editedImage;
            [self postImage:editedImage];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
