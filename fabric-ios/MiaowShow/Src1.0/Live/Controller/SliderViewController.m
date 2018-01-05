//
//  SliderViewController.m
//  MiaowShow
//
//  Created by sam on 2017/10/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "SliderViewController.h"
#import "SliderCell.h"
@interface SliderViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *blurView;
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation SliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    // Do any additional setup after loading the view.
}

- (void)setUpUI{
    
//    self.view.backgroundColor = [UIColor clearColor];
    
    _blurView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    
//    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    bgImgView.image = [UIImage imageNamed:@"huoying.jpg"];
//    [self.view addSubview:bgImgView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame =CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT);
//    [_blurView addSubview:effectView];
    [self.view addSubview:effectView];
//    [self.view insertSubview:effectView aboveSubview:self.tableView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SliderCell class]) bundle:nil] forCellReuseIdentifier:
     @"slider"];
    [effectView addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
//    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
}

- (void)hide{
    
    if (self.hideBlock) {
        self.hideBlock();
    }
}

- (void)setData:(NSArray *)data{
    
    _data = data;
    [self.tableView reloadData];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint point =[touch locationInView:self.tableView];
    if (point.x >0) {
        
        return NO;
    }
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.data.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider"];
    NSArray *list = [self.data[indexPath.row] componentsSeparatedByString:@"&"];
    cell.imagev.image = [UIImage imageNamed:list.firstObject];
    cell.titlelab.text = list.lastObject;
    
    if (indexPath.row == self.data.count-1) {
        
        cell.butline.hidden = NO;
    }else{
        cell.butline.hidden = YES;
    }
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.didSelect) {
        self.didSelect(indexPath.row);
    }
}


@end
