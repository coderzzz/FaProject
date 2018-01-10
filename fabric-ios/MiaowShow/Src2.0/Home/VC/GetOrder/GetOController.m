//
//  GetOController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/25.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "GetOController.h"
#import "GetOrderDetailController.h"
#import "EaseMessageReadManager.h"
#import "GOderDCell.h"
@interface GetOController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
//@property (weak, nonatomic) IBOutlet UILabel *phone;
//@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *tileLab;
@property (strong, nonatomic) NSMutableArray *list;
@end

@implementation GetOController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"抢单详情";
    
    self.list = [NSMutableArray array];
    
    [self.tableView setTableHeaderView:self.headView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GOderDCell" bundle:nil] forCellReuseIdentifier:@"d"];
    
    self.nameLab.text = [NSString stringWithFormat:@"收货人：%@",_dic[@"buyer"]];
//    self.phone.text = [NSString stringWithFormat:@"%@",_dic[@"phone"]];
//    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@%@",_dic[@"countryName"],_dic[@"provinceName"],_dic[@"cityName"],_dic[@"areaName"],_dic[@"address"]];
    
    
    NSString *userlogo = [NSString stringWithFormat:@"%@%@",ImageURL,_dic[@"userLogo"]];
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.layer.cornerRadius = 16;
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:userlogo
                                      ] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]] ;
//    self.userNameLab.text = _dic[@"nickName"];
    self.dateLab.text = [NSDate dateWithTimesTamp:[NSString stringWithFormat:@"%@",_dic[@"createdTime"]]];
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@",_dic[@"goodsAmt"]];
    
    
    //    [self.list addObject:_dic[@"descriptions"]];
    NSArray *imgs = [_dic[@"imgUrl"] componentsSeparatedByString:@","];
    [self.list addObjectsFromArray:imgs];
    [self.tableView reloadData];
    
    
    //    NSMutableArray *imagary = [NSMutableArray array];
    //    for (NSString *str in imgs) {
    //
    //        ZZItem *tag = [ZZItem new];
    //        tag.imageUrl = str;
    //        [imagary addObject:tag];
    //    }
    //    self.imageScrollView.list = imagary;
    self.tileLab.text = _dic[@"goodsName"];
    //    self.detailLab.text =_dic[@"descriptions"];
    
    
    //    NSArray *marks = [_dic[@"marks"] componentsSeparatedByString:@","];
    //    NSMutableArray *tags = [NSMutableArray array];
    //    for (NSString *mark in marks) {
    //
    //        ZZTag *tag = [ZZTag new];
    //        tag.title = mark;
    //        tag.color = Color;
    //        tag.height=24;
    //        [tags addObject:tag];
    //    }
    //    self.tagView.list = tags;
    
    
    
}


- (IBAction)go:(id)sender {
    
    if ([self testLogin]) {
        
        [self showHudInView:self.view];
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        NSString *blackId = [NSString stringWithFormat:@"%@",_dic[@"askId"]];
        [BAIRUITECH_NetWorkManager FinanceLiveShow_GO:@{@"custId":user.userId,@"askId":blackId} withSuccessBlock:^(NSDictionary *object) {
            
            
            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
                NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:_dic];
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [self.list count] +1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        CGSize textSize = [_dic[@"goodsName"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine |
                           NSStringDrawingUsesLineFragmentOrigin |
                           NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        return textSize.height+20;
    }
    
    return 240;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _dic[@"descriptions"];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        return cell;
    }
    
    GOderDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"d"];
    [cell.imgv sd_setImageWithURL:[NSURL URLWithString:self.list[indexPath.row -1] ] placeholderImage:nil];
    return cell;
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        
        [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[[NSURL URLWithString:self.list[indexPath.row -1]]]];
    }
    
}

@end
