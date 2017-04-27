//
//  LDImagePicker.m
//  ImageClipTool
//
//  Created by 刘鹏超 on 2017/3/3.
//  Copyright © 2017年 ImageClipDemo. All rights reserved.
//

#import "LDImagePicker.h"
#import "VPImageCropperViewController.h"
#import "YFKit.h"
@import AVFoundation;
@import Photos;
#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
@interface LDImagePicker()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate>{
    double _scale;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) VPImageCropperViewController *imageCropperController;
@end
@implementation LDImagePicker
#pragma  mark -- 单例 --
+ (instancetype)sharedInstance
{
    static dispatch_once_t ETToken;
    static LDImagePicker *sharedInstance = nil;
    dispatch_once(&ETToken, ^{
        sharedInstance = [[LDImagePicker alloc] init];
        
    });
    return sharedInstance;
}
- (void)showImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController Scale:(double)scale{
    
    
    if(scale>0 &&scale<=1.5){
        _scale = scale;
    }else{
        _scale = 1;
    }
    
    
    if (type == ImagePickerCamera) {//相机
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                // 应用第一次申请权限调用这里
                if ([YFKit isCameraNotDetermined])
                {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (granted)
                            {
                                // 用户授权
                                   [viewController presentViewController:_imagePickerController animated:YES completion:nil];
                            }
                            else
                            {
                                // 用户拒绝授权
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已拒绝访问相机，可去设置隐私里重新开启！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                alert.delegate = self;
                                [alert show];
                            }
                        });
                    }];
                }
                // 用户已经拒绝访问摄像头
                else if ([YFKit isCameraDenied])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拒绝访问相机，可去设置隐私里开启！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    [alert show];
                }
                
                // 用户允许访问摄像头
                else
                {
                    [viewController presentViewController:_imagePickerController animated:YES completion:nil];
                }
            }
            else
            {
                // 当前设备不支持摄像头，比如模拟器
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备不支持拍照！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                [alert show];
            }
        
        
        
    }else{//相册
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                // 第一次安装App，还未确定权限，调用这里
                if ([YFKit isPhotoAlbumNotDetermined])
                {
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                    {
                        // 该API从iOS8.0开始支持
                        // 系统弹出授权对话框
                        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                                {
                                    // 用户拒绝，跳转到自定义提示页面
                                    
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已拒绝访问相册，可去设置隐私里重新开启" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    alert.delegate = self;
                                    [alert show];
                                }
                                else if (status == PHAuthorizationStatusAuthorized)
                                {
                                    // 用户授权，弹出相册对话框
                                    
                                    [viewController presentViewController:_imagePickerController animated:YES completion:nil];
                                }
                            });
                        }];
                    }
                    else
                    {
                        // 以上requestAuthorization接口只支持8.0以上，如果App支持7.0及以下，就只能调用这里。
                       
                        [viewController presentViewController:_imagePickerController animated:YES completion:nil];
                    }
                }
                else if ([YFKit isPhotoAlbumDenied])
                {
                    // 如果已经拒绝，则弹出对话框
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拒绝访问相册，可去设置隐私里开启！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alert.delegate = self;
                    [alert show];
                }
                else
                {
                    // 已经授权，跳转到相册页面
                 
                    [viewController presentViewController:_imagePickerController animated:YES completion:nil];
                }
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备不支持相册！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                [alert show];
            }
        
    }
    
}







- (UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    self.imageCropperController = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, (ScreenHeight-ScreenWidth*_scale)/2, ScreenWidth, ScreenWidth*_scale) limitScaleRatio:5];

    
    self.imageCropperController.delegate = self;
    [picker pushViewController:self.imageCropperController animated:YES];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    if (self.delegate) {
        [self.delegate imagePickerDidCancel:self];
    }
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    UIImagePickerController *picker = (UIImagePickerController *)cropperViewController.navigationController;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [cropperViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [cropperViewController.navigationController popViewControllerAnimated:YES];
    }
}
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController
didFinishedWithSource:(UIImage *)editedImage
  withThumbnailImage:(UIImage *)thumbImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate)
    {
        [self.delegate imagePicker:self didFinishedWithSource:editedImage withThumbnailImage:thumbImage ];
    }
}

@end
