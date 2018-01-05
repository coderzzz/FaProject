//
//  FabricHomeViewController.m
//  FabricNew
//
//  Created by 严军 on 2017/8/20.
//  Copyright © 2017年 严军. All rights reserved.
//

#import "FabricHomeViewController.h"
#import "SearchView.h"
#import "SearchDetailViewController.h"
#import "FabricContentViewController.h"
#import "FaPopoverView.h"
#import "ModuleItem.h"
#import "HisViewController.h"
#import "ALinLiveCollectionViewController.h"
#import "AreaViewController.h"
#import "FabricAgentViewController.h"
#import "FabricWebViewController.h"
@interface FabricHomeViewController ()<UISearchBarDelegate,UIScrollViewDelegate,SearchViewDelegate>

@property (weak, nonatomic  ) UIScrollView   * categoryScrollView;//分类按钮父视图
@property (weak, nonatomic  ) UIScrollView   * contentScrollView;//子控制器父视图
@property (weak, nonatomic  ) UIView         * redLineView;//红色横线
@property (strong, nonatomic) NSMutableArray <ModuleItem*>* titleMutableArray;//标题数组
@property (strong, nonatomic) NSMutableArray * childVCMutableArray;//子控制器数组
@property (assign, nonatomic) int index;//子控制器数组下标
@property (strong, nonatomic) NSDictionary *searchData;
@property (copy, nonatomic) NSDictionary *versionDic;

@property (nonatomic, strong) UIButton *topBtn;
@end

@implementation FabricHomeViewController

{
    AreaViewController *areavc;
//    FabricContentViewController *lastVC;
    NSDictionary *caigou;
    NSMutableArray *adList;
    NSUInteger index;
}
#pragma mark --懒加载
- (UIButton *)topBtn{
    
    if (!_topBtn) {
        
        _topBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 42 - 50 , 250, 42, 42)];
        [_topBtn setImage:[UIImage imageNamed:@"问询台"] forState:UIControlStateNormal];
        [_topBtn addTarget:self action:@selector(ask) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}
#pragma mark - 问询台
- (void)ask{
    
    FabricAgentViewController *vc = [[FabricAgentViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSMutableArray *)childVCMutableArray{
    
    if (_childVCMutableArray == nil) {
        
        _childVCMutableArray = [NSMutableArray new];
    }
    return _childVCMutableArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    //添加右侧按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(favItemClick:)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"my_fav"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    //添加左侧按钮
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(historyItemClick)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [self.navigationItem.leftBarButtonItem setImage:[[UIImage imageNamed:@"my_history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //添加搜索框
//    CGRect mainViewBounds = self.navigationController.view.bounds;
//    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewBounds)/2-((CGRectGetWidth(mainViewBounds)-120)/2), CGRectGetMinY(mainViewBounds)+22, CGRectGetWidth(mainViewBounds)-120, 40)];
//    customSearchBar.delegate = self;
//    customSearchBar.showsCancelButton = NO;
//    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
//    customSearchBar.placeholder = @"搜索店铺和商家";
//    [self.navigationController.view addSubview: customSearchBar];
    
    [self setupSearchView];
    
    
    [self loadad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.titleMutableArray = [NSMutableArray array];
 
    [self checkVersion];
   
    [self loadHotSearch];
    
}


- (void)checkVersion{
    
    NSLog(@"CFBundleShortVersionString =%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
    
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *version = [NSString stringWithFormat:@"V%@",currentVersion];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_version:@{@"type":@"0",@"version":version} withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            if([object[@"data"][@"ifUpgrade"] boolValue]){
                
                
                self.versionDic = object[@"data"];
                
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"更新提示" message:self.versionDic[@"upgradeDesc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                view.tag =1;
                [view show];

                
            }
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        //        [self showHint:error.description];
        
    }];
    

    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1 || (alertView.tag ==2 && buttonIndex ==1)) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionDic[@"upgradeUrl"]]];
        
        
        if (alertView.tag ==1) {
            
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"更新提示" message:self.versionDic[@"upgradeDesc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            view.tag =1;
            [view show];
//            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"更新提示" message:@"发现新版本，请更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            view.tag =1;
//            [view show];
        }
        else{
            
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"更新提示" message:@"发现新版本，是否更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            view.tag =2;
            [view show];
            
        }
        
        return;
    }
}


- (void)addAreaVCWithArray:(NSMutableArray *)ary{
    
    areavc = [[AreaViewController alloc]init];
    areavc.gridItem = ary;
    [self addChildViewController:areavc];
    [self.view addSubview:areavc.view];
    [areavc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.offset(300);
        
    }];
    [self.view bringSubviewToFront:areavc.view];
    areavc.view.hidden  = YES;
    
    
    [areavc setClickArea:^(NSString *areaName){
        FabricContentViewController * vc = self.childViewControllers[index];
        vc.areaName = areaName;
        [vc.collectionView.mj_header beginRefreshing];
//        [self scrollToLast];
//        lastVC.item.moduleId = areaId;
//        [lastVC.collectionView.mj_header beginRefreshing];
    }];
}

- (void)setupSearchView {
    SearchView *searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 3, self.view.frame.size.width-70, 30)];
    searchView.textField.text = @"搜索店铺和商家";
    searchView.delegate = self;
    self.navigationItem.titleView=searchView;
}

