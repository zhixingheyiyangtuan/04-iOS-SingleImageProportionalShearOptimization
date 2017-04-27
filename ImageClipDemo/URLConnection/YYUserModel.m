//
//  YYUserModel.m
//  ImageClipDemo
//
//  Created by 刘鹏超 on 2017/3/3.
//  Copyright © 2017年 ImageClipDemo. All rights reserved.
//

#import "YYUserModel.h"

#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]


@implementation YYUserModel
- (void)upload:(NSString *)name
      filename:(NSString *)filename
      mimeType:(NSString *)mimeType
          data:(NSData *)data
        parmas:(NSDictionary *)params
 showIndicator:(BOOL)isShow
  WithCallback:(modelCallBack)callback
{
    // 文件上传
    //    NSURL *url = [NSURL URLWithString:@"http://jybdtjk.jybsoft.cn/index.php?g=user&m=public&a=app_upload"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wdx.jybsoft.cn/index.php?g=user&m=public&a=app_upload"]];
    
    // 文件上传
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    /***************文件参数***************/
    // 参数开始的标志
    [body appendData:YYEncode(@"--YY\r\n")];
    // name : 指定参数名(必须跟服务器端保持一致)
    // filename : 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:YYEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:YYEncode(type)];
    
    [body appendData:YYEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:YYEncode(@"\r\n")];
    
    /***************普通参数***************/
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 参数开始的标志
        [body appendData:YYEncode(@"--YY\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:YYEncode(disposition)];
        
        [body appendData:YYEncode(@"\r\n")];
        [body appendData:YYEncode(obj)];
        [body appendData:YYEncode(@"\r\n")];
    }];
    
    /***************参数结束***************/
    // YY--\r\n
    [body appendData:YYEncode(@"--YY--\r\n")];
    request.HTTPBody = body;
    
    // 设置请求头
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    // 声明这个POST请求是个文件上传
    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    

    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         //         [HUD hide:YES];
         
//         if (isShow) {
//             
//             [HUD hide:YES];
//         }
         
         if (data)
         {
             callback(data,nil);
         }
         else
         {
             //如果返回数据为空，直接抛出异常
             callback(nil,@"返回数据为空");
         }
         
     }];
}

@end
