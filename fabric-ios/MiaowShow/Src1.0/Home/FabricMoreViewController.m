//
//  FabricMoreViewController.m
//  MiaowShow
//
//  Created by sam on 2017/9/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "FabricMoreViewController.h"
#import "ALinLiveCollectionViewController.h"
#import "FabricWebViewController.h"
// Models
#import "LiveUserModel.h"
//#import "DCGridItem.h"
//#import "DCRecommendItem.h"
// Views
//#import "DCNavSearchBarView.h"

/* cell */
#import "FabricLiveCell.h"

/* head */
#import "FabricHeadView.h"  //
#import "HomeReusableView.h"
/* foot */


// Vendors
// Categories
// Others

@interface FabricMoreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic) UIButton *topBtn;

@property (strong, nonatomic) NSMutableArray *list;


@property (assign, nonatomic) int pageN;


@end
/* cell */
static NSString *const FabricLiveCellID = @"FabricLiveCell";

/* head */
static NSString *const FabricHeadViewID = @"FabricHeadView";
static NSString *const HomeHeadViewID = @"home";
/* foot */

@implementation FabricMoreViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 4;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        UINib *nib = [UINib nibWithNibName:@"FabricLiveCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:FabricLiveCellID];
        
        
        [_collectionView registerClass:[FabricHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FabricHeadViewID];
        
        
        [_collectionView registerClass:[HomeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeadViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


#pragma mark - LifeCyle

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
}



#pragma mark - initialize
- (void)setUpBase
{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.titleView = nil;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.title = _cateDic[@"categoryName"];
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
    NSDictionary *dic = @{@"categoryId":_cateDic[@"categoryId"],@"pageNo":@(_pageN),@"pageSize":@"10"};
    [BAIRUITECH_NetWorkManager FinanceLiveShow_updatePersionDataParam:dic withSuccessBlock:^(NSDictionary *object) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            [weakSelf.list addObjectsFromArray:[object[@"data"][@"roomList"] mutableCopy]];
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

#pragma mark - 问询台
- (void)ask{
    
    
}

#pragma mark - 导航栏处理


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
    
    FabricLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FabricLiveCellID forIndexPath:indexPath];
    [cell.imgv sd_setImageWithURL:[NSURL URLWithString:dic[@"imgPath"]] placeholderImage:[UIImage imageNamed:@"112"]];
    cell.titlelab.text = dic[@"nickName"];
    cell.sublab.text = dic[@"roomName"];
    
    gridcell = cell;
    
    
    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
//    if (kind == UICollectionElementKindSectionHeader){
//        
//        
//        if (!self.firstPageList) {
//            
//            return nil;
//        }
//        
//        NSString *title =  self.firstPageList[indexPath.section][@"categoryName"];
//        
//        if (indexPath.section == 0) {
//            FabricHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FabricHeadViewID forIndexPath:indexPath];
//            headerView.lab.text =title;
//            reusableview = headerView;
//            
//        }else{
//            
//            HomeReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeadViewID forIndexPath:indexPath];
//            headerView.titile.text = title;
//            reusableview = headerView;
//            
//        }
//        
//        
//    }
//    if (kind == UICollectionElementKindSectionFooter) {
//        
//    }
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/2-2, (SCREEN_WIDTH-4)/6 * 4 );
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //    if (indexPath.section == 3) {
    //        if (indexPath.row == 0) {
    //            layoutAttributes.size = CGSizeMake(ScreenW, ScreenW * 0.35);
    //        }else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4){
    //            layoutAttributes.size = CGSizeMake(ScreenW * 0.5, ScreenW * 0.2);
    //        }else{
    //            layoutAttributes.size = CGSizeMake(ScreenW * 0.25, ScreenW * 0.35);
    //        }
    //    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
//    if (!self.firstPageList) {
    
        return CGSizeZero;
//    }
//    
//    if (section == 0) {
//        return CGSizeMake(SCREEN_WIDTH, 200);
//    }
//    return CGSizeMake(SCREEN_WIDTH, 25);
}

#pragma mark - foot宽高
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return CGSizeMake(ScreenW, 130);  //banner
//    }
//    if (section == 1) {
//        return CGSizeMake(ScreenW, 10);  //banner
//    }
//
//    return CGSizeZero;
//}


/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic= self.list[indexPath.row];
    
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

@end
