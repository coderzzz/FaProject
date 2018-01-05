//
//  BRAccount.m
//  SuperIntercom
//
//  Created by Mac on 16/4/21.
//  Copyright © 2016年 AnyChat. All rights reserved.
//

#import "BAIRUITECH_BRAccount.h"

@interface BAIRUITECH_BRAccount()<NSCoding>

@end

@implementation BAIRUITECH_BRAccount


//
////token
//@property (nonatomic,copy) NSString *usersession;
////会员积分
//@property (nonatomic,copy) NSString *scores;
////id
//@property (nonatomic,strong) NSNumber *userId;
////会员等级
//@property (nonatomic,copy) NSString *level;
////昵称
//@property (nonatomic,copy) NSString *userName;
////所下订单数
//@property (nonatomic,copy) NSString *ordercount;



- (instancetype )initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.userLogo = [dict objectForKey:@"userLogo"];
        
        self.userId = [dict objectForKey:@"userId"];
        
        self.nickName = [dict objectForKey:@"nickName"];
        
        self.token = [dict objectForKey:@"token"];
        
        self.phone =[dict objectForKey:@"phone"];
        
        self.isIdValid =[dict objectForKey:@"isIdValid"];
        self.chatAddress = [dict objectForKey:@"chatAddress"];
        
    }
    return self;
}

+ (instancetype )accountWithDictionary:(NSDictionary *)dict{
    return [[BAIRUITECH_BRAccount alloc] initWithDictionary:dict];
}

/**
 *  从文件中解析对象的时候调用
 *
 */
- (id)initWithCoder:(NSCoder *)decode
{
    if (self = [super init]) {
        
        
        
        self.userLogo = [decode decodeObjectForKey:@"userLogo"];
        self.chatAddress =[decode decodeObjectForKey:@"chatAddress"];
        
        self.userId = [NSString stringWithFormat:@"%@",[decode decodeObjectForKey:@"userId"]];
        
        
        self.nickName = [decode decodeObjectForKey:@"nickName"];
        
        self.token = [decode decodeObjectForKey:@"token"];
        
        self.phone = [decode decodeObjectForKey:@"phone"];
        
        self.isIdValid = [decode decodeObjectForKey:@"isIdValid"];
        
//        self.userId = [decode decodeObjectForKey:@"userId"];
//        self.token = [decode decodeObjectForKey:@"token"];
//        self.nickName = [decode decodeObjectForKey:@"nickName"];
//        self.mobilePhone = [decode decodeObjectForKey:@"mobilePhone"];
//        self.photo = [decode decodeObjectForKey:@"photo"];
//        self.account = [decode decodeObjectForKey:@"account"];
//        self.perfectInformation = [decode decodeObjectForKey:@"perfectInformation"];
    }
    return self;
}

/**
 *  将对象写入到文件的时候调用
 *
 */
- (void)encodeWithCoder:(NSCoder *)encode
{
    
//    [encode encodeObject:self.userId forKey:@"userId"];
//    [encode encodeObject:self.token forKey:@"token"];
//    [encode encodeObject:self.nickName forKey:@"nickName"];
//    [encode encodeObject:self.mobilePhone forKey:@"mobilePhone"];
//    [encode encodeObject:self.photo forKey:@"photo"];
//    [encode encodeObject:self.account forKey:@"account"];
//    [encode encodeObject:self.perfectInformation forKey:@"perfectInformation"];
    
    [encode encodeObject:self.userLogo forKey:@"userLogo"];
     [encode encodeObject:self.chatAddress forKey:@"chatAddress"];
    [encode encodeObject:self.userId forKey:@"userId"];
    [encode encodeObject:self.nickName forKey:@"nickName"];
    
    [encode encodeObject:self.token forKey:@"token"];
    [encode encodeObject:self.phone forKey:@"phone"];
    [encode encodeObject:self.isIdValid forKey:@"isIdValid"];
}



@end
