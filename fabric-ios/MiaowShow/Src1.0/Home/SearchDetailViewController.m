//
//  SearchDetailViewController.m
//  SearchControllerDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "SearchDetailView.h"
#import "SearchTagTableViewCell.h"
#import "SearchResultTableViewCell.h"
#import "SearchTagHeadView.h"
#import "FabricLiveCell.h"
#import "ALinLiveCollectionViewController.h"
@interface UIImage (SKTagView)

+ (UIImage *)imageWithColor: (UIColor *)color;

@end

@implementation UIImage (SKTagView)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

@interface SearchDetailViewController ()<SearchDetailViewDelegate,UITableViewDelegate,UITableViewDataSource,SKTagViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>



/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITableView *searchTagTableView;
//@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@property (strong, nonatomic) SearchDetailView *searchDetailView;
@property (copy, nonatomic) NSArray *tags;
@property (copy, nonatomic) NSArray *historyTags;
@property (copy, nonatomic) NSArray *colors;
@property (strong, nonatomic) NSMutableArray *list;


@property (assign, nonatomic) int pageN;
@end


static NSString *const FabricLiveCellID = @"FabricLiveCell";

@implementation SearchDetailViewController

#pragma mark - life cycle

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

        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchView];
    [self registerCells];
    [self loadHistory];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.hidden = YES;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstLoad)];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
    }];
}


- (void)loadHistory{
    
    NSString *hisstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"His"];
    _tags = [hisstr componentsSeparatedByString:@","];
    [self.searchTagTableView reloadData];
}

- (void)addToHis:(NSString *)text{
    
    if (text.length>0 && ![_tags containsObject:text]) {
        
        NSMutableArray *ary = [NSMutableArray arrayWithArray:_tags];
        [ary addObject:text];
        _tags = ary;
        [self.searchTagTableView reloadData];
    }
    
    NSString *str = [_tags componentsJoinedByString:@","];
    if (str.length>0) {
        
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"His"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

- (void)clearHis{
    
    _tags = @[];
    [self.searchTagTableView reloadData];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"His"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)configureCell:(SearchTagTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
    cell.tagView.padding = UIEdgeInsetsMake(0, 10, 0, 10);
    cell.tagView.interitemSpacing = 10;
    cell.tagView.lineSpacing = 10;
    [cell.tagView removeAllTags];
    if (indexPath.section == 0) {
        cell.tagView.hidden = self.historyTags.count == 0 ;
        cell.contentEmptyLabel.hidden = !cell.tagView.hidden;
        [self.historyTags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SKTag *tag = [SKTag tagWithText:obj[@"key"]];
            tag.textColor =  [UIColor darkGrayColor];
            tag.fontSize = 14;
            tag.padding = UIEdgeInsetsMake(8, 8, 8, 8);
            tag.cornerRadius = 10;
//            tag.borderColor = [UIColor lightGrayColor];
//            tag.borderWidth = .5f;
            tag.bgImg = [UIImage imageWithColor:BGColor];
            tag.enable = YES;
            [cell.tagView addTag:tag];
        }];
    } else {
        [self.tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SKTag *tag = [SKTag tagWithText:obj];
            tag.textColor = [UIColor darkGrayColor];
            tag.fontSize = 14;
            tag.padding = UIEdgeInsetsMake(8, 8, 8, 8);
            tag.cornerRadius = 10;
//            tag.borderColor = [UIColor lightGrayColor];
//            tag.borderWidth = .5f;
             tag.bgImg = [UIImage imageWithColor:BGColor];
            tag.enable = YES;
            [cell.tagView addTag:tag];
        }];
    }
}

- (void)setupSearchView {
    self.navigationController.navigationBar.translucent = NO;
    self.searchDetailView = [[SearchDetailView alloc] initWithFrame:CGRectMake(0, 3, [UIScreen mainScreen].bounds.size.width, 30)];
    self.searchDetailView.textField.placeholder = self.placeHolderText;
    self.searchDetailView.delegate = self;
    [self.searchDetailView.textField becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:self.searchDetailView];
    self.searchTagTableView.tableFooterView = [[UIView alloc] init];
    self.searchTagTableView.backgroundColor = [UIColor whiteColor];
//    self.searchResultTableView.tableFooterView = [[UIView alloc] init];
}

- (void)registerCells {
    UINib *searchTagNib =
    [UINib nibWithNibName:NSStringFromClass([SearchTagTableViewCell class])
                                         bundle:nil];
    [self.searchTagTableView registerNib:searchTagNib
                  forCellReuseIdentifier:NSStringFromClass([SearchTagTableViewCell class])];
    
//    UINib *searchResultNib =
//    [UINib nibWithNibName:NSStringFromClass([SearchResultTableViewCell class])
//                   bundle:nil];
//    [self.searchResultTableView registerNib:searchResultNib
//                  forCellReuseIdentifier:NSStringFromClass([SearchResultTableViewCell class])];
}

