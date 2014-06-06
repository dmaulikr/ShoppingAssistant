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
    NSString *username = [ZKConstValue getLoginStatus];
    if (!username && [username isEqualToString:@""]) {
        NSLog(@"ERROR: postImage,username is valide");
        return;
    }
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/avatar_%@.png", username]];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:pngPath atomically:YES];
    
    MKNetworkEngine *networkEngine = [[MKNetworkEngine alloc] initWithHostName:SERVER_URL_WITHOUT_HTTP];
    MKNetworkOperation *networkOperation = [networkEngine operationWithPath:[NSString stringWithFormat:@"avatar?username=%@", username] params:nil httpMethod:@"POST"];
    [networkOperation addFile:pngPath forKey:@"file" mimeType:@"image/png"];
    [networkOperation setFreezable:YES];
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *responseString = [completedOperation responseString];
        NSLog(@"server response: %@",responseString);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Upload avatar error: %@", error);
    }];
    [networkEngine enqueueOperation:networkOperation];
}

//- (void)postImage:(UIImage *)image
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString *username = [ZKConstValue getLoginStatus];
//    if (!username && [username isEqualToString:@""]) {
//        NSLog(@"ERROR: postImage,username is valide");
//        return;
//    }
////    NSDictionary *parameters = @{@"username": username};
//    NSData *imageData;
//    if (UIImagePNGRepresentation(image) == nil) {
//        imageData = UIImageJPEGRepresentation(image, 1);
//    } else {
//        imageData = UIImagePNGRepresentation(image);
//    }
//
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//    NSURLSession *upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/avatar",SERVER_URL]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    self.uploadTask = [upLoadSession uploadTaskWithRequest:request fromData:imageData];
//    NSLog(@"%@",[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [self.uploadTask resume];
//}
#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%f",(double)totalBytesSent / (double)totalBytesExpectedToSend);
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
    else {
        
    }
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
