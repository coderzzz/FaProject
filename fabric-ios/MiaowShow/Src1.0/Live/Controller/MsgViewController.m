//
//  MsgViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/8/30.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgTableViewCell.h"
@interface MsgViewController ()<UITableViewDelegate,UITableViewDataSource>




@end

@implementation MsgViewController

-(void)setList:(NSMutableArray *)list{
    
    _list = list;
    [_tableView reloadData];
    if (_list.count>0) {
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:list.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    UINib *nib = [UINib nibWithNibName:@"MsgTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"msg"];
    

   
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msg"];
    NSDictionary *dic = self.list[indexPath.row];
    NSString *userN = [NSString stringWithFormat:@"%@",dic[@"nickName"]];
    [cell setString:dic[@"msg"] userName:userN];
    return cell;
}
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSDictionary *dic = self.list[indexPath.row];

    CGSize size =[MsgTableViewCell sizeToLabelWidthWithStr:[NSString stringWithFormat:@"%@: %@",dic[@"msg"],dic[@"nickName"]]];

    if (size.height<15) {
        
        return 35;
    }
    return size.height + 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
