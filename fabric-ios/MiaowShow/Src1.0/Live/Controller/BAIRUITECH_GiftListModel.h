//
//  GiftListModel.h
//  AnyChatLive
//
//  Created by bairuitech on 16/7/19.
//  Copyright © 2016年 anychat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAIRUITECH_GiftListModel : NSObject

/**
 *  网络请求数据
 */
//礼物id
@property(copy,nonatomic)NSString *id;
//经验值
@property(copy,nonatomic)NSString *swf;
//财富值
@property(assign,nonatomic)int price;
//礼物图片url
@property(copy, nonatomic)NSString * image;
//礼物名称
@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *categoryName;


//是否被选中
@property(assign,nonatomic)BOOL isSelected;

+(BAIRUITECH_GiftListModel *)giftListModelWithDictionary:(NSDictionary *)dictionary;



@end
