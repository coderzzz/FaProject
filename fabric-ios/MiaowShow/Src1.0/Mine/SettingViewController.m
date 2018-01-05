//
//  SettingViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/22.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "BRLoginViewController.h"
#import "BRLoginNavigationController.h"
#import "AppDelegate.h"
#import "FabricWebViewController.h"
@interface SettingViewController ()

@property(nonatomic, strong) NSMutableArray *lives;

@property (assign, nonatomic) int pageN;

@end

static NSString *reuseIdentifier = @"set";

@implementation SettingViewController
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

- (void)setup
{
    
    self.title = @"设置";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *footBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footBtn.backgroundColor = [UIColor whiteColor];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [footBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [footBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableFooterView: footBtn];
    self.lives = @[@[@"登录密码",@"提现密码"],@[@"关于全球面料网"]].mutableCopy;
    
}

- (void)logout{
    
    [BAIRUITECH_BRAccoutTool removeAccount];
    [[FabricSocket shareInstances]disConnect];
    [[FabricSocket shareInstances].messages removeAllObjects];
    BRLoginViewController *vc = [BRLoginViewController new];
    [vc setBlock:^(void){
        
    
    }];
    BRLoginNavigationController *nav = [[BRLoginNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.lives.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [self.lives[section] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    return view;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == _lives.count -1) {
        
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.titleLab.text = self.lives[indexPath.section][indexPath.row];
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        
        NSString *baseUrl;
        if (indexPath.row == 0) {
            
            baseUrl = @"http://wap.fabric.cn/wap/member/updpass.html";
        }
        else{
            
            baseUrl = @"http://wap.fabric.cn/wap/member/present.html";
            
        }
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        
        FabricWebViewController *vc = [[FabricWebViewController alloc]init];
        vc.strUrl = [NSString stringWithFormat:@"%@?userId=%@&token=%@",baseUrl,user.userId,user.token];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    if (indexPath.section ==1) {
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];  
//    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        FabricWebViewController *vc = [[FabricWebViewController alloc]init];
        vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/member/aboutyf.html?userId=%@&token=%@",user.userId,user.token];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
