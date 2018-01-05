//
//  PrivateListController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/19.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "PrivateListController.h"
#import "MsCell.h"
#import "PrivateChatItem.h"
@interface PrivateListController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *lives;

@property (strong, nonatomic) NSMutableArray *list;



@property (assign, nonatomic) int pageN;

@end

static NSString *reuseIdentifier = @"ms";

@implementation PrivateListController

- (EaseMessageViewController *)chatVC{
    
    if (!_chatVC) {
        
        _chatVC = [[EaseMessageViewController alloc]initWithConversationChatter:@"11"];
        _chatVC.view.frame = CGRectMake(0, 40, SCREEN_WIDTH, self.mainView.height-40);
//        _chatVC.socket = self.socket;
//        _chatVC.toUserId = self.live.userId;
        _chatVC.showRefreshHeader = YES;
        _chatVC.view.hidden = YES;
        [self addChildViewController:_chatVC];
        [self.mainView addSubview:_chatVC.view];
        
    }
    return _chatVC;
}


- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMessage:) name:@"FSDidReceiveMessage" object:nil];
}

- (void)setup
{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MsCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    //    [self.tableView registerClass:[ALinHomeADCell class] forCellReuseIdentifier:ADReuseIdentifier];
    //    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 49);
    
    //    [self.tableView.mj_header beginRefreshing];
    self.closeBtn.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.line.backgroundColor = MainColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstLoad)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
}

- (void)hide{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self hideChatView:nil];
    }];
//    if (self.hideBlock) {
//        self.hideBlock();
//    }
}
- (IBAction)hideChatView:(id)sender {
    
//    [self.chatVC.messsagesSource removeAllObjects];
//    [self.chatVC.tableView reloadData];
    self.chatVC.view.hidden = YES;
    [self.chatVC.view endEditing:YES];
    self.closeBtn.hidden = YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point =[touch locationInView:self.mainView];
    if (point.y >0) {
        
        return NO;
    }
    return YES;
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

#pragma mark FabricSocketNotification
-(void)didReceiveMessage:(NSNotification *)notifi{
    
    NSDictionary *msg = [self dictionaryWithJsonString:notifi.object];
    if (!msg) {
        
        return;
    }
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
                    [self.tableView reloadData];
                    return;
                }
                
            }
            
            [self addList:msg];
        }else{
            
            [self addList:msg];
        }
        
    }
}

- (void)addList:(NSDictionary *)dic{
    
    PrivateChatItem *item = [PrivateChatItem new];
    item.chatContentType = 0;
    item.chatType = 0;
    NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
//    message.text = content[@"msg"];
//    message.from = content[@"nickName"];
//    message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
    item.nickName = content[@"nickName"];
    item.content = content[@"msg"];
    item.userId = [NSString stringWithFormat:@"%@",dic[@"senderid"]];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.list count];
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view = [UIView new];
//    view.backgroundColor = BGColor;
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 10;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    PrivateChatItem *dic =self.list[indexPath.row];
    [cell.logo sd_setImageWithURL:[NSURL URLWithString:dic.userLogo] placeholderImage:[UIImage imageNamed:@"112"]];
    cell.titlelab.text = dic.nickName;
    cell.sublab.text = dic.content;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateChatItem *dic =self.list[indexPath.row];
    self.chatVC.toUserId = dic.userId;
    self.chatVC.view.hidden = NO;
    self.closeBtn.hidden = NO;
    
}


@end
