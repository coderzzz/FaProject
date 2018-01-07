//
//  NetWorkManager.m
//  AFNetWorking再封装
//
//  Created by 戴文婷 on 16/5/20.
//  Copyright © 2016年 戴文婷. All rights reserved.
//

#import "BAIRUITECH_NetWorkManager.h"
//#import "UIImage+compressIMG.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>


//#import "BAIRUITECH_Utils.h"


#define Interface_version  @"1.0.0"
#define Appkey             @"123456"

@implementation BAIRUITECH_NetWorkManager

#pragma mark - shareManager
/**
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类的实例
 */

+(instancetype)shareManager
{
    
    static BAIRUITECH_NetWorkManager * manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        
    });
    
    return manager;
}


#pragma mark - 重写initWithBaseURL
/**
 *
 *
 *  @param url baseUrl
 *
 *  @return 通过重写夫类的initWithBaseURL方法,返回网络请求类的实例
 */

-(instancetype)initWithBaseURL:(NSURL *)url
{

    if (self = [super initWithBaseURL:url]) {
        
        
        
#warning 可根据具体情况进行设置
        
        NSAssert(url,@"您需要为您的请求设置baseUrl");
        
        /**设置请求超时时间*/
        
        self.requestSerializer.timeoutInterval = 30.0f;
        
        /**设置相应的缓存策略*/
        
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        
        /**分别设置请求以及相应的序列化器*/
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
    
        response.removesKeysWithNullValues = YES;
        
        self.responseSerializer = response;
        
        /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        
        //[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        

#warning 此处做为测试 可根据自己应用设置相应的值
        
        /**设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
//        appkey		身份标识，服务器端进行识别
//        udid		客户端硬件标识
//        os			ios& android& WM7
//        osversion	5.0
//        appversion	app发布版本
//        ver
//        userid		登录完之后传客户端
//        usersession	登录标识
     
//        [self.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
//        [self.requestSerializer setValue:@"123456" forHTTPHeaderField:@"apikey"];
//        
//        if(![Utils isBlankObject:[BAIRUITECH_BRAccoutTool account]])
//        {
//            NSNumber* userId=[BAIRUITECH_BRAccoutTool account].userId;
//            [self.requestSerializer setValue:[NSString stringWithFormat:@"%i",[userId intValue]] forHTTPHeaderField:@"userId"];
//        }
        
        
        
        /**设置接受的类型*/
        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
        
    }
    
    return self;
}


#pragma mark - 网络请求的类方法---get/post 

/**
 *  网络请求的实例方法
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progress 进度
 */
- (void)setHeadersWithName:(NSString *)name{
    
    [self.requestSerializer setValue:name forHTTPHeaderField:@"interface_name"];
    [self.requestSerializer setValue:Interface_version forHTTPHeaderField:@"interface_version"];
    [self.requestSerializer setValue:Appkey forHTTPHeaderField:@"appkey"];
    [self.requestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"udid"];
    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"os"];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]] forHTTPHeaderField:@"osversion"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.requestSerializer setValue:app_Version forHTTPHeaderField:@"appversion"];
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    NSString *userid = user.userId?user.userId:@"0";
    NSString *token = user.token?user.token:@"";
    
    [self.requestSerializer setValue:userid forHTTPHeaderField:@"userid"];
    [self.requestSerializer setValue:token forHTTPHeaderField:@"usersession"];

    
    
    //        [self.requestSerializer setValue:@"123456" forHTTPHeaderField:@"apikey"];
}

