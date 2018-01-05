//
//  GXViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/25.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "GXViewController.h"
#import "GXCell.h"
@interface GXViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet UILabel *namelab;

@property (weak, nonatomic) IBOutlet UILabel *countlab;


@property(nonatomic, strong) NSMutableArray *lives;
@end


static NSString *reuseIdentifier = @"gx";
@implementation GXViewController

{
    
}
- (NSMutableArray *)lives
{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    
    self.title = @"粉丝贡献榜";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GXCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setTableHeaderView:self.headView];

    [self loadData];
}

- (void)loadData{
    
    [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_gx:@{@"userId":user.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){

            
            _lives = [object[@"data"] mutableCopy];
            
            if (_lives.count >0) {
            
                self.namelab.text = _lives[0][@"nickName"];
                [self.logo sd_setImageWithURL:[NSURL URLWithString:_lives[0][@"userLogo"]] placeholderImage:nil];
                self.countlab.text = [_lives[0][@"totalAmt"] stringValue];
                
            }
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
    
    return  self.lives.count-1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = BGColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GXCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
   
    if (indexPath.row+1<_lives.count) {
        
        cell.namelab.text = _lives[indexPath.row+1][@"nickName"];
        [cell.logo sd_setImageWithURL:[NSURL URLWithString:_lives[indexPath.row+1][@"userLogo"]] placeholderImage:nil];
        cell.countlab.text = [_lives[indexPath.row+1][@"totalAmt"] stringValue];
        [cell.btn setTitle:[NSString stringWithFormat:@"%ld",indexPath.row+2] forState:UIControlStateNormal];
        
    }
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


@end