- (void)loadHotSearch{
    

    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_getHotSearch:nil withSuccessBlock:^(NSDictionary *object) {
        
        

        if([object[@"ret"] intValue] == 0){
            
            _searchData = object[@"data"];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {

        
    }];
}


- (void)loadCate{
    
    
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_Menu:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        
        //        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            
//            _gridItem = object[@"data"];
//            
//            [self.collectionView reloadData];
            
            
            [BAIRUITECH_NetWorkManager FinanceLiveShow_getPersionDataParam:nil withSuccessBlock:^(NSDictionary *obj) {
                
                
                [self hideHud];
                if([obj[@"ret"] intValue] == 0){
                    
                    ModuleItem *item = [ModuleItem new];
                    item.menuName = @"全部市场";
                    item.menuId = @"0";
                    self.titleMutableArray = [NSMutableArray array];
                    [self.titleMutableArray addObject:item];
                    [self.titleMutableArray addObjectsFromArray:[ModuleItem mj_objectArrayWithKeyValuesArray:object[@"data"]]];
                    
                    //   self.titleMutableArray = [ModuleItem mj_objectArrayWithKeyValuesArray:object[@"data"][@"moduleList"]];
                    caigou = obj[@"data"][@"caigou"];
                    
                    //添加分类滚动视图
                    [self addCategoryScrollView];
                    //添加内容滚动视图
                    [self addContentScrollView];
                    //    //添加子控制器
                    [self addChildViewControllers:obj[@"data"][@"categoryList"]];
                    
                    [self addAreaVCWithArray:obj[@"data"][@"moduleList"]];
                    
                    [self.view addSubview:self.topBtn];
                    [self.view bringSubviewToFront:self.topBtn];
                    
                }else{
                    
                    
                }
                
            } withFailureBlock:^(NSError *error) {
                
                [self showHint:error.description];
                
            }];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        //        [self showHint:error.description];
        
    }];
    
    [self showHudInView:self.view];
    
   
}

- (void)loadad{
    
//    [self showHudInView:self.view];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_getad:nil withSuccessBlock:^(NSDictionary *object) {
        

        if([object[@"ret"] intValue] == 0){
            
            adList = [object[@"data"] copy];

              [self loadCate];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
//        [self showHint:error.description];
        
    }];
}


#pragma mark - SearchViewDelegate

- (void)searchButtonWasPressedForSearchView:(SearchView *)searchView {
    SearchDetailViewController *searchViewController = [[SearchDetailViewController alloc] init];
    searchViewController.placeHolderText = searchView.textField.text;
    searchViewController.searchData = _searchData;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navigationController
                       animated:NO
                     completion:nil];
    [searchViewController setPush:^(NSDictionary *dic){
       
        
        [self enterRoom:dic];
    }];
    
}

