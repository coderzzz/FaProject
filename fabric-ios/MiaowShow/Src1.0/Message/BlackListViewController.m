//
//  BlackListViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/27.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "BlackListViewController.h"
#import "BlackCell.h"

@interface BlackListViewController ()

@property(nonatomic, strong) NSMutableArray *list;
@property (assign, nonatomic) int pageN;
@end

static NSString *reuseIdentifier = @"black";

@implementation BlackListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单列表";
    [self setup];
}

- (void)setup
{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BlackCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    [self.tableView registerClass:[BlackCell class] forCellReuseIdentifier:reuseIdentifier];
    //    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 49);
    
    //    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self firstLoad];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
}


- (void)firstLoad{
    
    
    
    _pageN = 1;
    
    self.list = [NSMutableArray array];
    
    [self getData];
}

- (void)loadMore{
    
    
    
    _pageN += 1;
    
    [self getData];
}

- (void)getData{
    
    __weak  typeof(self) weakSelf = self;
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    NSDictionary *dic = @{@"userId":user.userId,@"pageNo":@(_pageN),@"pageSize":@"10"};
    [BAIRUITECH_NetWorkManager FinanceLiveShow_blackList:dic withSuccessBlock:^(NSDictionary *object) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            [weakSelf.list addObjectsFromArray:[object[@"data"] mutableCopy]];
            [weakSelf.tableView reloadData];
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.list count];
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
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    {"nickName":"杭州集嘉","mainBusiness":"","userLogo":"http://www.sinaimg.cn/lf/sports/logo85/52.png","userId":94499}
    BlackCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    __block NSDictionary *dic = self.list[indexPath.row];
    cell.titleLab.text = dic[@"nickName"];
    cell.sublab.text =  dic[@"mainBusiness"];
    [cell.logo sd_setImageWithURL:[NSURL URLWithString:dic[@"userLogo"]] placeholderImage:nil];
    [cell setClick:^{
        
        [self removeBlack:dic];
    }];
    return cell;
}

- (void)removeBlack:(NSDictionary *)dic{
    
    
    [self showHudInView:self.view];
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    NSString *blackId = [NSString stringWithFormat:@"%@",dic[@"userId"]];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_deleteBlack:@{@"userId":user.userId,@"blackUserId":blackId} withSuccessBlock:^(NSDictionary *object) {
        
        
        [self hideHud];
        if([object[@"ret"] intValue] == 0){
            
            [self.list removeObject:dic];
            [self.tableView reloadData];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