#pragma mark - SKTagViewDelegate

- (void)tagButtonDidSelectedForTagTitle:(NSString *)title {
    NSLog(@"title:::::::%@", title);
    self.searchTagTableView.hidden  = YES;
    self.collectionView.hidden = NO;
    self.searchDetailView.textField.text = title;
    [self.searchDetailView.textField resignFirstResponder];
    [self search:self.searchDetailView.textField.text];
}

#pragma mark - Getters & Setters

- (NSArray *)tags {
    if (!_tags) {
        
        
        _tags = @[];
//        _tags = @[
//                  @"杭州",
//                  @"湿巾",
//                  @"吸管杯",
//                  @"火火兔",
//                  @"压脚",
//                  @"退热贴",
//                  @"答复发送到"
//                  ];
    }
    return _tags;
}

- (NSArray *)historyTags {
    if (!_historyTags) {
//        _historyTags = @[@"呵呵呵呵是短发是阿斯蒂芬安抚阿道夫案发时阿斯蒂芬是打发发顺丰阿斯蒂芬安抚阿萨德",
//                         @"面膜啥都发发发顺丰安抚阿萨德",
//                         @"火兔梵蒂冈地方个梵蒂冈第三个到国服大概是的",
//                         @"挖地方",
//                         @"阿道夫阿道夫爱的个梵蒂冈返回规范和规划方法"];
        
        _historyTags = _searchData[@"hotList"];
        //_historyTags = [NSArray array];
    }
    return _historyTags;
}


//- (NSArray *)colors {
//    if (!_colors) {
//        _colors = @[
//                    [UIColor colorWithRed:245 / 255.0f green:86 / 255.0f blue:160 / 255.0f alpha:1.0f],
//                    [UIColor colorWithRed:81 / 255.0f green:81 / 255.0f blue:81/255.0f alpha:1.0f]
//                    ];
//    }
//    return _colors;
//}

#pragma mark - SearchDetailViewDelegate

- (void)dismissButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView {
    [self dismissViewControllerAnimated:NO
                             completion:nil];
}

- (void)searchButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView {
    NSLog(@"搜索内容:::::::::%@",searchView.textField.text);
    
    if (searchView.textField.text.length>0) {
        
        [self search:searchView.textField.text];
    }
}

- (void)textFieldEditingChangedForSearchDetailView:(SearchDetailView *)searchView {
//    NSLog(@"搜索内容：：：：：：：%@",searchView.textField.text);
    
    self.searchTagTableView.hidden  = YES;
    self.collectionView.hidden = !self.searchTagTableView.hidden;
}

- (void)search:(NSString *)text{
    
    [self addToHis:text];
    
    [self firstLoad];
    
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
    
    __weak  typeof(self) weakSelf = self;
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    NSDictionary *dic = @{@"pageNo":@(_pageN),@"pageSize":@"10",@"userId":user.userId,@"searchStr":self.searchDetailView.textField.text};
    [BAIRUITECH_NetWorkManager FinanceLiveShow_search:dic withSuccessBlock:^(NSDictionary *object) {
        
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



#pragma mark - UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.searchDetailView) {
        [self.searchDetailView.textField resignFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTagTableView) {
        SearchTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchTagTableViewCell class])];
        [self configureCell:cell atIndexPath: indexPath];
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchTagTableView) {
        SearchTagHeadView *headView = [[SearchTagHeadView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 45.0f)];
        headView.backgroundColor = [UIColor whiteColor];
        NSString *leftImageName = section == 0 ? @"test" : @"test1";
        NSString *titleName = section == 0 ? @"热搜" : @"历史搜索";
        BOOL isHidden = section == 0 ? NO : YES;
        headView.leftImageView.image = [UIImage imageNamed:leftImageName];
        headView.titleLabel.text = titleName;
        headView.clearButton.hidden = isHidden;
        headView.ClearBlock = ^{
            
            [self clearHis];
        };
        return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchTagTableView) {
        return 45.0f;
    }
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchTagTableView) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchTagTableView) {
        return 2;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.searchTagTableView) {
        SearchTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchTagTableViewCell class])];
        if ([cell respondsToSelector:@selector(layoutMargins)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.contentEmptyLabel.hidden = indexPath.section != 0;
        [self configureCell:cell atIndexPath:indexPath];
        cell.tagView.delegate = self;
        return cell;
//    }
//    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchResultTableViewCell class])];
//    return ;
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
    

    NSDictionary *dic=self.list[indexPath.row];
    
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
        
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        
    }
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH/2-2, (SCREEN_WIDTH-4)/6 * 4 );
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
    
    NSDictionary *dic=self.list[indexPath.row];
//    [self enterRoom:dic];
    if (self.push) {
        self.push(dic);
    }
    [self dismissViewControllerAnimated:NO
                             completion:nil];
    
}


@end
