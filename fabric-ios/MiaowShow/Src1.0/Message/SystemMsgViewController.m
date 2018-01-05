//
//  SystemMsgViewController.m
//  MiaowShow
//
//  Created by sam on 2017/9/29.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "SystemMsgViewController.h"
#import "MsCell.h"
#import "EaseMessageViewController.h"
@interface SystemMsgViewController ()

@property(nonatomic, strong) NSMutableArray *list;
@property (assign, nonatomic) int pageN;
@end

static NSString *reuseIdentifier = @"ms";

@implementation SystemMsgViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MsCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];

    //    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 49);
    
    //    [self.tableView.mj_header beginRefreshing];
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
    
    NSDictionary *dic = @{@"userId":user.userId,@"pageNo":@(_pageN),@"pageSize":@"10",@"type":_type};
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_mess:dic withSuccessBlock:^(NSDictionary *object) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            [weakSelf.list addObjectsFromArray:[object[@"data"][@"messList"] mutableCopy]];
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
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    createTime = "2016-12-10 00:32:31";
//    id = 9;
//    messContent = sdfsdfsdfsd;
//    messTitle = "\U767b\U5f55\U6ce8\U518c-\U79fb\U52a8\U7aef\U53cd\U9988";
//    type = 0;
    MsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
     NSDictionary *dic = self.list[indexPath.row];
    cell.titlelab.text = dic[@"messTitle"];
    cell.sublab.text =  dic[@"messContent"];
    [cell.arrowbtn setTitle:dic[@"createTime"] forState:UIControlStateNormal];
//    [cell.logo sd_setImageWithURL:[NSURL URLWithString:dic[@"userLogo"]] placeholderImage:nil];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *dic = self.list[indexPath.row];
    EMMessage *message = [[EMMessage alloc]init];
    EMMessageBody *body = [EMMessageBody new];
    body.type = EMMessageBodyTypeText;
    message.body = body;
    message.text =  [NSString stringWithFormat:@"%@\n%@",dic[@"messTitle"],dic[@"messContent"]];
//    message.from = @"系统消息";
//    message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
    message.direction = EMMessageDirectionReceive;
    message.timestamp = [[NSString stringWithFormat:@"%@",@"111"] longLongValue];
    EaseMessageViewController *chatVC =[[EaseMessageViewController alloc]initWithMsg:message hideToolBar:YES];
    chatVC.title = @"系统消息";
   
    [self.navigationController pushViewController:chatVC animated:YES];

    
}

@end
