//
//  PrivateChatItem.h
//  MiaowShow
//
//  Created by sam on 2017/10/19.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivateChatItem : NSObject

@property (nonatomic, copy) NSString *chatContentType;
@property (nonatomic, copy) NSString *chatType;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userLogo;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *time;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *sysLogo;


@end
