//
//  FabricSocket.h
//  MiaowShow
//
//  Created by bairuitech on 2017/9/1.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class FabricSocket;
//@protocol FabricSocketDelegate <NSObject>
//
//@optional
//
////#pragma mark - SRWebScokerDelegate
////-(void)fbSocket:(FabricSocket *)fbSocket didReceiveMessage:(NSDictionary *)message;
////-(void)fbSocketDidOpen:(FabricSocket *)fbSocket;
////-(void)fbSocket:(FabricSocket *)fbSocket didFailWithError:(NSError *)error;
////-(void)fbSocket:(FabricSocket *)fbSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
//@end

@interface FabricSocket : NSObject


//@property (nonatomic, weak) id<FabricSocketDelegate>delegate;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *token;


@property (nonatomic, strong) NSMutableArray *messages;
//@property (nonatomic, copy) NSString *roomId;
//@property (nonatomic, copy) NSString *receiverId;

+(instancetype)shareInstances;

- (void)connect;

- (void)disConnect;

- (void)sendTextMsg:(NSString *)msg targetUserId:(NSString *)userId roomId:(NSString *)roomId;

- (void)sendImage:(NSString *)file targetUserId:(NSString *)userId roomId:(NSString *)roomId;

- (void)sendVoice:(NSString *)file targetUserId:(NSString *)userId roomId:(NSString *)roomId;

- (void)enterRoom:(NSInteger)roomid;
- (void)leaveRoom:(NSInteger)roomid;
- (void)ping;


@end
