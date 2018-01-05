//
//  JudgeController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/15.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "JudgeController.h"
#import "HYBStarEvaluationView.h"
@interface JudgeController ()<DidChangedStarDelegate>
@property (weak, nonatomic) IBOutlet UIView *conten1;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UIView *conten2;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UIView *content3;
@property (weak, nonatomic) IBOutlet UILabel *lab3;

@end

@implementation JudgeController
{
    HYBStarEvaluationView * starView1;
    HYBStarEvaluationView * starView2;
    HYBStarEvaluationView * starView3;
    NSArray *types;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表评价";
    types = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
    starView1 = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(0, 0, 150, 30) numberOfStars:5 isVariable:YES];
    starView1.actualScore = 5;
    starView1.fullScore = 5;
    starView1.delegate = self;
    [self.conten1 addSubview:starView1];
    
    
    starView2 = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(0, 0, 150, 30) numberOfStars:5 isVariable:YES];
    starView2.actualScore = 5;
    starView2.fullScore = 5;
    starView2.delegate = self;
    [self.conten2 addSubview:starView2];
    
    
    starView3 = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(0, 0, 150, 30) numberOfStars:5 isVariable:YES];
    starView3.actualScore = 5;
    starView3.fullScore = 5;
    starView3.delegate = self;
    [self.content3 addSubview:starView3];
}
- (IBAction)done:(id)sender {
    
    
    [self showHudInView:self.view];
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_judge:@{@"custId":user.userId,@"askId":self.dic[@"askId"],@"attitude":@(starView1.actualScore),@"efficiency":@(starView2.actualScore),@"accuracy":@(starView3.actualScore)} withSuccessBlock:^(NSDictionary *object) {
        
        
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            [self.navigationController popViewControllerAnimated:YES];
       
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}

- (NSString *)getStatueWithScore:(int)score{
    
    return types[score-1];
}

- (void)didChangeStar:(HYBStarEvaluationView *)startView{
    
    if (startView == starView1) {
        
        self.lab1.text= [self getStatueWithScore:starView1.actualScore];
        
        return;
    }
    if (startView == starView2) {
        
        self.lab2.text= [self getStatueWithScore:starView2.actualScore];
        
        return;
    }
    if (startView == starView3) {
        
        self.lab3.text= [self getStatueWithScore:starView3.actualScore];
        
        return;
    }
}




@end
