//
//  MyFansViewController.m
//  MiaowShow
//
//  Created by sam on 2017/9/17.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MyFansViewController.h"
#import "FansCell.h"
#import "PopoverModel.h"
#import "UIButton+WebCache.h"

@interface MyFansViewController ()

@property(nonatomic, strong) NSMutableArray *lives;

@property (assign, nonatomic) int pageN;

@end

static NSString *reuseIdentifier = @"fans";

@implementation MyFansViewController
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
    
    self.title = @"粉丝";
    
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
    
    [self getData];
}

- (void)loadMore{
    
    
    
    _pageN += 1;
    
    [self getData];
}

- (void)getData{
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_follow:@{@"followUserId":user.userId,@"pageNo":@(_pageN),@"pageSize":@"10"} withSuccessBlock:^(NSDictionary *object) {
        
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
    [cell.imagV sd_setImageWithURL:[NSURL URLWithString:item.userLogo] forState:UIControlStateNormal];
    cell.lab.text = item.nickName;
    
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

@end
