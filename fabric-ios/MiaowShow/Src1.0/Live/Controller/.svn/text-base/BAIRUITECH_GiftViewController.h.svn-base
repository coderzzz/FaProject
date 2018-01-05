//
//  GiftViewController.h
//  AnyChatLive
//
//  Created by bairuitech on 16/7/19.
//  Copyright © 2016年 anychat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAIRUITECH_GiftListModel.h"

@protocol BAIRUITECH_giftViewControllerDelegate <NSObject>

-(void)giftViewController:(UIViewController *) giftVC gift:(BAIRUITECH_GiftListModel *)model;
-(void)giftViewController:(UIViewController *) giftVC didClickExitButton:(UIButton *)exitButton;
-(void)giftViewController:(UIViewController *) giftVC didClickPayButton:(UIButton *)exitButton;
@end

@interface BAIRUITECH_GiftViewController : UIViewController
//礼物数据源数组
@property (nonatomic, strong) NSMutableArray   *giftListArray;
//礼物id
@property(assign,nonatomic)int giftId;
//礼物数量
@property(assign,nonatomic)int giftCount;
//财富值
@property(assign,nonatomic)int wealth;

@property(weak, nonatomic)id <BAIRUITECH_giftViewControllerDelegate> delegate;

@end