+(void)requestWithType:(HttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock progress:(downloadProgress)progress
{
    
    [[self shareManager]setHeadersWithName:urlString];
    switch (type) {
            
        case HttpRequestTypeGet:
        {
            
            NSLog(@"http请求参数----%@",paraments);
            NSLog(@"http请求URL===%@",[NSString stringWithFormat:@"%@%@",BaseURL,urlString]);
            [[BAIRUITECH_NetWorkManager shareManager] GET:[NSString stringWithFormat:@"%@%@",BaseURL,urlString] parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                
                //progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                successBlock(responseObject);
                NSLog(@"%@",responseObject);
                int errorCode = [responseObject[@"ret"] intValue];
                if (errorCode != 0) {//如果服务器返回了错误码
                    
                    NSString *fullUrlString = [NSString stringWithFormat:@"%@%@",BaseURL,urlString];
                    NSDate *currentDate = [NSDate date];//获取当前时间，日期
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss SS"];
                    NSString *dateString = [dateFormatter stringFromDate:currentDate];
                    NSString *message = responseObject[@"message"];
                    NSString *logString = [NSString stringWithFormat:@"%@ %@ param:%@ message:%@",dateString,fullUrlString,paraments,message];
//                    [BAIRUITECH_Utils saveLogWithLogString:logString];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                       failureBlock(error);
                [BAIRUITECH_BRTipView showTipImgName:@"AnyChatSDKResources.bundle/为空/暂无网络" delay:1];
            }];
            
            break;
        }
            
        case HttpRequestTypePost:
            
        {
            NSLog(@"--------%@",paraments);
            NSLog(@"=======%@",[NSString stringWithFormat:@"%@%@",BaseURL,urlString]);
            [[BAIRUITECH_NetWorkManager shareManager] POST:[NSString stringWithFormat:@"%@%@",BaseURL,urlString] parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
                
                //progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);

                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                    successBlock(responseObject);
                NSLog(@"%@",responseObject);
                int errorCode = [responseObject[@"ret"] intValue];
                if (errorCode != 0) {//如果服务器返回了错误码
                    NSString *fullUrlString = [NSString stringWithFormat:@"%@%@",BaseURL,urlString];
                    NSDate *currentDate = [NSDate date];//获取当前时间，日期
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss SS"];
                    NSString *dateString = [dateFormatter stringFromDate:currentDate];
                    NSString *message = responseObject[@"message"];
                    NSString *logString = [NSString stringWithFormat:@"%@ %@ param:%@ message:%@",dateString,fullUrlString,paraments,message];
//                    [BAIRUITECH_Utils saveLogWithLogString:logString];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                     failureBlock(error);
                [BAIRUITECH_BRTipView showTipImgName:@"AnyChatSDKResources.bundle/为空/暂无网络" delay:1];
            }];
        }
            
    }
    
}


#pragma mark - 多图上传
/**
 *  上传图片
 *
 *  @param operations   上传图片等预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url---请填写完整的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 *
 */
+(void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withtargetWidth:(CGFloat )width withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress;
{

    
    //1.创建管理者对象

      AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
     [manager POST:[NSString stringWithFormat:@"%@%@",BaseURL,urlString] parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        
        /**出于性能考虑,将上传图片进行压缩*/
        for (UIImage * image in imageArray) {
            
            //image的分类方法
//            UIImage *  resizedImage =  [UIImage IMGCompressed:image targetWidth:width];
//            
            NSData * imgData = UIImageJPEGRepresentation(image, 0.5f);
            
//            NSData * imgData = [BAIRUITECH_Utils compressTheBBImage:image];
  
            //拼接data
        
            [formData appendPartWithFileData:imgData name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
            
            i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        failureBlock(error);
        
    }];
}



#pragma mark - 视频上传

/**
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */

+(void)uploadVideoWithOperaitons:(NSDictionary *)operations withVideoPath:(NSString *)videoPath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withUploadProgress:(uploadProgress)progress
{
    
    
    /**获得视频资源*/
    
    AVURLAsset * avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];

    /**压缩*/
    
//    NSString *const AVAssetExportPreset640x480;
//    NSString *const AVAssetExportPreset960x540;
//    NSString *const AVAssetExportPreset1280x720;
//    NSString *const AVAssetExportPreset1920x1080;
//    NSString *const AVAssetExportPreset3840x2160;
    
    AVAssetExportSession  *  avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
    
    /**创建日期格式化器*/
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /**转化后直接写入Library---caches*/
    
    NSString *  videoWritePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/output-%@.mp4",[formatter stringFromDate:[NSDate date]]]];
    
    
    avAssetExport.outputURL = [NSURL URLWithString:videoWritePath];
    
    
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
       
        
        switch ([avAssetExport status]) {
                
                
            case AVAssetExportSessionStatusCompleted:
            {
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                
                [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //获得沙盒中的视频内容
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                       progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    
                    successBlock(responseObject);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    failureBlock(error);
                    
                }];
                
                break;
            }
            default:
                break;
        }
        
        
    }];

}

