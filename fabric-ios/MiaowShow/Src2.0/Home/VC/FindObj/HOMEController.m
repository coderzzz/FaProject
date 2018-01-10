//
//  HOMEController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "HOMEController.h"
#import "FindObjController.h"
#import "GetOrderCenterController.h"
#import "GetOrderController.h"
#import "FindOrderController.h"
#import "BeFinderController.h"
#import "FabricWebViewController.h"
#import "FabricAgentViewController.h"
#import "LiveWordController.h"
#import "EaseMessageViewController.h"
#import "RealNameViewController.h"
#import "ALinNavigationController.h"
#import "ShowTimeViewController.h"
/* cell */
#import "HOMEcCell.h"

/* head */
#import "HOMEReusableView.h"
/* foot */


// Vendors
// Categories
// Others

@interface HOMEController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */



@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *list;


@property (assign, nonatomic) int pageN;




@end
/* cell */
static NSString *const FabricLiveCellID = @"homec";

/* head */
static NSString *const HomeHeadViewID = @"homeres";
/* foot */

@implementation HOMEController
{
    NSArray *adList;
}
#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BGColor;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        UINib *nib = [UINib nibWithNibName:@"HOMEcCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:FabricLiveCellID];
        
        
        [_collectionView registerClass:[HOMEReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeadViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


#pragma mark - LifeCyle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = @[@"委托找样",@"抢单中心",@"我要供样",@"委托订单",@"找样订单",@"在线商城",@"纺织世界",@"互动直播",@"客服在线"].mutableCopy;
    self.navigationItem.title = @"全球面料网";
    adList = [NSArray array];
//    [self.collectionView reloadData];
    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadad];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
}


#pragma mark - initialize

#pragma mark - 加载数据
- (void)loadad{
    
    //    [self showHudInView:self.view];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_getad:nil withSuccessBlock:^(NSDictionary *object) {
        
        [self.collectionView.mj_header endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
            adList = [object[@"data"] copy];
            [self.collectionView reloadData];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
         [self.collectionView.mj_header endRefreshing];
        //        [self showHint:error.description];
        
    }];
}
- (void)loadCate{
    
    [self showHudInView:self.view];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_getPersionDataParam:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        [self hideHud];
        [self.collectionView.mj_header endRefreshing];
        if([object[@"ret"] intValue] == 0){
            
//            _caigou = object[@"data"][@"caigou"];
//            //    [self addChildViewControllers:object[@"data"][@"categoryList"]];
//            self.firstPageList = object[@"data"][@"categoryList"];
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
        [self.collectionView.mj_header endRefreshing];
    }];
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
    

    HOMEcCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FabricLiveCellID forIndexPath:indexPath];

    [cell.btn setImage:[UIImage imageNamed:self.list[indexPath.row]] forState:UIControlStateNormal];
    cell.lab.text = self.list[indexPath.row];
    gridcell = cell;
    
    
    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){

            
            HOMEReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeadViewID forIndexPath:indexPath];
        if (adList.count>0) {
            
             [headerView getList:adList];
        }
        
            reusableview = headerView;
            
        }
    if (kind == UICollectionElementKindSectionFooter) {
        
    }
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/3-1, SCREEN_WIDTH/3-2 );
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2);
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
- (BOOL)isLogin{
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    if ([user.userId isEqualToString:@"0"]) {
        
        return NO;
    }
    return YES;
}

