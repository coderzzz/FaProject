//
//  GiftListCollectionViewCell.m
//  AnyChatLive
//
//  Created by bairuitech on 16/7/19.
//  Copyright © 2016年 anychat. All rights reserved.
//

#import "BAIRUITECH_GiftListCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@implementation BAIRUITECH_GiftListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.giftImageView.image = [UIImage imageNamed:@"AnyChatSDKResources.bundle/直播/live微信"];
    self.selectImageView.image = [UIImage imageNamed:@"live选中礼物效果"];
}
-(void)setCellWithModel:(BAIRUITECH_GiftListModel *)model{

    NSURL * url = [NSURL URLWithString:model.image];
    [self.giftImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"live礼物按钮"]];
    self.giftWealthLabel.text = @"免费";
    self.giftNameLabel.text = model.name;
    if (model.isSelected) {
        self.selectImageView.hidden = NO;
    }
    else{
        self.selectImageView.hidden = YES;
    }
}
@end
