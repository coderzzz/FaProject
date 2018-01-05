//
//  AudienceSendGiftView.h
//  FinanceLiveShow
//
//  Created by Mac on 16/9/2.
//  Copyright © 2016年 严军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAIRUITECH_GiftListModel.h"
//#import "BAIRUITECH_AudienceCellModel.h"

@interface BAIRUITECH_AudienceSendGiftView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *audienceImageView;
@property (weak, nonatomic) IBOutlet UILabel *audienceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *wealthLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;



@property (strong, nonatomic) BAIRUITECH_GiftListModel *giftModel;
//@property (strong, nonatomic) BAIRUITECH_AudienceCellModel *audienceModel;
@property (assign, nonatomic) int giftCount;
@end
