//
//  UpObjImageController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "UpObjImageController.h"
#import "CameraTypeController.h"
#import "PhotoManager.h"
@interface UpObjImageController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) CameraTypeController *cameraTypeVC;
@property (weak, nonatomic) IBOutlet ZZImageView *bossImageView;
@property (weak, nonatomic) IBOutlet ZZImageView *iamgeScrollView;
@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, strong) NSMutableArray *bossImages;
@end

@implementation UpObjImageController
-(CameraTypeController *)cameraTypeVC{
    
    if (!_cameraTypeVC) {
        
        _cameraTypeVC = [CameraTypeController new];
        _cameraTypeVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addChildViewController:_cameraTypeVC];
        [self.view addSubview:_cameraTypeVC.view];
    }
    return _cameraTypeVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    
    [self.noteTextView setPlaceholder:@"选填备注"];
    self.bossImageView.canDel = YES;
    self.iamgeScrollView.canDel = YES;
    self.imgs = [NSMutableArray array];
    self.bossImages = [NSMutableArray array];
    [self.iamgeScrollView setDeleteItem:^(ZZItem *item){
        
        [self.imgs removeObject:item.imageUrl];
    }];
    [self.bossImageView setDeleteItem:^(ZZItem *item){
        
        [self.bossImages removeObject:item.imageUrl];
    }];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)addImage:(id)sender {
    
    [self upLoad:@"1"];
}

- (IBAction)addCard:(id)sender {

    [self upLoad:@"2"];
    
}

- (void)upLoad:(NSString *)type{
    
    self.cameraTypeVC.view.hidden = NO;
    [PhotoManager shareManager].configureBlock = ^(id image){
        
        [self upLoadImge:image type:type];
    };
    
    __weak typeof(self) weakSelf =self;
    [self.cameraTypeVC setDidSelect:^(NSInteger index){
        
        [weakSelf presentViewController:index==0?[PhotoManager shareManager].camera:[PhotoManager shareManager].pickingImageView animated:YES completion:nil];
        
    }];
}

- (void)upLoadImge:(UIImage *)image type:(NSString *)type{
    
    [self showHudInView:self.view];
    NSData *data  = UIImageJPEGRepresentation(image, 0.1);
    [BAIRUITECH_NetWorkManager FinanceLiveShow_uploadPic:@{@"imgFrom":@"1"} withFullUrlString:@"/base/imgUpload" withImageData:data withSuccessBlock:^(NSDictionary *object) {
        
        [self hideHud];
        NSLog(@"uploadPic --------%@",object);
        NSString *imgURL = [NSString stringWithFormat:@"%@%@",object[@"data"][@"imgUrlPre"],object[@"data"][@"imgUrl"]];

        if ([type isEqualToString:@"1"]) {
            ZZItem *item = [ZZItem new];
            item.image = image;
            item.imageUrl = imgURL;
            [self.iamgeScrollView addTag:item];
            [self.imgs addObject:imgURL];
            
        }else{
            
            ZZItem *item = [ZZItem new];
            item.image = image;
            item.imageUrl = imgURL;
            [self.bossImageView addTag:item];
            [self.bossImages addObject:imgURL];
        }
        
       
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    } withUpLoadProgress:^(float progress) {
        
        
    }];
}

- (IBAction)send:(id)sender {
    
    if (!(_imgs.count>0)) {
        
        [self showHint:@"请上传样品图片"];
        return;
    }
    
    if (!(self.bossImages.count>0)) {
        
        [self showHint:@"请上传商家名片"];
        return;
    }
    if (!(_noteTextView.text.length>0)) {
        
        [self showHint:@"请输入描述信息"];
        return;
    }
    
    [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    

    NSString *imgUrls = [self.imgs componentsJoinedByString:@","];
    NSString *bossUrls = [self.bossImages componentsJoinedByString:@","];
    
    NSDictionary *dic=@{@"custId":user.userId,
                        @"priceId":_dic[@"priceId"],
                        @"descriptions":[_noteTextView.text isEqualToString:@"选填备注"]?@"":_noteTextView.text,
                        @"mpImages":bossUrls,
                        @"sampleImages":imgUrls
                        };
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_addOBJ:dic withSuccessBlock:^(NSDictionary *object) {
        
        
        
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            if (self.UpSuccess) {
                self.UpSuccess();
            }
            [self cacel:nil];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];

    
}

-(void)show{
    
    AppDelegate *dele =(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [dele.window.rootViewController addChildViewController:self];
    [dele.window.rootViewController.view addSubview:self.view];
    
}
- (IBAction)cacel:(id)sender {
    
    self.view.hidden = YES;
    [self removeFromParentViewController];
}

@end
