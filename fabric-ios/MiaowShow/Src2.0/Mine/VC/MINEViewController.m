//
//  MINEViewController.m
//  Farbic
//
//  Created by sam on 2017/12/3.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MINEViewController.h"
#import "PersonCenterViewController.h"
#import "SettingViewController.h"
#import "GetOrderController.h"
#import "FindOrderController.h"
#import "FabricWebViewController.h"
#import "AddressController.h"
#import "RoomSettingController.h"
@interface MINEViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic, strong) NSMutableArray *list;
@end

@implementation MINEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self setup];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (user.nickName.length>0) {
        
        self.nameLab.text = user.nickName;

        [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",user.userLogo]] forState:UIControlStateNormal placeholderImage:nil];
    }else{
        
        self.nameLab.text = @"请点击登录";
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)setup
{
    
    [self.tableView setTableHeaderView:self.headView];
    [self.tableView setTableFooterView:[UIView new]];
    [self.headBtn cornerRadius:40];
    [self.bgView cornerRadius:10];

    self.list = @[@"委托订单",@"找样订单",@"我的钱包",@"收货地址",@"平台规则",@"房间设置",@"设置"].mutableCopy;
    [self setLogin:^{
       
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];

            
        self.nameLab.text = user.nickName;
        [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",user.userLogo]] forState:UIControlStateNormal placeholderImage:nil];
    }];
    
}

- (IBAction)head:(id)sender {
    
    if ([self testLogin]) {
     
        PersonCenterViewController *vc = [[PersonCenterViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return 5;
    return [self.list count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ce"];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"my%@",self.list[indexPath.row]]];
    cell.textLabel.text =self.list[indexPath.row];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    

    
    
    if (![self testLogin]) {
        

        return;
    }
   
    if (indexPath.row == 0) {
        
        GetOrderController*vc = [[GetOrderController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    if (indexPath.row == 1) {
        
        FindOrderController*vc = [[FindOrderController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    if (indexPath.row == 2) {
        
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        FabricWebViewController *vc = [[FabricWebViewController alloc]init];
        vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/fmsBusi/assets.html?userId=%@&token=%@",user.userId,user.token];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    
    if (indexPath.row == 3) {
        
        AddressController*vc = [[AddressController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 4) {
        
        FabricWebViewController *vc = [[FabricWebViewController alloc]init];
        vc.strUrl = @"http://wap.fabric.cn/wap/platrules.html";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 5) {
        
        RoomSettingController *vc = [[RoomSettingController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 6) {
        
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
}





@end
