//
//  LiveWordController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/25.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "LiveWordController.h"
#import "FabricWebViewController.h"
#import "ALinLiveCollectionViewController.h"
#import "LiveWordCell.h"
#import "EaseMessageViewController.h"
@interface LiveWordController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *list;
@property (assign, nonatomic) int pageN;
@end

static NSString *reuseIdentifier = @"lw";
@implementation LiveWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"纺织世界";
    [self setup];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)setup
{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LiveWordCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    self.tableView.estimatedRowHeight = 226;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
    NSDictionary *dic = @{@"pageNo":@(_pageN),@"pageSize":@"10"};
    [BAIRUITECH_NetWorkManager FinanceLiveShow_MenuRooms:dic withSuccessBlock:^(NSDictionary *object) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            [weakSelf.list addObjectsFromArray:[object[@"data"][@"roomList"] mutableCopy]];
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
//    return 5;
    return [self.list count];
}

//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return 44;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
//    {
//        imgPath = "http://img01.fabric.cn/upload/images/20170928/l/201709284fmxj83uvs8a.png";
//        nickName = "\U676d\U5dde\U534e\U6770\U7eba\U7ec7\U6709\U9650\U516c\U53f8";
//        playStream = "rtmp://10671.liveplay.myqcloud.com/live/10671_239396";
//        roomId = 1012064;
//        roomName = "\U676d\U5dde\U534e\U6770";
//        roomStarLevel = 0;
//        userId = 94496;
//    }
    LiveWordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSDictionary *dic = self.list[indexPath.row];
    cell.titleLab.text = dic[@"roomName"];
    cell.contentLab.text = dic[@"nickName"];
    cell.liveing.hidden = ![dic[@"status"] boolValue];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"imgPath"]]];
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
    NSDictionary *dic = self.list[indexPath.row];
    [self enterRoom:dic];
    
}
- (void)enterRoom:(NSDictionary *)dic{
    
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_enterRoom:@{@"roomId":dic[@"roomId"],@"userId":account.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            if ([object[@"data"][@"star"][@"status"] intValue] == 1) {
                
                ALinLiveCollectionViewController *vc = [ALinLiveCollectionViewController new];
                
                vc.live = [LiveUserModel mj_objectWithKeyValues:object[@"data"][@"star"]];
                
                vc.live.chatAddress =object[@"data"][@"chat"][@"chatAddress"];
                vc.live.chatKey = object[@"data"][@"chat"][@"chatKey"];
                vc.live.isFollow =[object[@"data"][@"isFollow"] boolValue];
                
                if(!(vc.live.chatAddress.length >0))
                {
                    [BAIRUITECH_BRTipView showTipTitle:@"服务端返回json格式错误" delay:1];
                    return ;
                }
                
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                
                
                
                EaseMessageViewController *chatVC =[[EaseMessageViewController alloc]initWithConversationChatter:@""];
                chatVC.toUserId = [NSString stringWithFormat:@"%@",object[@"data"][@"star"][@"userId"]];
                chatVC.showRefreshHeader = YES;
                chatVC.title = object[@"data"][@"star"][@"nickName"];
                [self.navigationController pushViewController:chatVC animated:YES];
                
//                FabricWebViewController *vc = [[FabricWebViewController alloc]init];
//                vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/shop.html?id=%@&userId=%@&token=%@",object[@"data"][@"star"][@"userId"],account.userId,account.token];
//                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
}

@end
