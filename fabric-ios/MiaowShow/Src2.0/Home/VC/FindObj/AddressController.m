//
//  AddressController.m
//  Farbic
//
//  Created by sam on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AddressController.h"
#import "AddNewAddressController.h"
#import "AddressCell.h"
@interface AddressController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *reuseIdentifier = @"addressc";
@implementation AddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadDatas];
}
- (IBAction)addNew:(id)sender {
    AddNewAddressController *vc = [AddNewAddressController new];
    vc.title = @"添加新地址";
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}



- (void)loadDatas{
    
     [self showHudInView:self.view];
    

    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_address:@{@"custId":user.userId,@"typeId":@"1"} withSuccessBlock:^(NSDictionary *object) {
        
        [self hideHud];
        
        if([object[@"ret"] intValue] == 0){
            
            self.list = [object[@"data"] mutableCopy]  ;
            [self.tableView reloadData];
            
            
        }else{

            
        }
        
    } withFailureBlock:^(NSError *error) {
        
           [self showHint:error.description];
        
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.list.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.dic = self.list[indexPath.row];
    [cell setClick:^(NSInteger tag){
        if (tag == 0) {
            
            [self setToDefault:cell.dic];
        }else if (tag == 2){
            
            [self deleteWithDic:cell.dic];
        }
        else{
            
            AddNewAddressController *vc = [AddNewAddressController new];
            vc.title = @"编辑地址";
            vc.dic = cell.dic;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    return cell;
    
    
}

- (void)deleteWithDic:(NSDictionary *)dic{
    
    [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_deladdress:@{@"custId":user.userId,@"typeId":@"1",@"deliverId":dic[@"deliverId"]} withSuccessBlock:^(NSDictionary *object) {
        
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

- (void)setToDefault:(NSDictionary *)dic{
    
    [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_defaultaddress:@{@"custId":user.userId,@"typeId":@"1",@"deliverId":dic[@"deliverId"]} withSuccessBlock:^(NSDictionary *object) {
        
        [self hideHud];
        
        if([object[@"ret"] intValue] == 0){
            
            [self loadDatas];
            
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.DidSelect) {
        self.DidSelect(self.list[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
