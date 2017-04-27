//
//  ViewController.m
//  ImageClipDemo
//
//  Created by 刘鹏超 on 2017/3/3.
//  Copyright © 2017年 ImageClipDemo. All rights reserved.
//

#import "ViewController.h"
#import "LDActionSheet.h"
#import "LDImagePicker.h"

#import "YYUserModel.h"

@interface ViewController ()<LDActionSheetDelegate,LDImagePickerDelegate>



//@property (weak, nonatomic) IBOutlet UIImageView *addButton;

@property (strong,nonatomic) UIButton *addButton;

@property (strong,nonatomic) UIImageView *showImageView;

@property (strong,nonatomic) UIButton *closeButton;

@property (strong,nonatomic) NSMutableArray *assetArr;  //图片数组 存储服务器上的URL地址

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    _assetArr = [[NSMutableArray alloc]init];
    
    self.view.userInteractionEnabled = YES;
    
    _addButton = [[UIButton alloc]initWithFrame:CGRectMake(137, 210, 100, 100)];
//    _addButton.clipsToBounds = YES;
    [_addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    _addButton.contentMode = UIViewContentModeScaleAspectFill;
    [_addButton addTarget:self action:@selector(upload_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];

    
    _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 100, 100)];
    _showImageView.userInteractionEnabled = YES;
    
    _showImageView.contentMode = UIViewContentModeScaleToFill;
    
    [_addButton addSubview:_showImageView];
    
    _showImageView.hidden = YES;
    _closeButton = [[UIButton alloc]initWithFrame:CGRectMake((_showImageView.frame.size.width - 30/2 - 5), - 30/2 + 5 , 30, 30)];

    [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    _closeButton.contentMode = UIViewContentModeScaleAspectFit;

    [_closeButton addTarget:self action:@selector(closeImage:) forControlEvents:UIControlEventTouchUpInside];
    [_showImageView addSubview:_closeButton];

}

- (void)upload_Click:(id)sender {
    
    LDActionSheet *actionSheet = [[LDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"相册", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(LDActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
    imagePicker.delegate = self;
    
    [imagePicker showImagePickerWithType:(ImagePickerType)buttonIndex InViewController:self Scale:0.6];
}
- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker{
    

}
- (void)imagePicker:(LDImagePicker *)imagePicker didFinishedWithSource:(UIImage *)editedImage withThumbnailImage:(UIImage *)thumbImage
{
 
    _showImageView.hidden = NO;
    [_showImageView setImage:thumbImage];
    
    YYUserModel *model = [[YYUserModel alloc]init];
    
    NSData *filedata;
    filedata = UIImageJPEGRepresentation(editedImage, 0.3);
    
    [model upload:@"file"
          filename:@"1.png"
          mimeType:@"image/jpeg"
              data:filedata
            parmas:@{
                     @"tok" : @"096f8b0dd77836b64b79e74d361c53f2",
                     @"uid" : @"136"
                     }
     showIndicator:YES
      WithCallback:^(id result, NSString *errorString) {
          
          
          if (result && !errorString)
          {
              
              id invokeArr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
              
              if ([invokeArr isKindOfClass:[NSDictionary class]])
              {
                  NSLog(@"图片尺寸不正确");
                  
                  return ;
              }
              if ([invokeArr isKindOfClass:[NSArray class]])
              {
                  
                  [_assetArr addObject:invokeArr[0]];
              }
              
          }
          else
          {
//              [YYSysUtil showSuccess:GetLocalResStr(@"网络不给力啊，请检查一下网络设置") andView:self.view];
          }
          
          
      }];

    
}

- (void)closeImage:(id)sender
{
    _showImageView.hidden = YES;

}

@end
