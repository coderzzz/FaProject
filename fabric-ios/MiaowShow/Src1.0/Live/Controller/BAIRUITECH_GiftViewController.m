//
//  GiftViewController.m
//  AnyChatLive
//
//  Created by bairuitech on 16/7/19.
//  Copyright © 2016年 anychat. All rights reserved.
//

#import "BAIRUITECH_GiftViewController.h"
#import "BAIRUITECH_GiftListCollectionViewCell.h"

#import "FabricWebViewController.h"
@interface BAIRUITECH_GiftViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>


//礼物列表
@property (nonatomic, strong) UICollectionView * giftCollectionView;

//退出按钮
@property (nonatomic, strong) UIButton         * exitButton;
//分页控件
@property (nonatomic, strong) UIPageControl    * page;
//币数
@property (nonatomic, strong) UILabel          * coinLabel;
//充值
@property (nonatomic, strong) UIButton         * payButton;
//发送
@property (nonatomic, strong) UIButton         * sendButton;

@property (nonatomic, strong) BAIRUITECH_GiftListModel *sendGiftModel;
@end

@implementation BAIRUITECH_GiftViewController

-(void)setGiftListArray:(NSMutableArray *)giftListArray {
    _giftListArray = giftListArray;
    [self.giftCollectionView reloadData];
}
#pragma mark --view生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置透明黑色背景
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    //退出按钮
    [self readyExitButton];
    //collectionView初始化
    [self readyCollectionView];
    //添加分页控件
    [self readyPageController];
//    //添加币数label
//    [self readyCoinLabel];
//    //添加充值button
    [self readyPayButton];
    //添加发送button
    [self readySendButton];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --初始化数据源
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}
#pragma mark 0--退出按钮
-(void)readyExitButton{
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [self.exitButton setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 5)];
    [self.exitButton addTarget:self action:@selector(exitButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitButton];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.exitButton.hidden = YES;
}
#pragma mark --点击退出按钮事件
-(void)exitButtonClickedAction{
    
    if ([self.delegate respondsToSelector:@selector(giftViewController:didClickExitButton:)]) {
        [self.delegate giftViewController:self didClickExitButton:self.exitButton];
    }
}
#pragma mark 1--初始化collectionView
-(void)readyCollectionView{
    
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.giftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)  collectionViewLayout:flow];
    self.giftCollectionView.showsHorizontalScrollIndicator = NO;
    self.giftCollectionView.backgroundColor = [UIColor clearColor];
    self.giftCollectionView.pagingEnabled = YES;
    self.giftCollectionView.bounces = YES;
    [self.view addSubview:self.giftCollectionView];
//    self.giftCollectionView.backgroundColor = [UIColor redColor];
    [self.giftCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exitButton).offset(5);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(-80);
        make.centerX.equalTo(self.view);
    }];
       //注册
    [self.giftCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BAIRUITECH_GiftListCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"BAIRUITECH_GiftListCollectionViewCell"];
    self.giftCollectionView.delegate = self;
    self.giftCollectionView.dataSource = self;
    
}
#pragma mark 2--添加分页控件
-(void)readyPageController{
    
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //self.page.numberOfPages = 2;
    [self.view addSubview:self.page];
    [self.page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 5));
    }];
}
#pragma mark 3--添加币数label
-(void)readyCoinLabel{
    
    self.coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.coinLabel.textColor = [UIColor whiteColor];
    self.coinLabel.text = @"币0";
    self.coinLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.coinLabel];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
}
#pragma mark 4--添加充值button
-(void)readyPayButton{
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setTitle:@"充值" forState:UIControlStateNormal];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payButton.backgroundColor = MainColor;
    [self.payButton addTarget:self action:@selector(payButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    self.payButton.layer.cornerRadius = 3;
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.payButton.layer.borderWidth = 1;
}
#pragma mark --充值按钮点击事件
-(void)payButtonClickedAction:(UIButton *)sender{
    YJLog(@"点击了【充值】按钮");
    if ([self.delegate respondsToSelector:@selector(giftViewController:didClickPayButton:)]) {
        [self.delegate giftViewController:self didClickPayButton:sender];
    }
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    FabricWebViewController *vc = [[FabricWebViewController alloc]init];
    vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/fmsBusi/beans-recharge.html?userId=%@&token=%@",user.userId,user.token];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

}
#pragma mark 5--添加发送button
-(void)readySendButton{
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"AnyChatSDKResources.bundle/直播/live礼物发送按钮"] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}
#pragma mark --发送按钮点击事件
-(void)sendButtonClickedAction{
    
    YJLog(@"点击了【发送】按钮");
    if (self.sendGiftModel) {
        if ([self.delegate respondsToSelector:@selector(giftViewController:gift:)]) {
            [self.delegate giftViewController:self gift:self.sendGiftModel];
        }
        
    }
}
#pragma mark --获取礼物列表数据
#pragma mark --collectionView协议方法
//设置itme大小
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_WIDTH < SCREEN_HEIGHT) {//竖屏
        float width = SCREEN_WIDTH / 4;
        return CGSizeMake(width, width + 20);
    }
    else{
        float width = SCREEN_HEIGHT / 4;
        return CGSizeMake(width, width + 20);
    }
}
//一组返回item数量

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.giftListArray.count;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    YJLog(@"--------->>>>>>>>>礼物列表个数%lu", (unsigned long)[self.giftListArray[section] count]);
    return [self.giftListArray[section] count];
}
//单元格复用
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //去复用队列里找 有没有空闲的cell 如果没有 就自动创建一个
    BAIRUITECH_GiftListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BAIRUITECH_GiftListCollectionViewCell" forIndexPath:indexPath];
    BAIRUITECH_GiftListModel * giftListModel = self.giftListArray[indexPath.section][indexPath.row];
    [cell setCellWithModel:giftListModel];
    
    return cell;
}
//本次选中
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    BAIRUITECH_GiftListModel * giftListModel = self.giftListArray[indexPath.row];
    BAIRUITECH_GiftListModel * giftListModel =self.giftListArray[indexPath.section][indexPath.row];
    giftListModel.isSelected = YES;
    BAIRUITECH_GiftListCollectionViewCell * cell = (BAIRUITECH_GiftListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectImageView.hidden = NO;
    [self.sendButton setBackgroundColor:MainColor];
    [self.sendButton setEnabled:YES];
//    self.giftId = giftListModel.giftId;
    self.giftCount = 1;
//    self.wealth = giftListModel.wealthValue;
    self.sendGiftModel = giftListModel;
}
//前次选中
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    BAIRUITECH_GiftListModel * giftListModel = self.giftListArray[indexPath.section][indexPath.row];
//    giftListModel.giftName = self.giftListArray[indexPath.row];
//    giftListModel.giftPicUrl =self.giftListArray[indexPath.row];
    giftListModel.isSelected = NO;
    BAIRUITECH_GiftListCollectionViewCell * cell = (BAIRUITECH_GiftListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectImageView.hidden = YES;
}
//滑动变化分页控件当前点
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / self.giftCollectionView.width;
    self.page.currentPage = page;
}
//设置每组cell的边界
-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//cell最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置cell最小的列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
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
