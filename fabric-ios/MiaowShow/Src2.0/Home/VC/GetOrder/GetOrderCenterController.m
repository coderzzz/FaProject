//
//  GetOrderCenterController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/7.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "GetOrderCenterController.h"
#import "OrderCenterCell.h"
#import "GetOrderDetailController.h"
#import "GetOController.h"
@interface GetOrderCenterController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@property (assign, nonatomic) int pageN;
@property (assign, nonatomic) int timeT;
@property (assign, nonatomic) int priceT;
@end
static NSString *reuseIdentifier = @"centerc";
@implementation GetOrderCenterController

- (IBAction)shortTime:(UIButton *)sender {
    
    self.timeBtn.selected = YES;
    self.moneyBtn.selected = NO;
    _priceT =0;
    _timeT = 1;
//    if (_timeT == 0) {
//        _timeT =1;
//    }else{
//        _timeT = 0;
//    }
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)shortMoney:(UIButton *)sender {
    
    self.timeBtn.selected = NO;
    self.moneyBtn.selected = YES;
    _priceT =1;
    _timeT = 0;
//    if (_priceT == 0) {
//        _priceT =1;
//    }else{
//        _priceT = 0;
//    }
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _timeT = 0;
    _priceT = 0;
    self.navigationItem.title = @"抢单中心";
//    self.title = @"抢单中心";
    self.timeBtn.selected = YES;
    [self setup];
}

-(void)setup
{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCenterCell" bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];

//    self.tableView.estimatedRowHeight = 250;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self firstLoad];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
   
    
    
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
    NSDictionary *dic = @{@"custId":user.userId,@"createTimeType":@(_timeT),@"orderAmtType":@(_priceT),@"pageNo":@(_pageN),@"pageSize":@"10"};
    [BAIRUITECH_NetWorkManager FinanceLiveShow_OrderList:dic withSuccessBlock:^(NSDictionary *object) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            [weakSelf.list addObjectsFromArray:[object[@"data"][@"askList"] mutableCopy]];
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
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    OrderCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.dic = self.list[indexPath.row];
    [cell setClick:^{
        
        [self getOrder:cell.dic];
    }];
    return cell;

}

- (void)getOrder:(NSDictionary *)dic{
    
    
    
    if ([self testLogin]) {
    
        [self showHudInView:self.view];
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        NSString *blackId = [NSString stringWithFormat:@"%@",dic[@"askId"]];
        [BAIRUITECH_NetWorkManager FinanceLiveShow_GO:@{@"custId":user.userId,@"askId":blackId} withSuccessBlock:^(NSDictionary *object) {
            
            
            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
                NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:dic];
                NSString *priceId = [NSString stringWithFormat:@"%@",object[@"data"][@"priceId"]];
                [res setValue:priceId forKey:@"priceId"];
                GetOrderDetailController *vc = [GetOrderDetailController new];
                vc.dic = res;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                
            }
            
        } withFailureBlock:^(NSError *error) {
            
            [self showHint:error.description];
            
        }];
        
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.list[indexPath.row];
    GetOController *vc = [GetOController new];
    vc.dic = dic;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
