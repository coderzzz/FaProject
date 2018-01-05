//
//  FabricSocket.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/1.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "FabricSocket.h"
#import "SRWebSocket.h"

#define CONNECT    101
#define DISCONNECT 102
#define HEART      401
#define GIFT       501
#define MESSAGE    601


@interface FabricSocket()<SRWebSocketDelegate>
{
    SRWebSocket * webSocket;
    NSTimer * heartBeat;
    NSTimeInterval reConnecTime;
    BOOL disConnect;
}
@end
@implementation FabricSocket

+(instancetype)shareInstances{
    
    static FabricSocket *socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        socket = [[FabricSocket alloc]init];
    
    });
    return socket;
}

- (id)init{
    
    self = [super init];
    _messages = @[].mutableCopy;
    return self;
}

- (void)connect{
    
    if (webSocket) {
        return;
    }
    webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@&token=%@",self.host,self.userId,self.token]]];
    webSocket.delegate=self;
    //  设置代理线程queue
    NSOperationQueue * queue=[[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount=1;
    [webSocket setDelegateOperationQueue:queue];
    
    //  连接
    [webSocket open];
}



//   初始化心跳
-(void)initHearBeat
{
    //    dispatch_main_async_safe(^{
    //        [self destoryHeartBeat];
    //
    //        __weak typeof (self) weakSelf=self;
    //        //心跳设置为3分钟，NAT超时一般为5分钟
    //        heartBeat=[NSTimer scheduledTimerWithTimeInterval:3*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //            NSLog(@"heart");
    //            //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
    //            [weakSelf sendMsg:@"heart"];
    //        }];
    //        [[NSRunLoop currentRunLoop] addTimer:heartBeat forMode:NSRunLoopCommonModes];
    //    })
}
//   取消心跳
-(void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (heartBeat) {
            [heartBeat invalidate];
            heartBeat=nil;
        }
    })
}

//   断开连接
-(void)disConnect
{
    if (webSocket) {
        
        disConnect = YES;
        [self sendMsgWithCmd:DISCONNECT content:nil targetId:nil roomId:nil type:@0];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [webSocket close];
            webSocket=nil;
        });
        
        
    }
}

- (void)sendTextMsg:(NSString *)msg targetUserId:(NSString *)userId roomId:(NSString *)roomId{
    
    [self sendMsgWithCmd:MESSAGE content:msg targetId:userId roomId:roomId type:@1];
}

- (void)sendImage:(NSString *)file targetUserId:(NSString *)userId roomId:(NSString *)roomId{
    
    [self sendMsgWithCmd:MESSAGE content:file targetId:userId roomId:roomId type:@2];
}
- (void)sendVoice:(NSString *)file targetUserId:(NSString *)userId roomId:(NSString *)roomId{
    
    [self sendMsgWithCmd:MESSAGE content:file targetId:userId roomId:roomId type:@3];
}

- (void)enterRoom:(NSInteger)roomid{
    
    [self sendMsgWithCmd:CONNECT content:@"" targetId:nil roomId:[NSString stringWithFormat:@"%ld",(long)roomid] type:@0];
}

- (void)leaveRoom:(NSInteger)roomid{
    
    [self sendMsgWithCmd:DISCONNECT content:@"" targetId:nil roomId:[NSString stringWithFormat:@"%ld",(long)roomid] type:@0];
}

- (void)sendMsgWithCmd:(int)cmd content:(NSString *)content targetId:(NSString *)targetId roomId:(NSString *)roomId type:(NSNumber *)type{
    
    NSDictionary *dic=@{@"cmd":@(cmd),
                          @"roomid":roomId?roomId:@"0",
                          @"globalId":@"",
                          @"rpt":@"1",
                          @"receiverid":targetId?targetId:@"0",
                          @"type":type,
                          @"senderid":self.userId,
                          @"content":content?content:@"",
                          @"time":@""};
    NSString *str = [self DataTOjsonString:dic];
    [self sendMsg:str];
}

//   发送消息
-(void)sendMsg:(NSString *)msg
{
    NSLog(@"sendMsg:%@",msg);

    [webSocket send:msg];
}
//  重连机制
-(void)reConnect
{
//    [self disConnect];
    
    //  超过一分钟就不再重连   之后重连5次  2^5=64
    if (reConnecTime>64) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnecTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        webSocket=nil;
        [self connect];
    });
    
    //   重连时间2的指数级增长
    if (reConnecTime == 0) {
        reConnecTime =2;
    }else{
        reConnecTime *=2;
    }
}
// pingpong
-(void)ping{
    [webSocket sendPing:nil];
}
#pragma mark - SRWebScokerDelegate
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"服务器返回的信息:%@",message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dic  = [self dictionaryWithJsonString:message];
        if (!dic) return;
        NSString *cmd = [NSString stringWithFormat:@"%@",dic[@"cmd"]];
        NSString *recv = [NSString stringWithFormat:@"%@",dic[@"receiverid"]];
        NSString *senderid = [NSString stringWithFormat:@"%@",dic[@"senderid"]];
        int type = [[NSString stringWithFormat:@"%@",dic[@"type"]] intValue];
        
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        if ([user.userId isEqualToString:senderid] && type >1) {
            
        }else{
            
            if ([cmd isEqualToString:@"601"] && recv.length>0) {
                
                [self.messages addObject:dic];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"FSDidReceiveMessage" object:message];
        }
        
//        if ([cmd isEqualToString:@"601"] && recv.length>0 && type <=1) {
//            
//            [self.messages addObject:dic];
//        }
//        if (type <=1) {
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"FSDidReceiveMessage" object:message];
//        }
        
        
    });
    
    
}
-(void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"连接成功");
    //   连接成功 开始发送心跳
    [self initHearBeat];
    [self sendMsgWithCmd:CONNECT content:nil targetId:nil roomId:@"" type:@0];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(fbSocketDidOpen:)]) {
//        
//        [self.delegate fbSocketDidOpen:self];
//    }
}
//  open失败时调用
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"连接失败。。。。。%@",error);
    //  失败了去重连
    [self reConnect];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(fbSocket:didFailWithError:)]) {
//        
//        [self.delegate fbSocket:self didFailWithError:error];
//    }
}
//  网络连接中断被调用
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    
    NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    
    //如果是被用户自己中断的那么直接断开连接，否则开始重连
    if (disConnect) {
        [self disConnect];
    }else{
        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(fbSocket:didCloseWithCode:reason:wasClean:)]) {
//            
//            [self.delegate fbSocket:self didCloseWithCode:code reason:reason wasClean:wasClean];
//        }
        [self reConnect];
    }
    //断开连接时销毁心跳
    [self destoryHeartBeat];
}
//sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSLog(@"收到pong回调");
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        //  NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
