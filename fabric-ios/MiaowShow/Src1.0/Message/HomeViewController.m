//
//  HomeViewController.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "HomeViewController.h"
#import "ALinSelectedView.h"
#import "ALinHotViewController.h"
#import "ALinNewStarViewController.h"
//#import "ALinCareViewController.h"
//#import "ALinWebViewController.h"

@interface HomeViewController() <UIScrollViewDelegate>
/** 顶部选择视图 */
@property(nonatomic, assign) ALinSelectedView *selectedView;
/** UIScrollView */
@property(nonatomic, weak) UIScrollView *scrollView;
/** 热播 */
@property(nonatomic, weak) ALinHotViewController *hotVc;
///** 最新主播 */
@property(nonatomic, weak) ALinNewStarViewController *starVc;
///** 关注主播 */
//@property(nonatomic, weak) ALinCareViewController *careVc;
@end

@implementation HomeViewController

- (void)loadView
{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    view.contentSize = CGSizeMake(SCREEN_WIDTH* 2, 0);
    view.backgroundColor = [UIColor whiteColor];
    // 去掉滚动条
    view.showsVerticalScrollIndicator = NO;
    view.showsHorizontalScrollIndicator = NO;
    // 设置分页
    view.pagingEnabled = YES;
    // 设置代理
    view.delegate = self;
    // 去掉弹簧效果
    view.bounces = NO;
    
    CGFloat height = SCREEN_HEIGHT - 49-64;
    
    // 添加子视图
    ALinHotViewController *hot = [[ALinHotViewController alloc] init];
    hot.view.frame = [UIScreen mainScreen].bounds;
    hot.view.height = height;
    [self addChildViewController:hot];
    [view addSubview:hot.view];
    _hotVc = hot;
    
    
    ALinNewStarViewController *newStar = [[ALinNewStarViewController alloc] init];
    newStar.view.frame = [UIScreen mainScreen].bounds;
    newStar.view.x = SCREEN_WIDTH;
    newStar.view.height = height;
    [self addChildViewController:newStar];
    [view addSubview:newStar.view];
    _starVc = newStar;
    
    
    
//    ALinCareViewController *care = [UIStoryboard storyboardWithName:NSStringFromClass([ALinCareViewController class]) bundle:nil].instantiateInitialViewController;
//    care.view.frame = [UIScreen mainScreen].bounds;
//    care.view.x = ALinScreenWidth * 2;
//    care.view.height = height;
//    [self addChildViewController:care];
//    [view addSubview:care.view];
//    _careVc = care;
    
    self.view = view;
    self.scrollView = view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    [self setup];
}

- (void)setup
{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_15x14"] style:UIBarButtonItemStyleDone target:nil action:nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"head_crown_24x24"] style:UIBarButtonItemStyleDone target:self action:@selector(rankCrown)];
    [self setupTopMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_selectedView) {
        [self setupTopMenu];
    }
}

- (void)rankCrown
{
//    ALinWebViewController *web = [[ALinWebViewController alloc] initWithUrlStr:@"http://live.9158.com/Rank/WeekRank?Random=10"];
//    web.navigationItem.title = @"排行";
//    [_selectedView removeFromSuperview];
//    _selectedView = nil;
//    [self.navigationController pushViewController:web animated:YES];
}

- (void)setupTopMenu
{
    // 设置顶部选择视图
    ALinSelectedView *selectedView = [[ALinSelectedView alloc] initWithFrame:self.navigationController.navigationBar.bounds];

    
    selectedView.width = 65 * 2;
    [selectedView setSelectedBlock:^(HomeType type) {
        [self.scrollView setContentOffset:CGPointMake(type * SCREEN_WIDTH, 0) animated:YES];
    }];
    self.navigationItem.titleView = selectedView;
//    [self.navigationController.navigationBar addSubview:selectedView];
    _selectedView = selectedView;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat page = scrollView.contentOffset.x / SCREEN_WIDTH;
    CGFloat offsetX = scrollView.contentOffset.x / SCREEN_WIDTH * (self.selectedView.width * 0.5 - 60 * 0.5 - 15);
    self.selectedView.underLine.x = 5 + offsetX;
    if (page == 1 ) {
        self.selectedView.underLine.x = 10  + 60;
    }else  {
        
    }
    self.selectedView.selectedType = (int)(page + 0.5);
}

@end
