//
//  SystemMsgViewController.m
//  MiaowShow
//
//  Created by sam on 2017/9/29.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "SystemMsgViewController.h"
#import "SysMsgCell.h"
#import "EaseMessageViewController.h"
@interface SystemMsgViewController ()

@property(nonatomic, strong) NSMutableArray *list;
@property (assign, nonatomic) int pageN;
@end

static NSString *reuseIdentifier = @"sym";

@implementation SystemMsgViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    
    self.title = @"系统消息";
    self.list  = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SysMsgCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];

    //    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 49);
    
    //    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.estimatedRowHeight = 136;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self firstLoad];
//    }];
//    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        [self loadMore];
//    }];
//    [self.tableView.mj_header beginRefreshing];
//
    
    [self loadAllMsg];
    
}
- (void)loadAllMsg{
    
//    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    
    for (NSDictionary *dic in [FabricSocket shareInstances].messages) {
        
        [self parseMsg:dic];
    }
    [self.tableView reloadData];
    
}

- (void)parseMsg:(NSDictionary *)dic{
    
//    NSString *revId = [NSString stringWithFormat:@"%@",dic[@"receiverid"]];
//    NSString *senderId = [NSString stringWithFormat:@"%@",dic[@"senderid"]];
    NSString *cmd = [NSString stringWithFormat:@"%@",dic[@"cmd"]];

    if ([cmd isEqualToString:@"701"]) {
            
       NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
       NSString *time = [NSString stringWithFormat:@"%@",content[@"time"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:content];
        [dic setValue:time?time:@"" forKey:@"time"];
        if (content) {
            
            [self.list addObject:dic];
        }
            
    }
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        //  NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SysMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSDictionary *dic = self.list[indexPath.row];
    cell.contentLab.text = dic[@"content"];
    cell.dateLab.text = [NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
    cell.namelab.text = dic[@"title"];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    NSDictionary *dic = self.list[indexPath.row];
//    EMMessage *message = [[EMMessage alloc]init];
//    EMMessageBody *body = [EMMessageBody new];
//    body.type = EMMessageBodyTypeText;
//    message.body = body;
//    message.text =  [NSString stringWithFormat:@"%@\n%@",dic[@"messTitle"],dic[@"messContent"]];
////    message.from = @"系统消息";
////    message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
//    message.direction = EMMessageDirectionReceive;
//    message.timestamp = [[NSString stringWithFormat:@"%@",@"111"] longLongValue];
//    EaseMessageViewController *chatVC =[[EaseMessageViewController alloc]initWithMsg:message hideToolBar:YES];
//    chatVC.title = @"系统消息";
//   
//    [self.navigationController pushViewController:chatVC animated:YES];

    
}

@end
