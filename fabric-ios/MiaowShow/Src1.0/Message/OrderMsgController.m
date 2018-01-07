//
//  OrderMsgController.m
//  Farbic
//
//  Created by sam on 2018/1/7.
//  Copyright © 2018年 ALin. All rights reserved.
//

#import "OrderMsgController.h"
#import "OrderMsgCell.h"
@interface OrderMsgController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property(nonatomic, strong) NSMutableArray *list;
@end

@implementation OrderMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    
    self.title = @"订单通知";

    self.list  = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderMsgCell class]) bundle:nil] forCellReuseIdentifier:
     @"oce"];

    [self getData];
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
    
    if ([cmd isEqualToString:@"801"]) {
        
        NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
        NSString *time = [NSString stringWithFormat:@"%@",dic[@"time"]];
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


- (void)getData{
    
    __weak  typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"askId":self.orderId?self.orderId:@""};
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_od:dic withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            NSDictionary *data = object[@"data"];
            [self.tableView setTableHeaderView:self.headView];
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:data[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
            self.titleLab.text = data[@"goodsName"];
            self.contentLab.text = data[@"descriptions"];
            self.moneyLab.text = [NSString stringWithFormat:@"￥%@",data[@"orderAmt"]];
            
            
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.list count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oce"];
    NSDictionary *dic = self.list[indexPath.row];
    cell.titleLab.text = dic[@"content"];
    cell.datelab.text = [NSDate monthWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];
    cell.dayLab.text = [NSDate hourWithTimesTamp:[NSString stringWithFormat:@"%@000",dic[@"time"]]];

    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}


@end
