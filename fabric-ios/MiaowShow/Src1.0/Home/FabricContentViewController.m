
//

#import "FabricContentViewController.h"
#import "ALinLiveCollectionViewController.h"
#import "FabricMoreViewController.h"
#import "FabricAgentViewController.h"
#import "UIButton+WebCache.h"
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

@interface FabricContentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */





@property (strong, nonatomic) NSMutableArray *list;


@property (assign, nonatomic) int pageN;




@end
/* cell */
static NSString *const FabricLiveCellID = @"FabricLiveCell";

/* head */
static NSString *const FabricHeadViewID = @"FabricHeadView";
static NSString *const HomeHeadViewID = @"home";
/* foot */

@implementation FabricContentViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 4;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40);
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!(self.list.count>0) && (!self.firstPageList)) {
        
        [self.collectionView.mj_header beginRefreshing];
    }
//     [self.view bringSubviewToFront:self.topBtn];
}

#pragma mark - initialize
- (void)setUpBase
{

//    self.automaticallyAdjustsScrollViewInsets = NO;
   
    _caigou = [NSDictionary dictionary];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    if (!(self.firstPageList.count>0)) {
        
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstLoad)];
        self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
           
            [self loadMore];
        }];
    }else{
        
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstPage)];
        
    }
    
    
   
  
}

- (void)setFirstPageList:(NSArray *)firstPageList{
    
    _firstPageList = firstPageList;
    [self.collectionView reloadData];
}

#pragma mark - 加载数据
- (void)loadCate{
    
    [self showHudInView:self.view];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_getPersionDataParam:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        [self hideHud];
        [self.collectionView.mj_header endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            _caigou = object[@"data"][@"caigou"];
        //    [self addChildViewControllers:object[@"data"][@"categoryList"]];
            self.firstPageList = object[@"data"][@"categoryList"];
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
 
        [self.collectionView.mj_header endRefreshing];
    }];
}


- (void)firstPage{
    

    if (_areaName.length>0) {
        
        _firstPageList = [NSArray array];
//        _item = [ModuleItem new];
//        _item.moduleId = @"0";
        
        [self firstLoad];
    }else{
        
        [self loadCate];
    }
    

}
- (void)morePage{
    
}

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
    
//    if (_areaName.length>0){
    
        __weak  typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"moduleId":_areaName?_areaName:@"0",@"menuId":_item.menuId?_item.menuId:@"0",@"pageNo":@(_pageN),@"pageSize":@"10"};
        [BAIRUITECH_NetWorkManager FinanceLiveShow_MenuRooms:dic withSuccessBlock:^(NSDictionary *object) {
            
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
//    }
//    else{
//        
//        __weak  typeof(self) weakSelf = self;
//        NSDictionary *dic = @{@"moduleId":_item.moduleId,@"pageNo":@(_pageN),@"pageSize":@"10",@"areaName":_areaName?_areaName:@""};
//        [BAIRUITECH_NetWorkManager FinanceLiveShow_roomList:dic withSuccessBlock:^(NSDictionary *object) {
//            
//            [weakSelf.collectionView.mj_header endRefreshing];
//            [weakSelf.collectionView.mj_footer endRefreshing];
//            if([object[@"ret"] intValue] == 0){
//                
//                [weakSelf.list addObjectsFromArray:[object[@"data"][@"roomList"] mutableCopy]];
//                [weakSelf.collectionView reloadData];
//                
//            }else{
//                
//                [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
//            }
//            
//        } withFailureBlock:^(NSError *error) {
//            
//            YJLog(@"%@",error);
//            [weakSelf.collectionView.mj_header endRefreshing];
//            [weakSelf.collectionView.mj_footer endRefreshing];
//        }];
//    }

}


#pragma mark - 导航栏处理


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.firstPageList && !(_areaName.length>0)) {
        
        return self.firstPageList.count;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.firstPageList && !(_areaName.length>0)) {
        
        return [self.firstPageList[section][@"roomList"] count];
    }
    return self.list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;

    NSDictionary *dic;
    if (self.firstPageList && !(_areaName.length>0)) {
        
        dic = self.firstPageList[indexPath.section][@"roomList"][indexPath.row];
    }else{
        
        dic = self.list[indexPath.row];
    }

    FabricLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FabricLiveCellID forIndexPath:indexPath];
    [cell.imgv sd_setImageWithURL:[NSURL URLWithString:dic[@"imgPath"]] placeholderImage:[UIImage imageNamed:@"112"]];
    cell.titlelab.text = dic[@"nickName"];
    cell.sublab.text = dic[@"roomName"];

    gridcell = cell;
    

    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        
        if (!(self.firstPageList.count>0)) {
            
            return nil;
        }
        
        NSString *title =  self.firstPageList[indexPath.section][@"categoryName"];
        
        if (indexPath.section == 0) {
            
            
//            caigou =         {
//                imgPath = "http://img1.50tu.com/meinv/chemo/2013-11-01/8330df279fdf7d3870cee493969f6b0d.jpg";
//                playStream = "rtmp://10671.liveplay.myqcloud.com/live/10671_239371";
//                roomId = 1012046;
//                roomName = "18922268896\U7684\U623f\U95f4";
//                roomStarLevel = 0;
//                userId = 239371;
//            };
            
            FabricHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FabricHeadViewID forIndexPath:indexPath];
            headerView.lab.text =title;
            headerView.adList = _adlist;
            headerView.namelab.text = _caigou[@"roomName"];
            headerView.sublab.text = _caigou[@"mainBusiness"];
            NSString *title = [NSString stringWithFormat:@"%@",_caigou[@"roomId"]];
            [headerView.rightbtn setTitle:title forState:UIControlStateNormal];
            [headerView.head sd_setBackgroundImageWithURL:[NSURL URLWithString:_caigou[@"imgPath"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]];
            
            
            [headerView setClick:^(NSDictionary *dic){
               
                if (dic) {
                    
                    [self enterRoom:dic];
                }
                
                
//                FabricWebViewController *vc = [[FabricWebViewController alloc]init];
//                vc.strUrl = url;
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
                
                
            }];
            
             [headerView.head addTarget:self action:@selector(caigouAction) forControlEvents:UIControlEventTouchUpInside];
            headerView.morebtn.tag = indexPath.section;
            
            
            [headerView.morebtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            reusableview = headerView;

        }else{
            
            HomeReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeadViewID forIndexPath:indexPath];
            headerView.titile.text = title;
            headerView.more.tag = indexPath.section;
            [headerView.more addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            reusableview = headerView;
            
        }


    }
    if (kind == UICollectionElementKindSectionFooter) {

    }
    return reusableview;
}

- (void)more:(UIButton *)btn{
    
    NSDictionary *dic = self.firstPageList[btn.tag];
    FabricMoreViewController *vc = [[FabricMoreViewController alloc]init];
    vc.cateDic = dic;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/2-2, (SCREEN_WIDTH-4)/2 );
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

    if (!(self.firstPageList.count>0)) {
        
        return CGSizeZero;
    }
    
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 50 + 25 + 8 + SCREEN_WIDTH/3);
    }
    return CGSizeMake(SCREEN_WIDTH, 25);
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
    
    NSDictionary *dic;
    if (self.firstPageList && !(_areaName.length>0)) {
        
        dic = self.firstPageList[indexPath.section][@"roomList"][indexPath.row];
    }else{
        
        dic = self.list[indexPath.row];
    }
    
    
 
    [self enterRoom:dic];

    
}

- (void)caigouAction{
    
    if (_caigou.allKeys.count>0) {
        
        [self enterRoom:_caigou];
    }
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

@end
