//
//  DoneObjController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "DoneObjController.h"

@interface DoneObjController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet ZZImageView *imageScrllView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DoneObjController
{
    NSDictionary *model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
    [self loadData];
}


- (IBAction)done:(id)sender {
    
    [self doneOR:YES];
    
}

- (void)doneOR:(BOOL)done{
    
    [self showHudInView:self.view];
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    NSString *statue = done?@"7":@"8";
    [BAIRUITECH_NetWorkManager FinanceLiveShow_doneGO:@{@"custId":user.userId,@"askId":self.orderID,@"statusId":statue} withSuccessBlock:^(NSDictionary *object) {
        
        
        [self hideHud];
        if([object[@"ret"] intValue] == 0){
            
            
            [self close:nil];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}

//2017-12-28 10:36:04.110968+0800 Farbic[50834:4504250] --------{
//    askId = 134;
//    custId = 239377;
//    statusId = 8;
//}
//2017-12-28 10:36:04.111185+0800 Farbic[50834:4504250] =======http://mobile2.fabric.cn/buyask/confirmBuyAsk
//2017-12-28 10:36:04.256189+0800 Farbic[50834:4504250] {
//    msg = "\U6210\U529f";
//    ret = 0;
//    serverTime = "2017-12-28 10:37:03";
//}


- (void)loadData{
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_ObjDetail:@{@"custId":user.userId,@"askId":self.orderID} withSuccessBlock:^(NSDictionary *object) {
        
//        [self showHint:object[@"msg"]];
        
        if([object[@"ret"] intValue] == 0){
            
            model = object[@"data"];
            self.textView.text = model[@"descriptions"];
            NSArray *imags = [model[@"sampleImage"] componentsSeparatedByString:@","];
            NSMutableArray *items = [NSMutableArray array];
            for (NSString *url in imags) {
                
                ZZItem *item = [ZZItem new];
                item.imageUrl = url;
                [items addObject:item];
            }
            self.imageScrllView.list = items;
        }else{
            
             [self showHint:object[@"msg"]];
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


- (IBAction)reject:(id)sender {
    
    [self doneOR:NO];
}
- (IBAction)close:(id)sender {
    
    self.view.hidden = YES;
    [self removeFromParentViewController];
}


@end
