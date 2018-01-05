//
//  FindObjController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "FindObjController.h"
#import "AddressController.h"
#import "TagController.h"
#import "PhotoManager.h"
#import "CameraTypeController.h"
#import "PayTypeViewController.h"
#import "PaySuccessController.h"
#import "PPNumberButton.h"
#import "FTPopOverMenu.h"
@interface FindObjController ()<PPNumberButtonDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet ZZTagView *tagView;
@property (weak, nonatomic) IBOutlet ZZImageView *imageView;


@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *savePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLab;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic ,strong) CameraTypeController *cameraTypeVC;

@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (nonatomic, strong) PPNumberButton *numberButton;
@property (nonatomic, strong) NSMutableArray *types;
@property (nonatomic, strong) NSMutableArray *coupons;
@property (nonatomic, strong) NSMutableArray *tags;
@property (weak, nonatomic) IBOutlet UIButton *addTagBtn;


@end

@implementation FindObjController
{
    
    NSString *typeId;
    NSString *couponId;
    NSInteger reduceM;
    NSString *addressId;
    NSDictionary *payDic;
    NSDictionary *adDic;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadAddresss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.descTextView setPlaceholder:@"填写描述"];
    [self.noteTextView setPlaceholder:@"填写备注"];
    
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 797);
    
    if ([self.type isEqualToString:@"1"]) {
        self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    }else{
        self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 797);
    [self.scrollView addSubview:self.contentView];
    
    self.imageView.canDel = YES;
    [self.imageView setDeleteItem:^(ZZItem *item){
       
        [self.imageUrls removeObject:item.imageUrl];
    }];
    self.tagView.hidden = YES;
    self.addTagBtn.hidden = YES;
    [self addNumberBtn];
    [self loadTypes];
    [self loadCoupon];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pay:) name:@"PaySucceed" object:nil];
    
    
    
    if (_dic) {
        
        [self setUpUI];
    }
}

- (void)setUpUI{
    
    self.title = @"编辑委托";
    
    adDic = _dic;
    self.titleTF.text = _dic[@"goodsName"];
    
    
   
    
    
    self.typeLab.text = _dic[@"typeName"];
    typeId = [NSString stringWithFormat:@"%@",_dic[@"typeId"]];
    
    self.descTextView.text = _dic[@"descriptions"];
    self.noteTextView.text = _dic[@"remarks"];
    
    NSArray *tags = [_dic[@"marks"] componentsSeparatedByString:@","];
    for (NSString *str in tags) {
        
        ZZTag *tag = [ZZTag new];
        tag.color = Color;
        tag.title= str;
        tag.height= 27;
        [self.tagView addTag:tag];
        [self.tags addObject:str];
    }
    
    NSArray *images = [_dic[@"imgUrl"] componentsSeparatedByString:@","];
    for (NSString *str in images) {
        
        ZZItem *item = [ZZItem new];
        item.imageUrl = str;
        
        [self.imageView addTag:item];
        
        [self.imageUrls addObject:str];
    }
    
 
    
    
    self.nameLab.text = [NSString stringWithFormat:@"收货人：%@",_dic[@"buyer"]];
    self.phoneLab.text = [NSString stringWithFormat:@"%@",_dic[@"phone"]];
    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@%@",_dic[@"countryName"],_dic[@"provinceName"],_dic[@"cityName"],_dic[@"areaName"],_dic[@"address"]];
    addressId = [NSString stringWithFormat:@"%@",_dic[@"addressId"]];
    
    
    
    
//    couponId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    _numberButton.currentNumber = [_dic[@"orderAmt"] integerValue];
    reduceM = [_dic[@"favAmt"] integerValue];
    self.savePriceLab.text = [NSString stringWithFormat:@"￥%ld.00",(long)reduceM];
    self.allPriceLab.text = [NSString stringWithFormat:@"￥%@.00",_dic[@"goodsAmt"]];

}

- (void)pay:(NSNotification *)notifi{

    PaySuccessController *vc = [PaySuccessController new];
    vc.dic = payDic;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)addNumberBtn{
    
    reduceM = 0;
    _numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(0, 5, 100, 30)];
    //设置边框颜色
    _numberButton.borderColor = [UIColor grayColor];
    _numberButton.increaseTitle = @"＋";
    _numberButton.decreaseTitle = @"－";
    _numberButton.currentNumber = 20;
    _numberButton.minValue = 20;
    _numberButton.delegate = self;
    _numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        NSLog(@"%ld",num);
    };
    
    [self.numView addSubview:_numberButton];
    [self calculate];
}


