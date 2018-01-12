//
//  VideoContentViewController.m
//  MiaowShow
//
//  Created by sam on 2017/9/30.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "GetOrderContentController.h"
#import "CancelObjController.h"
#import "DoneObjController.h"
#import "LookObjController.h"
#import "PayTypeViewController.h"
#import "GetOrderDetailController.h"
#import "AddPriceController.h"
#import "JudgeController.h"
#import "FabricWebViewController.h"
#import "EaseMessageViewController.h"
#import "DelFOController.h"
#import "FindObjController.h"
// Models
// Views

/* cell */
#import "GetOrderListCell.h"

/* head */
/* foot */
#define TagH 30

// Vendors
// Categories
// Others

@interface GetOrderContentController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */


@property (strong, nonatomic) NSMutableArray *actions;
@property (strong, nonatomic) NSMutableArray *types;

@property (strong, nonatomic) NSMutableArray *list;


@property (assign, nonatomic) int pageN;




@end
/* cell */
static NSString *const FabricLiveCellID = @"gr";

/* head */
/* foot */

@implementation GetOrderContentController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 4;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64- 40);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        UINib *nib = [UINib nibWithNibName:@"GetOrderListCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:FabricLiveCellID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray *)actions{
    
    if (!_actions) {
        
        _actions = @[@[@"撤单&0",@"编辑&0",@"付款&1"],
                       @[@"撤单&0",@"编辑&0",@"加价&1"],
                       @[@"撤单&0"],
                       @[@"查看撤单原因&0",@"删除委托&0",@"重新发布&1"],
                       @[@"撤单&0",@"确认样品&1"],
                       @[@"查看样品&1"],
                       @[@"查看样品&0",@"查看物流&0",@"确认收货&1"],
                       @[@"删除委托&0",@"查看商家信息&0",@"评价&1"],
                       @[@"删除委托&0",@"查看商家信息&0"]].mutableCopy;
    }
    return _actions;
}
- (NSMutableArray *)types{
    
    if (!_types) {
        
        _types = @[@"1",
                     @"3",
                     @"5",
                     @"15",
                     @"6",
                     @"7",
                     @"9",
                     @"11",
                     @"20"].mutableCopy;
    }
    return _types;
}
#pragma mark - LifeCyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pay:) name:@"PaySucceed" object:nil];
    
    [self setUpBase];
}

- (void)pay:(NSNotification *)notif{
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - initialize
- (void)setUpBase
{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstLoad)];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    
}


#pragma mark - 加载数据


- (void)firstLoad{
    
    
    
    _pageN = 1;
    
    self.list = [NSMutableArray array];
    
    [self getData];
}

- (void)loadMore{
    
    
    
    _pageN += 1;
    
    [self getData];
}

