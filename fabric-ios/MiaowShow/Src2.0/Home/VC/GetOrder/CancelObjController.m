//
//  CancelObjController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "CancelObjController.h"
#import "CancelObjCell.h"
#import "AppDelegate.h"
@interface CancelObjController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *list;
@end

@implementation CancelObjController
{
    NSInteger index;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = [NSMutableArray array];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
    [self.tableView registerNib:[UINib nibWithNibName:@"CancelObjCell" bundle:nil] forCellReuseIdentifier:@"co"];
    index =0;
    [self loadData];
}


- (IBAction)done:(id)sender {
    
    NSDictionary *dic = self.list[index];
    [self showHudInView:self.view];
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_cancelGO:@{@"custId":user.userId,@"askId":self.orderID,@"reason":dic[@"name"]} withSuccessBlock:^(NSDictionary *object) {
        
        
        [self hideHud];
        if([object[@"ret"] intValue] == 0){
            
            
            [self cancel:nil];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}

- (IBAction)cancel:(id)sender {
    self.view.hidden = YES;
    [self removeFromParentViewController];
}


- (void)loadData{
    

    [BAIRUITECH_NetWorkManager FinanceLiveShow_cancelList:nil withSuccessBlock:^(NSDictionary *object) {
        
        
  
        if([object[@"ret"] intValue] == 0){
            
            self.list = [object[@"data"] mutableCopy];
            [self.tableView reloadData];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}

-(void)show{
    
    AppDelegate *dele =(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [dele.window.rootViewController addChildViewController:self];
    [dele.window.rootViewController.view addSubview:self.view];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return [self.list count];
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 10;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CancelObjCell *cell = [tableView dequeueReusableCellWithIdentifier:@"co"];
    cell.roundBtn.selected = (indexPath.row == index);
    NSDictionary *dic = self.list[indexPath.row];
    cell.lab.text = dic[@"name"];
    return cell;

}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.row;
    [self.tableView reloadData];
    
}

@end