#pragma mark Action

- (IBAction)showTypes:(UIButton *)sender {
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dict in self.types) {
        
        [list addObject:[NSString stringWithFormat:@"%@",dict[@"name"]]];
        
    }
    
    [FTPopOverMenu showForSender:sender
                   withMenuArray:list
                      imageArray:nil
                       doneBlock:^(NSInteger selectedIndex) {
                           
                           typeId = [NSString stringWithFormat:@"%@",self.types[selectedIndex][@"typeId"]];
                           self.typeLab.text =self.types[selectedIndex][@"name"];
                           
                       } dismissBlock:^{
                           
    }];

}
- (IBAction)changeTag:(UIButton *)sender {
    
    TagController *vc = [TagController new];
    [vc setClickTag:^(NSString *name, NSString *tagId){
        
        if (![_tags containsObject:tagId]) {
            
            ZZTag *tag = [ZZTag new];
            tag.color = Color;
            tag.title= name;
            tag.height= 27;
            [self.tagView addTag:tag];
            [self.tags addObject:name];
        }
        
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)addPhoto:(id)sender {
    
    
    self.cameraTypeVC.view.hidden = NO;
    [PhotoManager shareManager].configureBlock = ^(id image){
        
        [self upLoadImge:image];
    };
    
    __weak typeof(self) weakSelf =self;
    [self.cameraTypeVC setDidSelect:^(NSInteger index){
       
        [weakSelf presentViewController:index==0?[PhotoManager shareManager].camera:[PhotoManager shareManager].pickingImageView animated:YES completion:nil];
        
    }];
    
    
    
    
}

- (void)upLoadImge:(UIImage *)image{
    
    [self showHudInView:self.view];
    NSData *data  = UIImageJPEGRepresentation(image, 0.1);
    [BAIRUITECH_NetWorkManager FinanceLiveShow_uploadPic:@{@"imgFrom":@"1"} withFullUrlString:@"/base/imgUpload" withImageData:data withSuccessBlock:^(NSDictionary *object) {
        
        [self hideHud];
//        NSLog(@"uploadPic --------%@",object);
        NSString *imgURL = [NSString stringWithFormat:@"%@%@",object[@"data"][@"imgUrlPre"],object[@"data"][@"imgUrl"]];
        
        ZZItem *item = [ZZItem new];
        item.image = image;
        item.imageUrl = imgURL;
        [self.imageView addTag:item];
        
        [self.imageUrls addObject:imgURL];
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    } withUpLoadProgress:^(float progress) {
        
        
    }];
}

- (IBAction)send:(UIButton *)sender {
    
    
    if (!(self.titleTF.text.length>0)) {
        
        [self showHint:@"请输入标题"];
        return;
    }
    if (!(typeId.length>0)) {
        
        [self showHint:@"请选择类型"];
        return;
    }
    
    if (!(self.descTextView.text.length>0)) {
        
        [self showHint:@"请输入描述"];
        return;
    }
    
//    if (!(_tags.count>0)) {
//        
//        [self showHint:@"请选择标签"];
//        return;
//    }
    
//    if (!(self.imageUrls.count>0)) {
//        
//        [self showHint:@"请选择图片"];
//        return;
//    }
    if (!(addressId.length>0)) {
        
        [self showHint:@"请选择默认地址"];
        return;
    }
    
    [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    NSString *otherUrls;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.imageUrls];
    if (temp.count>0) {
        
        [temp  removeObjectAtIndex:0];
        otherUrls = [temp componentsJoinedByString:@","];
    }
    else{
        otherUrls = @"";
    }
    
    
    NSMutableDictionary *dic=@{@"custId":user.userId,
                          @"goodsName":self.titleTF.text,
                          @"typeId":typeId,
                          @"descriptions":_descTextView.text,
                          @"marks":@"",
                          @"remarks":_noteTextView.text,
                               @"imgUrl":self.imageUrls.firstObject?self.imageUrls.firstObject:@"",
                          @"otherUrls":otherUrls,
                          @"addressId":addressId,
                          @"askPrice":@(_numberButton.currentNumber),
                          @"discountPrice":@(reduceM),
                          @"discountId":couponId?couponId:@"0",
                          @"finalPrice":@(_numberButton.currentNumber - reduceM)
                          }.mutableCopy;
    
    
    if (self.dic) {
        
        NSString *askId =[NSString stringWithFormat:@"%@",self.dic[@"askId"]];
        [dic setValue:askId forKey:@"askId"];
        [BAIRUITECH_NetWorkManager FinanceLiveShow_updateorder:dic withSuccessBlock:^(NSDictionary *object) {
            
            
            
            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
                payDic = object[@"data"];
                PayTypeViewController *pay = [PayTypeViewController new];
                pay.tradeDict = object[@"data"];
                [pay show];
                
            }else{
                
                
            }
            
        } withFailureBlock:^(NSError *error) {
            
            [self showHint:error.description];
            
        }];
    }
    else{
        
        [BAIRUITECH_NetWorkManager FinanceLiveShow_addorder:dic withSuccessBlock:^(NSDictionary *object) {
            
            
            
            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
                payDic = object[@"data"];
                PayTypeViewController *pay = [PayTypeViewController new];
                pay.tradeDict = object[@"data"];
                [pay show];
                
            }else{
                
                
            }
            
        } withFailureBlock:^(NSError *error) {
            
            [self showHint:error.description];
            
        }];
    }
}



