//
//  FabricHomeViewController.m
//  FabricNew
//
//  Created by 严军 on 2017/8/20.
//  Copyright © 2017年 严军. All rights reserved.
//

#import "GetOrderController.h"
#import "GetOrderContentController.h"

@interface GetOrderController ()<UIScrollViewDelegate>

@property (weak, nonatomic  ) UIScrollView   * categoryScrollView;//分类按钮父视图
@property (weak, nonatomic  ) UIScrollView   * contentScrollView;//子控制器父视图
@property (weak, nonatomic  ) UIView         * redLineView;//红色横线
@property (strong, nonatomic) NSMutableArray * titleMutableArray;//标题数组
@property (strong, nonatomic) NSMutableArray * childVCMutableArray;//子控制器数组
@property (assign, nonatomic) int index;//子控制器数组下标

@end

@implementation GetOrderController

{
//    NSInteger index;
}


- (NSMutableArray *)childVCMutableArray{
    
    if (_childVCMutableArray == nil) {
        
        _childVCMutableArray = [NSMutableArray new];
    }
    return _childVCMutableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title= @"委托订单";
//    
//    //添加右侧按钮
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(favItemClick:)];
//    
//    self.navigationItem.rightBarButtonItem = rightBarItem;
//    

    
    [self loadCate];
    



    
}


- (void)loadCate{
    
    
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_GetOderTypes:@{@"type":@"1"} withSuccessBlock:^(NSDictionary *object) {
        
        
        
        //        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            self.titleMutableArray = [object[@"data"] mutableCopy];



            //添加分类滚动视图
            [self addCategoryScrollView];
            //添加内容滚动视图
            [self addContentScrollView];
            //    //添加子控制器
            [self addChildViewControllers:[object[@"data"] mutableCopy]];
            
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        //        [self showHint:error.description];
        
    }];
    
    [self showHudInView:self.view];
    
    
}


- (void)addCategoryScrollView{
    
    @weakify(self);
    
    
    UIView* containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(0);
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
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
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
    
    scrollView.contentSize = CGSizeMake(70 * _titleMutableArray.count, 40);
    
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
        width =  70 ;
    }
    else
    {
        width = 0;
    }
    
    
    for (int i = 101; i <= _titleMutableArray.count+100; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *item = _titleMutableArray[i-101];
        
        [btn setTitle:item[@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:Color forState:UIControlStateSelected];
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
    rLView.backgroundColor = Color;
    [self.categoryScrollView addSubview:rLView];
    [rLView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.top.equalTo (self.categoryScrollView).mas_offset(38);
        
        UIButton * btn = (UIButton *)[self.view viewWithTag:101];
        make.centerX.equalTo(btn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(btn.frame.size.width-10, 2));
    }];
    
    
//    //添加分割图标
//    UIImageView* split_lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split_line"]];
//    [containerView addSubview:split_lineView];
//    [split_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.top.equalTo(containerView).mas_offset(7);
//        make.left.equalTo(self.categoryScrollView.mas_right);
//        make.size.mas_equalTo(CGSizeMake(5, 25));
//    } ];
//    //添加分类图标
//    UIImageView* item_homeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_home"]];
//    item_homeView.userInteractionEnabled = YES;
//    [containerView addSubview:item_homeView];
//    [item_homeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(containerView).offset(12);
//        make.right.equalTo(containerView).offset(-18);
//        make.size.mas_equalTo(CGSizeMake(19, 17));
//    }];
//    
//    [item_homeView bk_whenTapped:^{
//        YJLog(@"点击了分类按钮");
//        
//    }];
    
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
        GetOrderContentController * VC = [[GetOrderContentController alloc] init];
        VC.dic = ary[i];
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
                    
                    make.top.equalTo(self.categoryScrollView).mas_offset(38);
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
        
        _index = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        //        if (index == _titleMutableArray.count) {
        //
        //            [self scrollToLast];
        //        }
        //        else{
        
        UIButton * btn = [self.view viewWithTag:_index+101];
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
//    NSLog(@"点击了我的关注");
//    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
//    
//    [BAIRUITECH_NetWorkManager FinanceLiveShow_fans:@{@"userId":user.userId,@"pageNo":@(1),@"pageSize":@"10"} withSuccessBlock:^(NSDictionary *object) {
//        
//        
//        if([object[@"ret"] intValue] == 0){
//            NSMutableArray *list = [NSMutableArray array];
//            for (NSDictionary *dic in object[@"data"][@"users"]) {
//                
//                PopoverModel *model =[PopoverModel mj_objectWithKeyValues:dic];
//                if (model) {
//                    [list addObject:model];
//                }
//            }
//            if (list.count>0) {
//                
//                FaPopoverView *popoverView = [FaPopoverView FapopoverView];
//                popoverView.hideAfterTouchOutside = YES; // 点击外部时不允许隐藏
//                [popoverView showToPoint:CGPointMake(SCREEN_WIDTH-30, 64) withActions:list];
//                
//            }else{
//                
//                [BAIRUITECH_BRTipView showTipTitle:@"暂无信息" delay:1.5];
//            }
//            
//            
//            
//        }else{
//            
//            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
//        }
//        
//    } withFailureBlock:^(NSError *error) {
//        
//        
//        
//    }];
//    
}

-(void)historyItemClick
{
    NSLog(@"点击了我的历史");
    
//    HisViewController *vc = [HisViewController new];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
