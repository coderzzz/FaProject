//
//  PostController.m
//  Farbic
//
//  Created by sam on 2017/12/24.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "PostController.h"
#import "FTPopOverMenu.h"
@interface PostController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UITextField *noteTF;

@end

@implementation PostController{
    NSString *typeId;
}
- (IBAction)done:(id)sender {
    
    if (!(typeId.length>0)) {
        
        [self showHint:@"请选择快递公司"];
        return;
    }
    if (!(self.numTF.text.length>0)) {
        
        [self showHint:@"请输入编号"];
        return;
    }
    
    [self showHudInView:self.view];
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_addPost:@{@"custId":user.userId,@"priceId":self.dic[@"priceId"],@"carriageComcode":typeId,@"carriageCom":self.postBtn.titleLabel.text,@"carriageNo":self.numTF.text,@"carriageRemark":_noteTF.text?_noteTF.text:@""} withSuccessBlock:^(NSDictionary *object) {
        
        
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            
            [self cancel:nil];

            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}
- (IBAction)cancel:(id)sender {
    self.view.hidden = YES;
    [self removeFromParentViewController];
}
- (IBAction)select:(id)sender {
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_Posts:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dict in object[@"data"]) {
                
                [list addObject:[NSString stringWithFormat:@"%@",dict[@"shipperName"]]];
                
            }
            
            [FTPopOverMenu showForSender:sender
                           withMenuArray:list
                              imageArray:nil
                               doneBlock:^(NSInteger selectedIndex) {
                                   
                                   typeId = [NSString stringWithFormat:@"%@",object[@"data"][selectedIndex][@"shipperCode"]];
                                   [self.postBtn setTitle:object[@"data"][selectedIndex][@"shipperName"] forState:UIControlStateNormal];
                              
                                   
                               } dismissBlock:^{
                                   
            }];

            
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];

}

-(void)show{
    
    AppDelegate *dele =(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [dele.window.rootViewController addChildViewController:self];
    [dele.window.rootViewController.view addSubview:self.view];
    
}





@end
