//
//  AudienceSendGiftView.m
//  FinanceLiveShow
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 严军. All rights reserved.
//

#import "BAIRUITECH_AudienceSendGiftView.h"
#import "UIImageView+WebCache.h"

@implementation BAIRUITECH_AudienceSendGiftView
-(void)awakeFromNib {
    [super awakeFromNib];
    self.audienceImageView.layer.cornerRadius = 22;
    self.audienceImageView.layer.masksToBounds = YES;
    self.backgroundImageView.layer.cornerRadius = 25;
    self.backgroundImageView.layer.masksToBounds = YES;
}
-(void)setGiftModel:(BAIRUITECH_GiftListModel *)giftModel {
    _giftModel = giftModel;

    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.swf] placeholderImage:[UIImage imageNamed:@"AnyChatSDKResources.bundle/直播/live链接"]];
    self.wealthLabel.text = [NSString stringWithFormat:@"+%@",@"100"];
    self.giftNameLabel.text = [NSString stringWithFormat:@"送了一个%@",giftModel.name];
}
//-(void)setAudienceModel:(BAIRUITECH_AudienceCellModel *)audienceModel {
//    _audienceModel = audienceModel;
//    if ([audienceModel.photo isKindOfClass:[NSNull class]]) {
//        audienceModel.photo = @"";
//    }
//    [self.audienceImageView sd_setImageWithURL:[NSURL URLWithString:audienceModel.photo] placeholderImage:[UIImage imageNamed:@"AnyChatSDKResources.bundle/占位图/讲师加载"]];
//    self.audienceNameLabel.text = audienceModel.nickName;
//}
-(void)setGiftCount:(int )giftCount {
    _giftCount = giftCount;
    if (giftCount < 1) {
        giftCount = 1;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"X%d",giftCount];
}
@end