#pragma mark - 文件下载


/**
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */

+(void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withDownLoadProgress:(downloadProgress)progress
{
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    
    [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);

        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
                return  [NSURL URLWithString:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            
            failureBlock(error);
        }
        
    }];
    
}


#pragma mark -  取消所有的网络请求

/**
 *  取消所有的网络请求
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

+(void)cancelAllRequest
{
    
    [[BAIRUITECH_NetWorkManager shareManager].operationQueue cancelAllOperations];
    
}



#pragma mark -   取消指定的url请求/
/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 */

+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string
{
    
    NSError * error;
    
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    
    NSString * urlToPeCanced = [[[[BAIRUITECH_NetWorkManager shareManager].requestSerializer requestWithMethod:requestType URLString:[NSString stringWithFormat:@"%@%@",BaseURL,string] parameters:nil error:&error] URL] path];
    
    
    for (NSOperation * operation in [BAIRUITECH_NetWorkManager shareManager].operationQueue.operations) {
        
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            //请求的url匹配
            
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                
                [operation cancel];
                
            }
        }
        
    }
}




//http://live.anychat.cn/AnyChatLive/v1/live/getLiveHostList改地址可以进行接口测试

//登陆
+(void)FinanceLiveShow_loginParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/user/login" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


//验证码
+(void)FinanceLiveShow_SMSCodeParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/base/sendSms" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//第三方登陆
+(void)FinanceLiveShow_thirdplatLoginParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/thirdplatLogin" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//注册
+(void)FinanceLiveShow_registParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/user/register" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//房间列表
+(void)FinanceLiveShow_roomList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
     [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/home/getModuleRoom" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
    
}


+(void)FinanceLiveShow_blackList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/star/getUserBlackList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
    
}


+(void)FinanceLiveShow_OrderList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getGrabAskList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
    
}

+(void)FinanceLiveShow_mess:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/message/getMessList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
    
}

+(void)FinanceLiveShow_od:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getBuyAskDetail" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
    
}


//fensi列表
+(void)FinanceLiveShow_fans:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/userfollow/getFollows" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
    
}

+(void)FinanceLiveShow_follow:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/userfollow/getFans" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_chatHis:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/message/getChatHisList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//观众列表
+(void)FinanceLiveShow_users:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/room/onlineViewer" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}





//进入房间
+(void)FinanceLiveShow_enterRoom:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/room/enterRoom" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
    
}
//找回密码
+(void)FinanceLiveShow_resetPasswordParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/home/getWenxunRoom" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//个人资料
+(void)FinanceLiveShow_getPersionDataParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/home/getModuleAndCategory" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_getOL:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/user/getOnlineServicer" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_PayData:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/pay/getPayData" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_tags:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getBuyMarksList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_getad:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/base/getAdv" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_version:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/base/getVersion" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_deleteBlack:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/star/deleteBlack" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_cancelFO:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyprice/cancelBuyPrice" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_GO:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyprice/grabAskOrder" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_cancelGO:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/cancelBuyAsk" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}





+(void)FinanceLiveShow_doneGO:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/confirmBuyAsk" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_addPrice:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/addBuyAskGoodsAmt" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_addPost:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyprice/addCarriageInfo" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_Posts:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/base/getTmsShipperList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_judge:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/evaluateBuyAsk" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_ObjDetail:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getBuyAskSample" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}



