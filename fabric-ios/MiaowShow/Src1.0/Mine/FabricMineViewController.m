 //
//  FabricMineViewController.m
//  FabricNew
//
//  Created by 严军 on 2017/8/20.
//  Copyright © 2017年 严军. All rights reserved.
//

#import "FabricMineViewController.h"
#import "BRLoginViewController.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "MainHeadViewCell.h"
#import "MainContentCell.h"
#import "MyFansViewController.h"
#import "MyFollowViewController.h"
#import "FeedBackViewController.h"
#import "InComeViewController.h"
#import "SettingViewController.h"
#import "GXViewController.h"
#import "PersonCenterViewController.h"
#import "FabricWebViewController.h"
#import "RealNameViewController.h"
#import "BRLoginNavigationController.h"
@interface FabricMineViewController ()

@property(nonatomic, strong) NSMutableArray *lives;
@property(nonatomic, strong) NSMutableArray *info;
@end

static NSString *reuseIdentifier = @"content";
static NSString *HeadeuseIdentifier = @"mainHeadViewCell";
@implementation FabricMineViewController
- (NSMutableArray *)lives
{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadUserInfo];
    [self.tableView reloadData];
}

- (void)setup
{
    self.navigationItem.title = @"我的";
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:17],
    NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MainContentCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MainHeadViewCell class]) bundle:nil] forCellReuseIdentifier:
     HeadeuseIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lives = @[@[@"锦豆",@"收益",@"我的账单",@"我的店铺"],@[@"粉丝贡献榜",@"直播认证"],@[@"意见反馈",@"设置"]].mutableCopy;
    
}

- (void)loadUserInfo{
    
   // [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_user:@{@"userId":user.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        
     //   [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            _info = [NSMutableArray array];
            [_info addObject:[NSString stringWithFormat:@"%@",object[@"data"][@"followCount"]]];
            [_info addObject:[NSString stringWithFormat:@"%@",object[@"data"][@"fansCount"]]];
            [self.tableView reloadData];
            
            
        }else{
            
            _info = @[@"0",@"0"].mutableCopy;
            [self.tableView reloadData];
        }
        
    } withFailureBlock:^(NSError *error) {
        
     //   [self showHint:error.description];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.lives.count+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }
    return [self.lives[section-1]count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        return 102;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        MainHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeadeuseIdentifier];
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        cell.nameLab.text = user.nickName?user.nickName:@"未登陆";
        NSString *logo;
        if (![user.userLogo hasPrefix:@"htt"]) {
            logo = [NSString stringWithFormat:@"%@%@",ImageURL,user.userLogo];
        }else{
            logo = user.userLogo;
        }
        [cell.headImgv sd_setImageWithURL:[NSURL URLWithString:logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]];
        
        if (_info.count ==2) {
            
            [cell.followBtn setTitle:[NSString stringWithFormat:@"关注 %@",_info[0]] forState:UIControlStateNormal];
            [cell.fansBtn setTitle:[NSString stringWithFormat:@"粉丝 %@",_info[1]] forState:UIControlStateNormal];
        }
        
        [cell setBtnAction:^(NSInteger tag){
            
            if (tag == 0) {
                
                MyFollowViewController *vc = [[MyFollowViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                
                MyFansViewController *vc = [[MyFansViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
        return cell;
    }else{
        
        MainContentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        NSString *name = self.lives[indexPath.section-1][indexPath.row];
        [cell.imgV setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        cell.lab.text = name;
        return cell;
    }

}
- (BOOL)isLogin{
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    if ([user.userId isEqualToString:@"0"]) {
        
        return NO;
    }
    return YES;
}

- (void)showLogin{
    
    BRLoginViewController *vc = [BRLoginViewController new];
//    [vc setBlock:^(void){
//        
////        [self setUpSocket];
//    }];
    
    BRLoginNavigationController *nav = [[BRLoginNavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self isLogin]) {
        
        [self showLogin];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        PersonCenterViewController *vc = [[PersonCenterViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        
        FeedBackViewController *vc = [[FeedBackViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 3 && indexPath.row == 1) {
        
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        
        RealNameViewController *vc = [[RealNameViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"实名认证";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1 ) {
        
        
        
        NSString *url;
        if (indexPath.row == 0) {
            
            url =@"http://wap.fabric.cn/wap/fmsBusi/beans-recharge.html";
        }
        else if (indexPath.row == 1){
            
            url =@"http://wap.fabric.cn/wap/fmsBusi/profit.html";
        }
        else if (indexPath.row == 2){
            
            url =@"http://wap.fabric.cn/wap/fmsBusi/jinBeans.html";
        }else{
            
            
            url =@"http://wap.fabric.cn/wap/shop.html";
        }
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        
        FabricWebViewController *vc = [[FabricWebViewController alloc]init];
        if (indexPath.row==3) {
            
            vc.strUrl = [NSString stringWithFormat:@"%@?id=%@&userId=%@&token=%@",url,user.userId,user.userId,user.token];
        }else{
            vc.strUrl = [NSString stringWithFormat:@"%@?userId=%@&token=%@",url,user.userId,user.token];
        }
        
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        GXViewController *vc = [[GXViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
