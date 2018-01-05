//
//  LookObjController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/14.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "LookObjController.h"

@interface LookObjController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet ZZImageView *imageScrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet ZZImageView *bossImage;

@end

@implementation LookObjController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
    [self loadData];
}


- (void)loadData{
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_ObjDetail:@{@"custId":user.userId,@"askId":self.orderID} withSuccessBlock:^(NSDictionary *object) {
        
        
       
        if([object[@"ret"] intValue] == 0){
            
            NSDictionary *model = object[@"data"];
            self.textView.text = model[@"descriptions"];
            NSArray *imags = [model[@"sampleImage"] componentsSeparatedByString:@","];
            NSMutableArray *items = [NSMutableArray array];
            for (NSString *url in imags) {
                
                ZZItem *item = [ZZItem new];
                item.imageUrl = url;
                [items addObject:item];
            }
            
            NSArray *bossimags = [model[@"mpImage"] componentsSeparatedByString:@","];
            NSMutableArray *items2 = [NSMutableArray array];
            for (NSString *url in bossimags) {
                
                ZZItem *item = [ZZItem new];
                item.imageUrl = url;
                [items2 addObject:item];
            }
            self.bossImage.list = items2;
            self.imageScrollView.list = items;
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


- (IBAction)close:(id)sender {
    
    self.view.hidden = YES;
    [self removeFromParentViewController];
}


@end