- (void)getData{
    
    __weak  typeof(self) weakSelf = self;
     BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    NSDictionary *dic = @{@"statusId":self.dic[@"statusId"],@"custId":account.userId,@"pageNo":@(_pageN),@"pageSize":@"10"};
    [BAIRUITECH_NetWorkManager FinanceLiveShow_GetOderList:dic withSuccessBlock:^(NSDictionary *object) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            [weakSelf.list addObjectsFromArray:[object[@"data"][@"askList"] mutableCopy]];
            [weakSelf.collectionView reloadData];
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
    
}

- (NSMutableArray *)getTagsWithIndex:(int)index{
    
    NSMutableArray *temp = [NSMutableArray array];
    
    if (index<self.actions.count && index>=0) {
        
        NSArray *tags = self.actions[index];
        for (NSString *str in tags) {
            
            NSArray *datas = [str componentsSeparatedByString:@"&"];
            ZZTag *tag = [ZZTag new];
            tag.title = datas.firstObject;
            tag.color = [datas.lastObject isEqualToString:@"1"]?[UIColor redColor]:[UIColor darkGrayColor];
            tag.height = TagH;
            [temp addObject:tag];
            
        }
    }
    
    
//    NSArray *tags = self.actions[index];
//    for (NSString *str in tags) {
//        
//        NSArray *datas = [str componentsSeparatedByString:@"&"];
//        ZZTag *tag = [ZZTag new];
//        tag.title = datas.firstObject;
//        tag.color = [datas.lastObject isEqualToString:@"1"]?[UIColor redColor]:[UIColor darkGrayColor];
//        tag.height = TagH;
//        [temp addObject:tag];
//        
//    }
    return temp;
    
}

#pragma mark - Alert

- (void)showAlertWithTag:(ZZTag *)tag{
    
    NSDictionary *dic = self.list[tag.tag];
    NSLog(@"%@",tag.title);
    if ([tag.title isEqualToString:@"撤单"]) {
        
        CancelObjController *vc = [[CancelObjController alloc]init];
        vc.orderID = [NSString stringWithFormat:@"%@",dic[@"askId"]];
        [vc show];
        return;
    }
    if ([tag.title isEqualToString:@"编辑"]) {
        
        FindObjController *vc = [FindObjController new];
        vc.dic = dic;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([tag.title isEqualToString:@"付款"]) {
        
        NSDictionary *tradeDic = @{@"outTradeNo":dic[@"askNo"],@"finalPrice":dic[@"goodsAmt"],@"description":@"goodsName"};
        PayTypeViewController *vc = [PayTypeViewController new];
        vc.tradeDict = tradeDic;
        [vc show];
        
        return;
    }
    if ([tag.title isEqualToString:@"加价"]) {
        
        AddPriceController *vc = [[AddPriceController  alloc]init];
        vc.dic = dic;
        [vc show];
        
        return;
    }
    
    if ([tag.title isEqualToString:@"查看撤单原因"]) {
        
        [self showHint:[NSString stringWithFormat:@"%@",dic[@"cancelReason"]]];
        
        return;
    }
    
    
    if ([tag.title isEqualToString:@"删除委托"]) {
        
        
        DelFOController *Vc = [DelFOController new];
        Vc.dic = dic;
        [Vc setDel:^{
           
            [self.list removeObject:dic];
            [self.collectionView reloadData];
        }];
        [Vc show];
        return;
    }
    if ([tag.title isEqualToString:@"重新发布"]) {
        
        [self showHudInView:self.view];
        BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
        [BAIRUITECH_NetWorkManager FinanceLiveShow_reGO:@{@"askId":dic[@"askId"],@"custId":account.userId} withSuccessBlock:^(NSDictionary *object) {
            
            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
                
                [self.collectionView.mj_header beginRefreshing];
                
            }else{
                
               
            }
            
        } withFailureBlock:^(NSError *error) {
            
            [self showHint:error.description];
            YJLog(@"%@",error);
            
        }];
        
        return;
    }
    if ([tag.title isEqualToString:@"确认样品"]) {
        
        DoneObjController *vc = [[DoneObjController alloc]init];
        vc.orderID = dic[@"askId"];
        [vc show];
        
        return;
    }
    if ([tag.title isEqualToString:@"查看样品"] || [tag.title isEqualToString:@"查看商家信息"]) {
        
        LookObjController *vc = [[LookObjController alloc]init];
        vc.orderID = dic[@"askId"];
        [vc show];
        
        return;
    }
    if ([tag.title isEqualToString:@"查看物流"]) {
        
        [self showHudInView:self.view];
        [BAIRUITECH_NetWorkManager FinanceLiveShow_shunfeng:@{@"askId":dic[@"askId"]} withSuccessBlock:^(NSDictionary *object) {
            
//            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
//                NSString *str;
        
                FabricWebViewController *vc = [[FabricWebViewController alloc]init];
                vc.strUrl = [[NSString stringWithFormat:@"%@",object[@"data"][@"url"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else{
                
                
            }
            
        } withFailureBlock:^(NSError *error) {
            
            [self showHint:error.description];
            YJLog(@"%@",error);
            
        }];
        return;
    }
    if ([tag.title isEqualToString:@"确认收货"]) {
        
        [self showHudInView:self.view];
        BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
        [BAIRUITECH_NetWorkManager FinanceLiveShow_doneGOADD:@{@"askId":dic[@"askId"],@"custId":account.userId} withSuccessBlock:^(NSDictionary *object) {
            
            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
                
                [self.collectionView.mj_header beginRefreshing];
                
            }else{
                
                
            }
            
        } withFailureBlock:^(NSError *error) {
            
            [self showHint:error.description];
            YJLog(@"%@",error);
            
        }];
        return;
    }
    
    if ([tag.title isEqualToString:@"评价"]) {
        
        JudgeController *vc = [JudgeController new];
        vc.dic = dic;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    

    return self.list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    

    
    NSDictionary *dic = self.list[indexPath.row];
    GetOrderListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FabricLiveCellID forIndexPath:indexPath];
    
    [cell.objImgv sd_setImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    cell.objTitle.text = dic[@"goodsName"];
    cell.objDetail.text = dic[@"descriptions"];
    cell.statueLab.text = dic[@"buyStatusName"];
    NSArray *marks = [dic[@"marks"] componentsSeparatedByString:@","];
    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *mark in marks) {
        
        ZZTag *tag = [ZZTag new];
        tag.title = mark;
        tag.color = Color;
        tag.height=24;
        [tags addObject:tag];
    }
    cell.tagView.list = tags;
    cell.allPirce.text = [NSString stringWithFormat:@"￥%@",dic[@"goodsAmt"]];
    [cell.actionTag setDidSelect:^(ZZTag *tag){
       
        tag.tag = indexPath.row;
        [self showAlertWithTag:tag];
    }];
    NSString *statue = [NSString stringWithFormat:@"%@",dic[@"statusId"]];
//        if (indexPath.row <=8) {
//            statue = self.types[indexPath.row];
//        }
    CGFloat w = 0;
    if ([self.types containsObject:statue]) {
        
        cell.actionTag.list = [self getTagsWithIndex:(int)[self.types indexOfObject:statue]];
        w = [self getWidth:(int)[self.types indexOfObject:statue]];
    }else if([statue isEqualToString:@"8"]){
        
        cell.actionTag.list = [self getTagsWithIndex:2];
        w = [self getWidth:2];
    }else{
        
         cell.actionTag.list = [NSMutableArray array];
    }
    //

    cell.ctLab.text = [NSString stringWithFormat:@"发布时间:%@",[NSDate dateWithTimesTamp:dic[@"createdTime"]]];
    if ([dic.allKeys containsObject:@"orderTakeTime"]) {
        
        cell.gtLab.text = [NSString stringWithFormat:@"接单时间:%@",[NSDate dateWithTimesTamp:dic[@"orderTakeTime"]]];
    }
    else{
        cell.gtLab.text = nil;
    }
    
   
    if ([dic.allKeys containsObject:@"lookManNickName"]) {
        
        cell.nameLab.text = dic[@"lookManNickName"];
        [cell setChat:^{
            
            EaseMessageViewController *chatVC =[[EaseMessageViewController alloc]initWithConversationChatter:@""];
            chatVC.toUserId = [NSString stringWithFormat:@"%@",dic[@"lookManCustId"]];
            chatVC.showRefreshHeader = YES;
            chatVC.title = dic[@"lookManNickName"];
            [self.navigationController pushViewController:chatVC animated:YES];
        }];
        cell.topView.hidden = NO;
        cell.actionTag.frame=CGRectMake(SCREEN_WIDTH - w, 180, w, TagH);
    }else{
        
        cell.actionTag.frame=CGRectMake(SCREEN_WIDTH - w, 140, w, TagH);
        cell.topView.hidden = YES;
    }
    
    cell.actionTag.collectionView.frame=CGRectMake(0, 0, w, TagH);
    
    
    gridcell = cell;
    
    
    return gridcell;
}


- (CGFloat)getWidth:(int)index{
    
    NSArray *tags = self.actions[index];
    CGFloat width = 0;
    for (NSString *str in tags) {
        
        NSArray *datas = [str componentsSeparatedByString:@"&"];
        width += [ZZTag dc_calculateTextSizeWithText:datas.firstObject WithMaxW:TagH].width;
        
    }
    return width + 30;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        return nil;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        
    }
    return reusableview;
}



#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.list[indexPath.row];

    if ([dic.allKeys containsObject:@"lookManNickName"]) {
        
        return CGSizeMake(SCREEN_WIDTH, 210);
    }else{
        
        return CGSizeMake(SCREEN_WIDTH, 170);
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;

}

#pragma mark - foot宽高


/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dic = self.list[indexPath.row];
    GetOrderDetailController *vc = [[GetOrderDetailController alloc]init];
    vc.dic = dic;
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
