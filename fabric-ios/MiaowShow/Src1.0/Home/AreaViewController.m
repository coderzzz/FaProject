//
//  AreaViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/9.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AreaViewController.h"

// Controllers

// Models

// Views


/* cell */
#import "AreaCell.h"
/* head */
#import "AreaHeadView.h"

/* foot */
#import "AreaFootView.h"

// Vendors
// Categories
// Others

@interface AreaViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;



@property (nonatomic,assign) NSInteger proIndex;
@property (nonatomic,assign) NSInteger cityIndex;
@property (nonatomic,assign) BOOL reset;
@end
/* cell */
static NSString *const DCGoodsCountDownCellID = @"cell";

/* head */
static NSString *const DCSlideshowHeadViewID = @"head";

/* foot */
static NSString *const DCTopLineFootViewID = @"foot";


@implementation AreaViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
       

        
        [_collectionView registerNib:[UINib nibWithNibName:@"AreaCell" bundle:nil] forCellWithReuseIdentifier:DCGoodsCountDownCellID];
        
        
        [_collectionView registerNib:[UINib nibWithNibName:@"AreaHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCSlideshowHeadViewID];
        
        
        [_collectionView registerNib:[UINib nibWithNibName:@"AreaFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:DCTopLineFootViewID];



        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - LifeCyle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _proIndex = 0;
    _cityIndex = 0;
    [self setUpBase];
    
//    [self loadCitys];

}

- (void)setGridItem:(NSMutableArray *)gridItem{
    
    _gridItem = gridItem;
    [self.collectionView reloadData];
}

#pragma mark - initialize
- (void)setUpBase
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = BGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 加载数据

- (void)loadCitys{
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_Menu:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        
        //        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            
            _gridItem = object[@"data"];
            
            [self.collectionView reloadData];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        //        [self showHint:error.description];
        
    }];
    
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    

    if (section == 0) { //10属性
        return _gridItem.count;
    }
//    if (section == 1) { //商品列表
//        
//        NSArray *citys = self.gridItem[_proIndex][@"cities"];
//        return citys.count;
//    }

    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;

        AreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsCountDownCellID forIndexPath:indexPath];
        
    
    
//    if (component == 0) {
//        
//        return  self.dataSource[row][@"provinceAreaName"];;
//        
//    }
//    else{
//        
//        NSArray *citys = self.dataSource[index][@"cities"];
//        return citys[row][@"areaName"];
    
        if (indexPath.section == 0) {
            
            if (indexPath.row == _proIndex) {
                cell.lab.backgroundColor = MainColor;
                cell.lab.textColor = [UIColor whiteColor];
            }else{
                
                cell.lab.backgroundColor = [UIColor clearColor];
                cell.lab.textColor = [UIColor darkGrayColor];
            }
            
            cell.lab.text = _gridItem[indexPath.row][@"moduleName"];
        }
        else{
            
//            if (indexPath.row == _cityIndex) {
//                cell.lab.backgroundColor = MainColor;
//                cell.lab.textColor = [UIColor whiteColor];
//            }else{
//                
//                cell.lab.backgroundColor = [UIColor clearColor];
//                cell.lab.textColor = [UIColor darkGrayColor];
//            }
//            NSArray *citys = _gridItem[_proIndex][@"cities"];
//            cell.lab.text = citys[indexPath.row][@"areaName"];
        }
    
    
        //        cell.goodExceedArray = GoodsRecommendArray;
        gridcell = cell;
    
 
    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        
        AreaHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCSlideshowHeadViewID forIndexPath:indexPath];
        reusableview = headerView;
        [headerView setClick:^{
           
            self.view.hidden = YES;
        }];
        if (indexPath.section == 0) {
            headerView.lab.text = @"菜单";
            headerView.btn.hidden = NO;
            
        }else{
//            headerView.lab.text = @"地区";
//            headerView.btn.hidden = YES;
//
        }

        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            AreaFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCTopLineFootViewID forIndexPath:indexPath];
            [footerView setAction:^(NSInteger tag){
                
                if (tag ==0) {
                    
                    _proIndex = 0;
                    _cityIndex =0;
                    _reset = YES;
                    [self.collectionView reloadData];
                }
                else{
                    
//                    NSArray *citys = _gridItem[_proIndex][@"cities"];
                    NSString *areaName = @"";
                    if (!_reset) {
                        
                        areaName = [NSString stringWithFormat:@"%@",_gridItem[_proIndex][@"moduleId"]];
                    }
                    
                    
                    if (self.ClickArea) {
                        
                        self.ClickArea(areaName);
                        
                    }
                    
                    self.view.hidden = YES;
                }
                
            }];
            reusableview = footerView;
        }

    }
    
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((SCREEN_WIDTH - 0)/5, 45);
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
   return CGSizeMake(SCREEN_WIDTH, 40);;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 60);  //banner
    }


    return CGSizeZero;
}


/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section ==0) {
        
        _proIndex = indexPath.row;
    }else{
        
        _cityIndex = indexPath.row;
    }
    _reset = NO;
    [self.collectionView reloadData];
    
}

@end
