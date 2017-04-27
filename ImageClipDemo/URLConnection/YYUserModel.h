//
//  YYUserModel.h
//  ImageClipDemo
//
//  Created by 刘鹏超 on 2017/3/3.
//  Copyright © 2017年 ImageClipDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^modelCallBack) (id result, NSString *errorString);


@interface YYUserModel : NSObject


- (void)upload:(NSString *)name
      filename:(NSString *)filename
      mimeType:(NSString *)mimeType
          data:(NSData *)data
        parmas:(NSDictionary *)params
 showIndicator:(BOOL)isShow
  WithCallback:(modelCallBack)callback;

@end
