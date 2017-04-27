//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by 刘鹏超 on 2017/3/3.
//  Copyright © 2017年 ImageClipDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VPImageCropperViewController;

@protocol VPImageCropperDelegate <NSObject>

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinishedWithSource:(UIImage *)editedImage withThumbnailImage:(UIImage *)thumbImage;
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;

@end

@interface VPImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
