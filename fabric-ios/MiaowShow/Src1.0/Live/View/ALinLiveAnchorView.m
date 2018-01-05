//
//  ALinLiveAnchorView.m
//  MiaowShow
//
//  Created by ALin on 16/6/16.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ALinLiveAnchorView.h"
#import "ALinLive.h"
#import "ALinUser.h"
//#import "UIImage+ALinExtension.h"
#import <UIImageView+WebCache.h>

@interface ALinLiveAnchorView()
@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UIButton *usersBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *peoplesScrollView;
@property (weak, nonatomic) IBOutlet UIButton *giftView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *chaoYangUsers;
@end

@implementation ALinLiveAnchorView

//- (NSArray *)chaoYangUsers
//{
//    if (!_chaoYangUsers) {
//        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]];
//        _chaoYangUsers = [ALinUser mj_objectArrayWithKeyValuesArray:array];
//    }
//    return _chaoYangUsers;
//}

+ (instancetype)liveAnchorView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.peoplesScrollView.hidden = YES;
    [self maskViewToBounds:self.anchorView];
    [self maskViewToBounds:self.headImageView];
    [self maskViewToBounds:self.careBtn];
    [self maskViewToBounds:self.giftView];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.giftView.backgroundColor = MainColor;
    
//    [self.careBtn setBackgroundImage:[UIImage imageWithColor:MainColor size:self.careBtn.size] forState:UIControlStateNormal];
//    [self.careBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.careBtn.size] forState:UIControlStateSelected];
    
    
    
    
    
    // 默认是关闭的
    [self Device:self.careBtn];
}


- (void)getUserList{
    
    __weak  typeof(self) weakSelf = self;
    [BAIRUITECH_NetWorkManager FinanceLiveShow_users:@{@"roomId":@(self.live.roomId)} withSuccessBlock:^(NSDictionary *object) {
        

        if([object[@"ret"] intValue] == 0){
            
            
            _chaoYangUsers = [ALinUser mj_objectArrayWithKeyValuesArray:object[@"data"][@"viewers"]];
            [_usersBtn setTitle:[NSString stringWithFormat:@"%@",object[@"data"][@"count"]] forState:UIControlStateNormal];
            [weakSelf setupChangeyang];
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
//        YJLog(@"%@",error);
        
    }];

}

- (void)getfans{
    
//    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
//    [BAIRUITECH_NetWorkManager FinanceLiveShow_follow:@{@"followUserId":user.userId,@"pageNo":@(1),@"pageSize":@"10"} withSuccessBlock:^(NSDictionary *object) {
//        
//
//        if([object[@"ret"] intValue] == 0){
//            
//            self.peopleLabel.text = [NSString stringWithFormat:@"粉丝：%@",object[@"data"][@"count"]];
//        }else{
//            
//                   }
//        
//    } withFailureBlock:^(NSError *error) {
//        
//        
//    }];
    
}

- (void)maskViewToBounds:(UIView *)view
{
    view.layer.cornerRadius = view.height * 0.5;
    view.layer.masksToBounds = YES;
}

static int randomNum = 0;
- (void)setLive:(LiveUserModel *)live
{
    _live = live;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:live.userLogo] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nameLabel.text = live.nickName;
//    self.peopleLabel.text = [NSString stringWithFormat:@"粉丝：%@",@"100"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNum) userInfo:nil repeats:YES];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChangYang:)]];
    self.careBtn.selected = live.isFollow;
    [self getUserList];
    [self getfans];
}

- (void)updateNum
{
    randomNum += arc4random_uniform(5);
//    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人", self.live.allnum + randomNum];
//    [self.giftView setTitle:[NSString stringWithFormat:@"猫粮:%u  娃娃%u", 1993045 + randomNum,  124593+randomNum] forState:UIControlStateNormal];
}

- (void)setupChangeyang
{
    self.peoplesScrollView.contentSize = CGSizeMake((self.peoplesScrollView.height + 3) * self.chaoYangUsers.count + 3, 0);
    CGFloat width = self.peoplesScrollView.height - 10;
    CGFloat x = 0;
    for (int i = 0; i<self.chaoYangUsers.count; i++) {
        x = 0 + (3 + width) * i;
        UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, width, width)];
        userView.layer.cornerRadius = width * 0.5;
        userView.contentMode = UIViewContentModeScaleAspectFill;
        userView.layer.masksToBounds = YES;
        ALinUser *user = self.chaoYangUsers[i];
        [userView sd_setImageWithURL:[NSURL URLWithString:user.userLogo] placeholderImage:[UIImage imageNamed:@"头像"]];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:user.userLogo] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                userView.image = [UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:1];
            });
        }];
        // 设置监听
        userView.userInteractionEnabled = YES;
        [userView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChangYang:)]];
        userView.tag = i;
        [self.peoplesScrollView addSubview:userView];
    }
    
}

- (void)clickChangYang:(UITapGestureRecognizer *)tapGes
{
    if (tapGes.view == self.headImageView) {
        ALinUser *user = [[ALinUser alloc] init];
        user.nickName = self.live.nickName;
        user.photo = self.live.userLogo;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"user" : user}];
    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"user" : self.chaoYangUsers[tapGes.view.tag]}];
    }
    
}

- (IBAction)enterShop:(id)sender {
    if (self.clickShop) {
        self.clickShop();
    }
}

- (IBAction)Device:(UIButton *)sender {
//    sender.selected = !sender.selected;
    if (self.clickDeviceShow) {
        self.clickDeviceShow(sender);
    }
}

- (IBAction)backAction:(id)sender {
    
    if (self.clickBack) {
        self.clickBack();
    }
}
@end
