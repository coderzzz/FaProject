//
//  ALinNewStarViewController.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ALinNewStarViewController.h"
#import "MCell.h"
#import "PrivateChatItem.h"
#import "EaseMessageViewController.h"
#import "SystemMsgViewController.h"
#import "OrderMsgController.h"

@interface ALinNewStarViewController ()

@property(nonatomic, strong) NSMutableArray *lives;

@property (strong, nonatomic) NSMutableArray *list;
@property (assign, nonatomic) int pageN;

@end

static NSString *reuseIdentifier = @"m";

@implementation ALinNewStarViewController
- (NSMutableArray *)lives
{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

-(id)init{
    
    self = [super init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMessage:) name:@"FSDidReceiveMessage" object:nil];
    [self setup];
}

- (void)setup
{
    self.title = @"消息";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
//    [self.tableView registerClass:[ALinHomeADCell class] forCellReuseIdentifier:ADReuseIdentifier];
    //    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 49);
    
    //    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstLoad)];
//    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        
//        [self loadMore];
//    }];
//    
//    [self.tableView.mj_header beginRefreshing];
    [self loadAllMsg];
    [self.tableView reloadData];
}




- (void)loadAllMsg{
    
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];

    for (NSDictionary *dic in [FabricSocket shareInstances].messages) {
        
        [self parseMsg:dic];
    }


}

- (void)parseMsg:(NSDictionary *)dic{
    
    NSString *revId = [NSString stringWithFormat:@"%@",dic[@"receiverid"]];
    NSString *senderId = [NSString stringWithFormat:@"%@",dic[@"senderid"]];
    NSString *cmd = [NSString stringWithFormat:@"%@",dic[@"cmd"]];
    
    if ([cmd isEqualToString:@"801"]) {
        
        NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
        NSString *askID = [NSString stringWithFormat:@"%@",content[@"askId"]];
        if (self.list.count>0) {
            
            for (PrivateChatItem *item in self.list) {
                
                if ([item.askId isEqualToString:askID]) {
                    
                    item.content = content[@"content"];
                    item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
                    [self.tableView reloadData];
                    return;
                }
                
            }
            
            PrivateChatItem *item = [PrivateChatItem new];
            item.content = content[@"content"];
            item.askId = askID;
            item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
            item.nickName = @"订单通知";
            item.sysLogo = [UIImage imageNamed:@"订单通知"];
            [self.list addObject:item];
            [self.tableView reloadData];
        }else{
            
            PrivateChatItem *item = [PrivateChatItem new];
            item.content = content[@"content"];
            item.askId = askID;
            item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
            item.nickName = @"订单通知";
            item.sysLogo = [UIImage imageNamed:@"订单通知"];
            [self.list addObject:item];
            [self.tableView reloadData];
        }
        
        return;

    }
    //系统消息
    if ([cmd isEqualToString:@"701"]) {
        
        NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
        if (self.list.count>0) {
            
            for (PrivateChatItem *item in self.list) {
                
                if ([item.userId isEqualToString:@"-1"]) {
                    
                    item.content = content[@"content"];
                    item.title = content[@"title"];
                    item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
                    [self.tableView reloadData];
                    return;
                }
                
            }
            
            PrivateChatItem *item = [PrivateChatItem new];
            item.content = content[@"content"];
            item.title = content[@"title"];
            item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
            item.userId = @"-1";
            item.nickName = @"系统消息";
            item.sysLogo = [UIImage imageNamed:@"系统消息-1"];
            [self.list addObject:item];
            [self.tableView reloadData];
        }else{
            
            PrivateChatItem *item = [PrivateChatItem new];
            item.content = content[@"content"];
            item.title = content[@"title"];
            item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
            item.userId = @"-1";
            item.nickName = @"系统消息";
            item.sysLogo = [UIImage imageNamed:@"系统消息-1"];
            [self.list addObject:item];
            [self.tableView reloadData];
        }
        
        return;
        
    }
    if (![revId isEqualToString:@"0"]) {
        
        if ([cmd isEqualToString:@"601"]) {
            
            NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
            if (self.list.count>0) {
                
                for (PrivateChatItem *item in self.list) {
                    
                    if ([item.userId isEqualToString:senderId] || [revId isEqualToString:item.userId]) {
                        
                        item.content = content[@"msg"];
                        item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
                        [self.tableView reloadData];
                        return;
                    }
                    
                }
                
                [self addList:dic];
            }else{
                
                [self addList:dic];
            }
            
        }
        
    }else{
        
        
        

        
    }
}

