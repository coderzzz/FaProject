//
//  SexViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/25.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "SexViewController.h"

@interface SexViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation SexViewController
{
    NSArray *list;
    NSInteger index;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[UIView new]];
     self.btn.backgroundColor = MainColor;
    list = @[@"男",@"女",@"保密"];
    index = 0;
}
- (IBAction)done:(id)sender {
    
    NSString *str = @"";
    if (index ==0) {
        str = @"M";
    }else if (index == 1){
        str = @"W";
    }
    [self.delegate changeSex:str];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  list.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = list[indexPath.row];
    if (indexPath.row == index) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.row;
    [self.tableView reloadData];
    
}


@end