+(void)FinanceLiveShow_cancelList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getBuyReasonList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_feedBack:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/base/feedback" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_inCome:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/userAccount/getUserEarnings" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_user:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/user/getUserByUserId" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_address:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/address/selectCrmAddress" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_coupon:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getCrmTicketTakeList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_types:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getBuyTypeList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_addaddress:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/address/addCrmAddress" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_updateAddaddress:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/address/updateCrmAddress" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_addorder:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/addBuyAsk" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_updateorder:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/updateBuyAsk" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_roomSet:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/star/setRoomInfo" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_addOBJ:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyprice/addSamplePicture" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_deladdress:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/address/delCrmAddress" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_defaultaddress:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/address/setDefaultCrmAddress" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_gx:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/user/getFansGXList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_updateUser:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/user/modifyUserInfo" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_real:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/star/approveRealName" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_city:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/area/getAllArea" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_Menu:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/home/getMarketCategory" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_GetOderTypes:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getBuyStatusList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_GetOderList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getBuyAskList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_FindOderList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyprice/getBuyPriceList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_delGO:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/deleteBuyAsk" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_delFO:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyprice/deleteBuyPrice" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_beF:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/user/becomeLookingMan" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_reGO:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/republicBuyAsk" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_shunfeng:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/buyask/getTraceUrl" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_doneGOADD:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/buyask/confirmTakeDelivery" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_MenuRooms:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/home/getRoomList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}




+(void)FinanceLiveShow_getHotSearch:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/room/getSearchKey" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}



//更新个人资料
+(void)FinanceLiveShow_updatePersionDataParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/home/getCategoryRoom" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//发布预告
+(void)FinanceLiveShow_createTrailerParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/trailer/createTrailer" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//粉丝列表
+(void)FinanceLiveShow_getMyFansListParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/attention/getMyFansList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//消息列表
+(void)FinanceLiveShow_getMessagesListParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/getMessagesList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
    
}
//消息批量删除
+(void)FinanceLiveShow_deleteMessagesParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/deleteMessages" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//预告列表
+(void)FinanceLiveShow_getTrailerListParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/trailer/getTrailerList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//预告详情列表
+(void)FinanceLiveShow_getTrailerByIdParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/trailer/getTrailerById" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//预告批量处理
+(void)FinanceLiveShow_subscribeTrailerParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/trailer/subscribeTrailer" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//删除预告(自己)
+(void)FinanceLiveShow_deleteTrailerParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/trailer/deleteTrailer" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//删除订阅预告
+(void)FinanceLiveShow_cancelSubscribeParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/trailer/cancelSubscribe" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取个人主页(暂时)
+(void)FinanceLiveShow_getComperePersonalDataParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/getComperePersonalData" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//绑定账号列表
+(void)FinanceLiveShow_bindAccountListParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/bindAccountList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//绑定手机号码
+(void)FinanceLiveShow_bindMobileParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/bindMobile" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//解绑
+(void)FinanceLiveShow_unbundlingParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/unbundling" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//绑定第三方账号
+(void)FinanceLiveShow_bindAccountParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/bindAccount" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//修改密码
+(void)FinanceLiveShow_updatePasswordParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/updatePassword" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

