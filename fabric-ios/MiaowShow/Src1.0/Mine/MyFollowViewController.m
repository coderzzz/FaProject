//
//  MyFollowViewController.m
//  MiaowShow
//
//  Created by sam on 2017/9/17.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MyFollowViewController.h"
#import "FansCell.h"
#import "PopoverModel.h"
#import "UIButton+WebCache.h"
#import "EaseMessageViewController.h"
@interface MyFollowViewController ()

@property(nonatomic, strong) NSMutableArray *lives;

@property (assign, nonatomic) int pageN;

@end

static NSString *reuseIdentifier = @"fans";

@implementation MyFollowViewController
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
    
//    self.title = @"关注";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FansCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self firstLoad];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}





- (void)firstLoad{
    
    
    
    _pageN = 1;
    
    self.lives = [NSMutableArray array];
    
    if (self.type == TypeAgent || self.type == TypeHelp) {
        
        [self getAgent];
    }else{
        
        [self getData];
    }
    
    
}

- (void)loadMore{
    
    
    
    _pageN += 1;
    
    if (self.type == TypeAgent || self.type == TypeHelp) {
        
        [self getAgent];
    }else{
        
        [self getData];
    }
}



- (void)getAgent{
    

    
    __weak  typeof(self) weakSelf = self;
    [BAIRUITECH_NetWorkManager FinanceLiveShow_resetPasswordParam:@{@"pageNo":@(_pageN),@"pageSize":@"10"} withSuccessBlock:^(NSDictionary *object) {
        
//        {
//            imgPath = "http://img1.50tu.com/meinv/chemo/2013-11-01/8330df279fdf7d3870cee493969f6b0d.jpg";
//            mainBusiness = "\U7ea4\U7ef4";
//            nickName = "fabric_714860";
//            playStream = "rtmp://10671.liveplay.myqcloud.com/live/10671_239389";
//            roomId = 1012061;
//            roomName = "13632269128\U7684\U623f\U95f4";
//            roomStarLevel = 0;
//            userId = 239389;
//            userLogo = "http://www.sinaimg.cn/lf/sports/logo85/60.png";
//        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
           NSMutableArray *list = [NSMutableArray array];
           NSString *key = self.type==TypeHelp?@"xiaoerRoomList":@"kefuRoomList";
            for (NSDictionary *dic in object[@"data"][key]) {
                
                PopoverModel *model =[PopoverModel new];
                model.nickName = dic[@"nickName"];
                model.userId = [NSString stringWithFormat:@"%@",dic[@"userId"]];
                model.userLogo = dic[@"imgPath"];
                if (model) {
                    [list addObject:model];
                }
            }
            if (list.count>0) {
                
                [self.lives addObjectsFromArray:list];
                [self.tableView reloadData];
                
            }else{
                
                [BAIRUITECH_BRTipView showTipTitle:@"暂无信息" delay:1.5];
            }
            
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)getData{
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_fans:@{@"userId":user.userId,@"pageNo":@(_pageN),@"pageSize":@"10"} withSuccessBlock:^(NSDictionary *object) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if([object[@"ret"] intValue] == 0){
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in object[@"data"][@"users"]) {
                
                PopoverModel *model =[PopoverModel mj_objectWithKeyValues:dic];
                if (model) {
                    [list addObject:model];
                }
            }
            if (list.count>0) {
                
                [self.lives addObjectsFromArray:list];
                [self.tableView reloadData];
                
            }else{
                
                [BAIRUITECH_BRTipView showTipTitle:@"暂无信息" delay:1.5];
            }
            
            
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.lives.count;
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
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FansCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    PopoverModel *item = self.lives[indexPath.row];
//    [cell.imagV sd_setImageWithURL:[NSURL URLWithString:item.userLogo] forState:UIControlStateNormal];
    [cell.imagV sd_setImageWithURL:[NSURL URLWithString:item.userLogo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像-1"]];
    cell.lab.text = item.nickName;
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PopoverModel *item = self.lives[indexPath.row];
    EaseMessageViewController *chatVC =[[EaseMessageViewController alloc]initWithConversationChatter:@""];
    chatVC.toUserId = item.userId;
    chatVC.title = item.nickName;
//    chatVC.showRefreshHeader = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}

@end