- (void)enterRoom:(NSDictionary *)dic{
    
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_enterRoom:@{@"roomId":dic[@"roomId"],@"userId":account.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            if ([object[@"data"][@"star"][@"status"] intValue] == 1) {
                
                ALinLiveCollectionViewController *vc = [ALinLiveCollectionViewController new];
                
                vc.live = [LiveUserModel mj_objectWithKeyValues:object[@"data"][@"star"]];
                
                vc.live.chatAddress =object[@"data"][@"chat"][@"chatAddress"];
                vc.live.chatKey = object[@"data"][@"chat"][@"chatKey"];
                vc.live.isFollow =[object[@"data"][@"isFollow"] boolValue];
                
                if(!(vc.live.chatAddress.length >0))
                {
                    [BAIRUITECH_BRTipView showTipTitle:@"服务端返回json格式错误" delay:1];
                    return ;
                }
                
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                
                FabricWebViewController *vc = [[FabricWebViewController alloc]init];
                vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/shop.html?id=%@&userId=%@&token=%@",object[@"data"][@"star"][@"userId"],account.userId,account.token];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
}


- (void)addCategoryScrollView{
    
    @weakify(self);
    
    
    UIView* containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
    }];
    
    //分类按钮父视图
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    self.categoryScrollView = scrollView;
    [containerView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //@strongify(self);
        make.top.equalTo(containerView).offset(0);
        make.left.equalTo(containerView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 40));
    }];
    
    //设置contentSize
//    if (_titleMutableArray.count <= 4) {
//        
//        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 40);
//    }
//    else{
//        
//        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH/4*_titleMutableArray.count, 40);
//    }
    
    scrollView.contentSize = CGSizeMake(70 *_titleMutableArray.count, 40);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES;
    self.categoryScrollView.backgroundColor = [UIColor whiteColor];
    
    //添加按钮
    float width ;
    float height = 38;
    
//    if (_titleMutableArray.count == 1) {
//        
//        width = SCREEN_WIDTH;
//    }
//    else if (_titleMutableArray.count == 2) {
//        
//        width = SCREEN_WIDTH/2;
//    }
//    else if (_titleMutableArray.count == 3) {
//        
//        width = SCREEN_WIDTH/3;
//    }
//    else{
//        
//        width = SCREEN_WIDTH/4;
//    }
    
    if (_titleMutableArray.count>0) {
        width = 70;
    }
    else
    {
        width = 0;
    }
    
    
    for (int i = 101; i <= _titleMutableArray.count+100; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        ModuleItem *item = _titleMutableArray[i-101];
        
        [btn setTitle:item.menuName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:MainColor forState:UIControlStateSelected];
        [btn setFrame:CGRectMake(width*(i-101), 0, width, height)];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        if (i == 101) {
            
            btn.selected = YES;
        }
    }
    //灰色分割线
//    UIView * line = [[UIView alloc] init];
//    [self.categoryScrollView addSubview:line];
//    line.backgroundColor = [BAIRUITECH_Utils colorWithHexString:@"#d2d2d2"];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        @strongify(self);
//        make.top.equalTo (self.categoryScrollView).mas_offset(39);
//        make.left.equalTo(self.categoryScrollView);
//        make.size.mas_equalTo(CGSizeMake(self.categoryScrollView.contentSize.width, 1));
//    }];
    //黄色横线
    UIView * rLView = [[UIView alloc] init];
    self.redLineView = rLView;
    if (_titleMutableArray.count == 1) {
        
        rLView.hidden = YES;
    }
    rLView.backgroundColor = MainColor;
    [self.categoryScrollView addSubview:rLView];
    [rLView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.top.equalTo (self.categoryScrollView).mas_offset(30);
        
        UIButton * btn = (UIButton *)[self.view viewWithTag:101];
        make.centerX.equalTo(btn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(btn.frame.size.width-10, 2));
    }];
    
    
    //添加分割图标
    UIImageView* split_lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split_line"]];
    [containerView addSubview:split_lineView];
    [split_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(containerView).mas_offset(7);
        make.left.equalTo(self.categoryScrollView.mas_right);
        make.size.mas_equalTo(CGSizeMake(5, 25));
    } ];
    //添加分类图标
    UIImageView* item_homeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_home"]];
    item_homeView.userInteractionEnabled = YES;
    [containerView addSubview:item_homeView];
    [item_homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(12);
        make.right.equalTo(containerView).offset(-18);
        make.size.mas_equalTo(CGSizeMake(19, 17));
    }];
    
    [item_homeView bk_whenTapped:^{
        YJLog(@"点击了分类按钮");
        
        areavc.view.hidden  = NO;
    }];
    
}