////获取版本号
//+(void)FinanceLiveShow_getVersionMessageParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
//
//    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/AnyChatFinanceLive/v1/user/getVersionMessage" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
//}
//校验版本号
+(void)FinanceLiveShow_getVersionMessageParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

        [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/system/getVersionMessage" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取图片上传路径
+(void)FinanceLiveShow_getGenerateSignParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/v1/system/getGenerateSign" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//发布话题
+(void)FinanceLiveShow_createTopicParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/topic/createTopic" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//批量删除话题
+(void)FinanceLiveShow_deleteTopicParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/topic/deleteTopic" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//预定预告人员列表
+(void)FinanceLiveShow_getSubscribeUserParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/trailer/getSubscribeUser" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//退出登录
+(void)FinanceLiveShow_logoutParam:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/logout" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//账户状态控制(冻结/解冻)
+(void)FinanceLiveShow_accountControl:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/accountControl" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//获取场控列表
+(void)FinanceLiveShow_getMyControlFieldUserList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/getMyControlFieldUserList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//设置场控
+(void)FinanceLiveShow_setUpControlFieldUser:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/setUpControlFieldUser" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//场控搜索
+(void)FinanceLiveShow_searchControlFieldUser:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/searchControlFieldUser" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//获取黑名单列表
+(void)FinanceLiveShow_getBlackList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/getBlackList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//添加黑名单列表
+(void)FinanceLiveShow_addUserBlackList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/addUserBlackList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//移出黑名单
+(void)FinanceLiveShow_removeUserBlackList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/removeUserBlackList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取标签列表
+(void)FinanceLiveShow_getTagList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/getTagList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//实名认证
+(void)FinanceLiveShow_realNameAuthentication:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock {
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/realNameAuthentication" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//专业认证
+(void)FinanceLiveShow_professionalCertification:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock {
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/professionalCertification" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

#pragma mark 关注接口
+(void)FinanceLiveShow_addAttention:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/userfollow/follow" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_delAttention:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/userfollow/unFollow" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
#pragma mark 直播界面,创建直播界面网络数据
+(void)FinanceLiveShow_getLiveCoverList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/getLiveCoverList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_getLiveContentType:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/v1/index/getLiveContentType" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_removeLiveCover:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/removeLiveCover" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_createLive:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/createLive" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_inviteFriends:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/inviteFriends" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}


+(void)FinanceLiveShow_getLiveUserList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/getLiveUserList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_getMickList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/getMickList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_getControlFieldUserList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/getControlFieldUserList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_getAudiencePersonalData:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/getAudiencePersonalData" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_getComperePersonalData:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/getComperePersonalData" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_getGiftList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/gift/getGiftList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_mallInfo:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/room/getCompanyInfo" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_help:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/room/getLiveSkipList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_manage:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/manage" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_report:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/api/login.php" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_controlMic:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/controlMic" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_finishLive:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/finishLive" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_getLiveDataByLiveId:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/getLiveDataByLiveId" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_prase:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/prase" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_giveGift:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/gift/sendGift" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
+(void)FinanceLiveShow_requestMic:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/requestMic" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_enterLiveActivity:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock
{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/star/startLive" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
/**直播界面,观众离开直播 */
+(void)FinanceLiveShow_leaveLiveActivity:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock {
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/star/stopLive" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
/**直播界面,获取等级 */
+(void)FinanceLiveShow_myGrades:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock {
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/user/myGrades" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//通过透明通道的文字消息
+(void)FinanceLiveShow_sendTextMessages:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/sendTextMessages" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//直播界面,获取anyChat配置信息
+(void)FinanceLiveShow_getConfigureIp:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock {
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/system/getConfigureIp" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
/**直播界面,主播获取房间是否存在信息 */
+(void)FinanceLiveShow_getLiveActivityStatus:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/live/getLiveActivityStatus" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
#pragma mark --首页
//首页广告滚动视图
+(void)FinanceLiveShow_getBannerList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/getBannerList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//首页数据
+(void)FinanceLiveShow_getHomePage:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/getHomePage" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//搜索数据
+(void)FinanceLiveShow_search:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/room/searchRoom" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_privateList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/message/getChatRplyUserList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

+(void)FinanceLiveShow_his:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/room/getInRoomHisList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//未读消息数
+(void)FinanceLiveShow_getUnreadMessageNumbers:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/getUnreadMessageNumbers" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//内容分类
+(void)FinanceLiveShow_getContentType:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/v1/index/getLiveContentType" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//根据内容分类id获取列表

+(void)FinanceLiveShow_getListByTypeId:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/getListByTypeId" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

#pragma mark = 首页二期
//获取首页数据
+(void)FinanceLiveShow_LZLGetHomePage:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/getHomePage" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取直播、预告分类
+(void)FinanceLiveShow_LZLGetLiveNoticeContentType:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/v1/index/getLiveContentType" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//根据内容分类id获取列表
+(void)FinanceLiveShow_LZLGetListByTypeId:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/getHomePage" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取排行榜分类
+(void)FinanceLiveShow_LZLGetRankType:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypeGet withUrlString:@"/v1/rank/getRankingType" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//根据排行榜分类id获取列表
+(void)FinanceLiveShow_LZLGetRankingListByTypeId:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/rank/getRankingList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取历史搜索记录
+(void)FinanceLiveShow_LZLGetMySearchHistoryList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/getMySearchHistoryList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取热门搜索记录
+(void)FinanceLiveShow_LZLGetHotSearchList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/getHotSearchList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取搜索数据
+(void)FinanceLiveShow_LZLSearch:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/index/search" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//根据预告id获取评论列表
+(void)FinanceLiveShow_LZLGetCommentListByTrailerId:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/comment/getCommentListByTrailerId" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//发表评论
+(void)FinanceLiveShow_LZLCreateComment:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/comment/createComment" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
#pragma mark --关注

//关注
+(void)FinanceLiveShow_getAttentionList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/attention/getAttentionList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

#pragma mark --话题
//根据分类id获取话题列表
+(void)FinanceLiveShow_getTopicList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/topic/getTopicList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//获取话题列表
+(void)FinanceLiveShow_getMyTopicList:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/topic/getMyTopicList" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//根据话题id获取话题信息
+(void)FinanceLiveShow_getTopicById:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/topic/getTopicById" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//回复话题
+(void)FinanceLiveShow_replyTopic:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{

    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/topic/replyTopic" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//话题点赞
+(void)FinanceLiveShow_topicClickLike:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/topic/topicClickLike" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}

//举报
+(void)FinanceLiveShow_reportTopicResponse:(id)param withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    [BAIRUITECH_NetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"/v1/topic/reportTopicResponse" withParaments:param withSuccessBlock:successBlock withFailureBlock:failureBlock progress:nil];
}
//app 上传日志接口
+(void)FinanceLiveShow_uploadLogs:(id)param withLogData:(NSData *)logData withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    //文件名
    BAIRUITECH_BRAccount * account = [BAIRUITECH_BRAccoutTool account];
    int userId = [account.userId intValue];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [timeFormatter stringFromDate:currentDate];
    NSString *fileName = [NSString stringWithFormat:@"iOS%@ID%d.txt",timeString,userId];
    //完整的上传url
    NSString *urlString = [NSString stringWithFormat:@"%@/v1/system/uploadLogs",BaseURL];
    [[BAIRUITECH_NetWorkManager shareManager] POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        [formData appendPartWithFileData:logData name:@"file" fileName:fileName mimeType:@"text/plain"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
        int errorCode = [responseObject[@"errorCode"] intValue];
        if (errorCode != 0) {//如果服务器返回了错误码
            
            NSString *fullUrlString = [NSString stringWithFormat:@"%@%@",BaseURL,urlString];
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss SS"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            NSString *message = responseObject[@"message"];
            NSString *logString = [NSString stringWithFormat:@"%@ %@ param:%@ message:%@",dateString,fullUrlString,param,message];
//            [BAIRUITECH_Utils saveLogWithLogString:logString];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

+(void)FinanceLiveShow_uploadPic:(id)param withFullUrlString:(NSString *)fullUrlString withImageData:(NSData *)ImageData withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,fullUrlString];
    
    [[BAIRUITECH_NetWorkManager shareManager] POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        [formData appendPartWithFileData:ImageData name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

+(void)FinanceLiveShow_uploadVoice:(id)param withFullUrlString:(NSString *)fullUrlString withImageData:(NSData *)ImageData withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,fullUrlString];
    
    [[BAIRUITECH_NetWorkManager shareManager] POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        [formData appendPartWithFileData:ImageData name:@"file" fileName:@"voice.amr" mimeType:@"audio/amr"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}



@end