- (void)showLogin{
    
    BRLoginViewController *vc = [BRLoginViewController new];
    [vc setBlock:^(void){
        
        
    }];
    
    BRLoginNavigationController *nav = [[BRLoginNavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    

    
    if (indexPath.row == 1) {
        
        GetOrderCenterController *vc = [[GetOrderCenterController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
//    if (indexPath.row == 8) {
//        FabricWebViewController *vc = [[FabricWebViewController alloc]init];
//        vc.strUrl = @"http://wap.fabric.cn/wap/platrules.html";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    
    if (![self isLogin]) {
        
        [self showLogin];
        return;
    }
    
    
    
    if (indexPath.row == 0) {
        
        FindObjController *vc = [[FindObjController alloc]init];
        vc.title = self.list[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
   
    if (indexPath.row == 2) {
        
        BeFinderController *vc = [[BeFinderController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    
    if (indexPath.row == 3) {
        
        GetOrderController*vc = [[GetOrderController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row ==4) {
        
        FindOrderController*vc = [[FindOrderController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    if (indexPath.row == 5) {
        
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        FabricWebViewController *vc = [[FabricWebViewController alloc]init];
        vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/index.html?userId=%@&token=%@",user.userId,user.token];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == 8) {
        
        [self chatWithAgent];
        return;
    }
    if (indexPath.row == 6) {
        
        LiveWordController *vc = [[LiveWordController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row ==7) {
        
        // 判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //            [self showInfo:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
            return;
        }
        
        // 判断是否有摄像头权限
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            //            [self showInfo:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
            return;
        }
        
        // 开启麦克风权限
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
//                    return YES;
                    
                    
                    
                    
                    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
                    
                    
                    [BAIRUITECH_NetWorkManager FinanceLiveShow_user:@{@"userId":user.userId} withSuccessBlock:^(NSDictionary *object) {
                        
                        
                        
                        //        [self showHint:object[@"msg"]];
                        if([object[@"ret"] intValue] == 0){
                            
                            NSString *statue = [NSString stringWithFormat:@"%@",object[@"data"][@"idValidStatus"]];
                            if ([statue isEqualToString:@"3"]) {
                                
                                RealNameViewController *vc = [[RealNameViewController alloc]init];
                                ALinNavigationController *nav = [[ALinNavigationController alloc]initWithRootViewController:vc];
                                [self presentViewController:nav animated:YES completion:nil];
                                return;
                            }
                            else if ([statue isEqualToString:@"2"]){
                                
                                [BAIRUITECH_NetWorkManager FinanceLiveShow_enterLiveActivity:@{@"userId":user.userId} withSuccessBlock:^(NSDictionary *object) {
                                    
                                    
                                    if([object[@"ret"] intValue] == 0){
                                        
                                        //            [self showHint:@"ShowTime"];
                                        //            log.text = [NSString stringWithFormat:@"%@\n ShowTime ",log.text];
                                        ShowTimeViewController *vc = [UIStoryboard storyboardWithName:NSStringFromClass([ShowTimeViewController class]) bundle:nil].instantiateInitialViewController;
                                        LiveUserModel *live =[LiveUserModel new];
                                        live = [LiveUserModel mj_objectWithKeyValues:object[@"data"][@"star"]];
                                        live.chatAddress =object[@"data"][@"chat"][@"chatAddress"];
                                        live.chatKey = object[@"data"][@"chat"][@"chatKey"];
                                        vc.live = live;
                                        
                                        //            log.text = [NSString stringWithFormat:@"%@\n present ",log.text];
                                        [self presentViewController:vc animated:YES completion:nil];
                                        
                                    }else{
                                        
                                        
                                        [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:2];
                                    }
                                    
                                } withFailureBlock:^(NSError *error) {
                                    
                                    YJLog(@"%@",error);
                                    
                                }];
                            }
                            else{
                                
                                [self showHint:object[@"msg"]];
                            }
                            
                            
                            
                            
                        }else{
                            
                            
                        }
                        
                    } withFailureBlock:^(NSError *error) {
                        
                        //           [self showHint:error.description];
                        
                    }];
                    

                    
                    //    [self showInfo:@"enter"];
                    //    log.text = [NSString stringWithFormat:@"%@\n enter ",log.text];
                    
                }
                else {
                    //                    [self showInfo:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                }
            }];
        }
  
        
        return;
    }
 
}



- (void)chatWithAgent{
    
    
    [self showHudInView:self.view];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_getOL:nil withSuccessBlock:^(NSDictionary *object) {
        
        [self showHint:object[@"msg"]];

        if([object[@"ret"] intValue] == 0){

            NSDictionary *dic = object[@"data"];
            EaseMessageViewController *chatVC =[[EaseMessageViewController alloc]initWithConversationChatter:@""];
            chatVC.toUserId = [NSString stringWithFormat:@"%@",dic[@"userId"]];
            chatVC.showRefreshHeader = YES;
            chatVC.title = dic[@"nickName"];
            chatVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:chatVC animated:YES];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];

    }];
    

}

@end