- (void)addContentScrollView{
    
    @weakify(self);
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    self.contentScrollView = scrollView;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.top.equalTo(self.categoryScrollView.mas_bottom);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-40));
    }];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*(self.titleMutableArray.count+0), SCREEN_HEIGHT-64-40);
}


- (void)addChildViewControllers:(NSArray *)ary{
    
    for (int i = 0; i < self.titleMutableArray.count; i++) {
        
        @weakify(self);
        FabricContentViewController * VC = [[FabricContentViewController alloc] init];
//        NSDictionary * titleDict = self.contentTypeListArr[i];
//        VC.typeId = titleDict[@"id"];
        if (i==0) {
            
            
            VC.adlist = adList;
           
            VC.firstPageList = ary;
            VC.caigou = caigou;
        
//        }else if(i == self.titleMutableArray.count){
//            
//            ModuleItem *item = [ModuleItem new];
//            item.moduleId = @"33";
//            VC.item = item;
//            lastVC = VC;
//   
        }else{
            
            VC.item = self.titleMutableArray[i];
        }
        [self addChildViewController:VC];
        [self.contentScrollView addSubview:VC.view];
        [VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            make.top.equalTo(self.categoryScrollView.mas_bottom);
            make.left.equalTo(self.contentScrollView).offset(SCREEN_WIDTH*i);
            make.size.mas_equalTo(self.contentScrollView);
        }];
        //VC.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    }

    
}



#pragma mark --buttonClickedAction
- (void)buttonClickedAction:(UIButton *)btn{
    NSLog(@"buttonClickedAction");
    //分类按钮动画
    [self updateBtn:btn];
    //内容视图动画
    [self.contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(btn.tag-101), 0) animated:YES];
}
- (void)updateBtn:(UIButton *)btn{
    
    @weakify(self);
    for (int i = 101; i <= self.titleMutableArray.count+100; i++) {
        
        UIButton * button = (UIButton *)[self.view viewWithTag:i];
        if (btn.tag == button.tag) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                @strongify(self);
                button.selected = YES;
                self.redLineView.hidden = NO;
                [self.redLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.categoryScrollView).mas_offset(30);
                    make.centerX.equalTo(btn.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(btn.frame.size.width-10, 2));
                }];
                [self.categoryScrollView layoutIfNeeded];
            }];
        }
        else{
            
            button.selected = NO;
        }
    }
}

#pragma mark --  UIScrollViewDelegate
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView == _contentScrollView) {
        
        index = scrollView.contentOffset.x / SCREEN_WIDTH;
        
//        if (index == _titleMutableArray.count) {
//            
//            [self scrollToLast];
//        }
//        else{
        
            UIButton * btn = [self.view viewWithTag:index+101];
            [self buttonClickedAction:btn];
//        }
        
    }
}

//- (void)scrollToLast{
//    
//    [self.contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*_titleMutableArray.count, 0) animated:YES];
//    [self updateBtn:nil];
//    self.redLineView.hidden = YES;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}




-(void)favItemClick:(UIBarButtonItem *)item
{
    NSLog(@"点击了我的关注");
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_fans:@{@"userId":user.userId,@"pageNo":@(1),@"pageSize":@"10"} withSuccessBlock:^(NSDictionary *object) {
        

        if([object[@"ret"] intValue] == 0){
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in object[@"data"][@"users"]) {
                
                PopoverModel *model =[PopoverModel mj_objectWithKeyValues:dic];
                if (model) {
                    [list addObject:model];
                }
            }
            if (list.count>0) {
                
                FaPopoverView *popoverView = [FaPopoverView FapopoverView];
                popoverView.hideAfterTouchOutside = YES; // 点击外部时不允许隐藏
                [popoverView showToPoint:CGPointMake(SCREEN_WIDTH-30, 64) withActions:list];
                
            }else{
                
                [BAIRUITECH_BRTipView showTipTitle:@"暂无信息" delay:1.5];
            }
           

            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        
        
    }];
    
}

-(void)historyItemClick
{
    NSLog(@"点击了我的历史");
    
    HisViewController *vc = [HisViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
