//
//  LDImagePicker.h
//  ImageClipTool
//
//  Created by 刘鹏超 on 2017/3/3.
//  Copyright © 2017年 ImageClipDemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum ImagePickerType
{
    ImagePickerCamera = 0,
    ImagePickerPhoto = 1
}ImagePickerType;

@class LDImagePicker;
@protocol LDImagePickerDelegate <NSObject>

- (void)imagePicker:(LDImagePicker *)imagePicker didFinishedWithSource:(UIImage *)editedImage
 withThumbnailImage:(UIImage *)thumbImage;
- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker;
@end
@interface LDImagePicker : NSObject
+ (instancetype) sharedInstance;
//scale 裁剪框的高宽比 0~1.5 默认为1
- (void)showImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController Scale:(double)scale;
//代理
@property (nonatomic, assign) id<LDImagePickerDelegate> delegate;
@end
