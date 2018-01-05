//
//  ALinHotViewController.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ALinHotViewController.h"
#import "ALinLive.h"
//#import "ALinRefreshGifHeader.h"
#import "ALinHotLiveCell.h"
//#import "ALinTopAD.h"
//#import "ALinHomeADCell.h"
//#import "ALinWebViewController.h"
//#import "ALinLiveCollectionViewController.h"

#import "MyFollowViewController.h"


#import "SystemMsgViewController.h"
#import "BlackListViewController.h"
@interface ALinHotViewController ()

@property(nonatomic, strong) NSMutableArray *lives;
@property (nonatomic, strong) NSArray *urls;
@end

static NSString *reuseIdentifier = @"ALinHotLiveCell";
//static NSString *ADReuseIdentifier = @"ALinHomeADCell";
@implementation ALinHotViewController
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ALinHotLiveCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
//    [self.tableView registerClass:[ALinHomeADCell class] forCellReuseIdentifier:ADReuseIdentifier];
//    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 49);

//    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.urls = @[@[@""],@[]];
    self.lives = @[@[@"系统消息"],@[@"我的关注",@"小二消息",@"在线客服",@"黑名单"]].mutableCopy;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.lives.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.lives[section]count];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ALinHotLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.imageView.image = [UIImage imageNamed:self.lives[indexPath.section][indexPath.row]];
    cell.lab.text = self.lives[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1 && indexPath.row ==3) {
        
        BlackListViewController *vc = [[BlackListViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row ==0) {
        
        MyFollowViewController *vc = [[MyFollowViewController alloc]init];
        vc.title = @"我的关注";
        vc.type = TypeFollow;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row ==1) {
        
        MyFollowViewController *vc = [[MyFollowViewController alloc]init];
        vc.title = @"小二";
        vc.type = TypeHelp;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row ==2) {
        
        MyFollowViewController *vc = [[MyFollowViewController alloc]init];
        vc.title = @"客服";
        vc.type = TypeAgent;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    SystemMsgViewController *vc = [[SystemMsgViewController alloc]init];
    vc.title = self.lives[indexPath.section][indexPath.row];
    vc.type = [NSString stringWithFormat:@"%ld",11 + indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

@end