#pragma mark FabricSocketNotification
-(void)didReceiveMessage:(NSNotification *)notifi{
    
    NSDictionary *msg = [self dictionaryWithJsonString:notifi.object];
    if (!msg) {
        
        return;
    }
    
    
    [self parseMsg:msg];
    
    /*
    NSString *reciveId = [NSString stringWithFormat:@"%@",msg[@"receiverid"]];
    if ([reciveId isEqualToString:@"0"]) return;
    NSString *cmd = [NSString stringWithFormat:@"%@",msg[@"cmd"]];
    NSString *senderId = [NSString stringWithFormat:@"%@",msg[@"senderid"]];
    NSString *revId = [NSString stringWithFormat:@"%@",msg[@"receiverid"]];
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    if ([cmd isEqualToString:@"501"]) {
        
        //        NSDictionary *gift = [self dictionaryWithJsonString:msg[@"content"]];
        //        [self showGiftWithDic:gift];
        //        return;
    }
    
    if ([cmd isEqualToString:@"601"]) {
        
        NSDictionary *content = [self dictionaryWithJsonString:msg[@"content"]];
        if (self.list.count>0) {
            
            for (PrivateChatItem *item in self.list) {
                
                if ([item.userId isEqualToString:senderId] || [revId isEqualToString:item.userId]) {
                    
                    item.content = content[@"msg"];
                    item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",msg[@"time"]]];
                    [self.tableView reloadData];
                    return;
                }
                
            }
            
            [self addList:msg];
        }else{
            
            [self addList:msg];
        }
        
    }
     */
}

- (void)addList:(NSDictionary *)dic{
    
    PrivateChatItem *item = [PrivateChatItem new];
    item.chatContentType = 0;
    item.chatType = 0;
    
    NSString *senderId = [NSString stringWithFormat:@"%@",dic[@"senderid"]];
    NSString *revId = [NSString stringWithFormat:@"%@",dic[@"receiverid"]];
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    
    NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
    //    message.text = content[@"msg"];
    //    message.from = content[@"nickName"];
    //    message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
    
    if ([revId isEqualToString:account.userId]) {
        
        item.nickName = content[@"nickName"];
        item.userId = senderId;
        
    }else{
        
        item.nickName = content[@"toNickName"];
        item.userId = revId;
        
    }
    
    
    
    item.time =[NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
    item.content = content[@"msg"];
    item.userLogo = content[@"userLogo"];
    [self.list addObject:item];
    [self.tableView reloadData];
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
    NSDictionary *dic = @{@"pageNo":@(_pageN),@"pageSize":@"10",@"userId":user.userId,@"chatType":@"0"};
    [BAIRUITECH_NetWorkManager FinanceLiveShow_privateList:dic withSuccessBlock:^(NSDictionary *object) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            //            [weakSelf.list addObjectsFromArray:[object[@"data"][@"chatList"] mutableCopy]];
            
            [weakSelf.list addObjectsFromArray:[PrivateChatItem mj_objectArrayWithKeyValuesArray:object[@"data"][@"chatList"]]];
            
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
//- (void)getData{
//    
//    __weak  typeof(self) weakSelf = self;
//    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
//    NSDictionary *dic = @{@"pageNo":@(_pageN),@"pageSize":@"5",@"userId":user.userId,@"searchStr":@""};
//    [BAIRUITECH_NetWorkManager FinanceLiveShow_search:dic withSuccessBlock:^(NSDictionary *object) {
//        
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
//        if([object[@"ret"] intValue] == 0){
//            
//            [weakSelf.list addObjectsFromArray:[object[@"data"][@"roomList"] mutableCopy]];
//            [weakSelf.tableView reloadData];
//            
//        }else{
//            
//            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
//        }
//        
//    } withFailureBlock:^(NSError *error) {
//        
//        YJLog(@"%@",error);
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
//    }];
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.list count];
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
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    PrivateChatItem *dic =self.list[indexPath.row];
    if ([dic.userId isEqualToString:@"-1"] || dic.askId.length>0) {
        
        cell.logo.image = dic.sysLogo;
        
    }else{
        
        [cell.logo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,dic.userLogo]] placeholderImage:[UIImage imageNamed:@"头像"]];
    }
    
    cell.titlelab.text = dic.nickName;
    cell.sublab.text = dic.content;
    cell.dateLab.text = dic.time;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateChatItem *item =self.list[indexPath.row];

    if ([item.userId isEqualToString:@"-1"]){
        
        SystemMsgViewController *vc = [[SystemMsgViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }
    else if (item.askId.length>0){
        
        OrderMsgController *vc = [[OrderMsgController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderId = item.askId;
        [self.navigationController pushViewController:vc animated:YES];

        
        
    }
    
    else{
        
        EaseMessageViewController *chatVC =[[EaseMessageViewController alloc]initWithConversationChatter:@""];
        chatVC.toUserId = item.userId;
        chatVC.showRefreshHeader = YES;
        chatVC.title = item.nickName;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    
}

@end