- (IBAction)toAddress:(UITapGestureRecognizer *)sender {
    
    AddressController *vc = [AddressController new];
    [vc setDidSelect:^(NSDictionary *dic){
       
        adDic = dic;
        self.nameLab.text = [NSString stringWithFormat:@"收货人：%@",dic[@"buyer"]];
        self.phoneLab.text = [NSString stringWithFormat:@"%@",dic[@"phone"]];
        self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@%@",dic[@"countryName"],dic[@"provinceName"],dic[@"cityName"],dic[@"areaName"],dic[@"address"]];
        addressId = [NSString stringWithFormat:@"%@",dic[@"deliverId"]];
    }];
    adDic = nil;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark NetWork

- (void)loadTypes{
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_types:@{} withSuccessBlock:^(NSDictionary *object) {
        
        if([object[@"ret"] intValue] == 0){
            
            self.types = [object[@"data"] mutableCopy];
            
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        
    }];
    
}


- (void)loadAddresss{
    

    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_address:@{@"custId":user.userId,@"typeId":@"1",@"isMr":@"Y"} withSuccessBlock:^(NSDictionary *object) {
        
  
        
        if([object[@"ret"] intValue] == 0){
            
            NSDictionary *dic = [object[@"data"] firstObject];
            if (dic && !adDic) {
                
                self.nameLab.text = [NSString stringWithFormat:@"收货人：%@",dic[@"buyer"]];
                self.phoneLab.text = [NSString stringWithFormat:@"%@",dic[@"phone"]];
                self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@%@",dic[@"countryName"],dic[@"provinceName"],dic[@"cityName"],dic[@"areaName"],dic[@"address"]];
                addressId = [NSString stringWithFormat:@"%@",dic[@"deliverId"]];
            }
            
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
    
}

- (void)loadCoupon{
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_coupon:@{@"custId":user.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        
        if([object[@"ret"] intValue] == 0){
            
            
            self.coupons = [object[@"data"] mutableCopy];
            
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
    
}




#pragma mark PPNumberButtonDelegate
- (void)pp_numberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus{
    
    [self calculate];
    
    
}

- (void)calculate{
    
    reduceM = 0;
    
    for (NSDictionary *dict in self.coupons) {
        
        NSInteger money = [dict[@"tktUseCondit"] integerValue];
        if (_numberButton.currentNumber >= money) {
            
            NSInteger lessMoney = [dict[@"tktReduceRmb"] integerValue];
            
            if (lessMoney > reduceM) {
                
                reduceM = lessMoney;
                couponId = [NSString stringWithFormat:@"%@",dict[@"id"]];
            }
            
        }
        
    }
    
    self.savePriceLab.text = [NSString stringWithFormat:@"￥%ld.00",(long)reduceM];
    self.allPriceLab.text = [NSString stringWithFormat:@"￥%ld.00",(long)(_numberButton.currentNumber - reduceM)];
}




#pragma mark setter & getter

-(CameraTypeController *)cameraTypeVC{
    
    if (!_cameraTypeVC) {
        
        _cameraTypeVC = [CameraTypeController new];
        _cameraTypeVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [self addChildViewController:_cameraTypeVC];
        [self.view addSubview:_cameraTypeVC.view];
    }
    return _cameraTypeVC;
}




- (NSMutableArray *)imageUrls{
    
    if (!_imageUrls) {
        
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}

- (NSMutableArray *)types{
    
    if (!_types) {
        
        _types = [NSMutableArray array];
    }
    return _types;
}

- (NSMutableArray *)tags{
    
    if (!_tags) {
        
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (NSMutableArray *)coupons{
    
    if (!_coupons) {
        
        _coupons = [NSMutableArray array];
    }
    return _coupons;
}


@end
