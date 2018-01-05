//
//  FabricAgentViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "FabricAgentViewController.h"

#import "ALinLiveCollectionViewController.h"
#import "FabricWebViewController.h"
// Models
#import "LiveUserModel.h"
//#import "DCGridItem.h"
//#import "DCRecommendItem.h"
// Views
//#import "DCNavSearchBarView.h"

/* cell */

#import "AskCell.h"

/* head */
#import "AgentReusableView.h" //

/* foot */


// Vendors
// Categories
// Others

@interface FabricAgentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic) UIButton *topBtn;

@property (strong, nonatomic) NSDictionary *data;

@end
/* cell */
static NSString *const FabricLiveCellID = @"ask";

/* head */
static NSString *const FabricHeadViewID = @"AgentReusableView";
/* foot */

@implementation FabricAgentViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing =6;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 );
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        UINib *nib = [UINib nibWithNibName:@"AskCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:FabricLiveCellID];
        [_collectionView registerClass:[AgentReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FabricHeadViewID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - LifeCyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
}

#pragma mark - initialize
- (void)setUpBase
{
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"问询台";
     self.edgesForExtendedLayout = UIRectEdgeNone;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstLoad)];
    
    [self.collectionView.mj_header beginRefreshing];
    

}

#pragma mark - 加载数据
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)firstLoad{
    
    NSLog(@"firstLoad");
    
    __weak  typeof(self) weakSelf = self;
    [BAIRUITECH_NetWorkManager FinanceLiveShow_resetPasswordParam:nil withSuccessBlock:^(NSDictionary *object) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            weakSelf.data = [object[@"data"] copy];
            [weakSelf.collectionView reloadData];
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        [weakSelf.collectionView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark -

#pragma mark - 导航栏处理


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.data[@"xiaoerRoomList"] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    NSDictionary *dic = self.data[@"xiaoerRoomList"][indexPath.row];
    AskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FabricLiveCellID forIndexPath:indexPath];
    [cell.imgv sd_setImageWithURL:[NSURL URLWithString:dic[@"imgPath"]] placeholderImage:[UIImage imageNamed:@"112"]];
    cell.titlelab.text = dic[@"nickName"];
    cell.sublab.text = dic[@"roomName"];
    
    gridcell = cell;
    
    
    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            AgentReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FabricHeadViewID forIndexPath:indexPath];
            headerView.list = self.data[@"kefuRoomList"];
            [headerView setBlock:^(NSDictionary *dic){
               
                 [self pushLive:dic];
            }];
            reusableview = headerView;
            
        }
        
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        
    }
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return CGSizeMake(SCREEN_WIDTH/3-5,(SCREEN_WIDTH/3-15)/3 * 4 );
    }
    
    return CGSizeZero;
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
    
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 220);
    }
    return CGSizeZero;
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
    
    NSDictionary *dic = self.data[@"xiaoerRoomList"][indexPath.row];
    
    
    [self pushLive:dic];
    
    
    
}

- (void)pushLive:(NSDictionary *)dic{
    
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
