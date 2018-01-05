//
//  AddNewAddressController.m
//  Farbic
//
//  Created by sam on 2017/12/4.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "AddNewAddressController.h"
#import "LZCityPickerController.h"
@interface AddNewAddressController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UITextView *detailAddressTextView;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@end

@implementation AddNewAddressController
{
    NSArray *areaIds;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    if (self.dic) {
        
        self.nameTF.text = [NSString stringWithFormat:@"%@",self.dic[@"buyer"]];
        self.phoneTF.text = [NSString stringWithFormat:@"%@",self.dic[@"phone"]];
        self.areaLab.text = [NSString stringWithFormat:@"%@%@%@%@",self.dic[@"countryName"],self.dic[@"provinceName"],self.dic[@"cityName"],self.dic[@"areaName"]];
        self.detailAddressTextView.text =  [NSString stringWithFormat:@"%@",self.dic[@"address"]];
        areaIds = @[self.dic[@"provinceId"],self.dic[@"cityId"],self.dic[@"areaId"]];
        self.defaultBtn.selected = [self.dic[@"isMr"] isEqualToString:@"Y"];
    }else{
        
        [self.detailAddressTextView setPlaceholder:@"请输入详细地址"];
    }
}



- (IBAction)select:(id)sender {
    
    [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, id data) {
        
        
        self.areaLab.text = address;
        areaIds = data;
        // 选择结果回调
//        self.addressLabel.text = address;
//        NSLog(@"%@--%@--%@--%@",address,province,city,area);
        
    }];
}
- (IBAction)checkDefault:(id)sender {
    
    self.defaultBtn.selected = !self.defaultBtn.selected;
}
- (IBAction)save:(id)sender {
    
    if (!(self.nameTF.text.length>0)) {
        
        [self showHint:@"请输入名称"];
        return;
    }
    if (!(self.phoneTF.text.length>0)) {
        
        [self showHint:@"请输入联系电话"];
        return;
    }
    if (!(areaIds.count>0)) {
        
        [self showHint:@"请选择地区"];
        return;
    }
    if (!(_detailAddressTextView.text.length>0)) {
        
        [self showHint:@"请输入详细地址"];
        return;
    }
    
    [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    NSDictionary *dic = @{@"custId":user.userId,@"typeId":@"1",@"buyer":self.nameTF.text,
                            @"provinceId":areaIds[0],
                          @"cityId":areaIds[1],
                          @"areaId":areaIds[2],
                          @"address":_detailAddressTextView.text,
                          @"phone":_phoneTF.text,
                          @"isMr":_defaultBtn.selected?@"Y":@"N"
                          
                          };
    
    
    if (self.dic) {
        
        NSMutableDictionary *prams = [NSMutableDictionary dictionaryWithDictionary:dic];
        [prams setValue:self.dic[@"deliverId"] forKey:@"deliverId"];
        
        [BAIRUITECH_NetWorkManager FinanceLiveShow_updateAddaddress:prams withSuccessBlock:^(NSDictionary *object) {
            
            
            
            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
                [self.navigationController popViewControllerAnimated:YES];
                //            self.list = object[@"data"];
                //            [self.tableView reloadData];
                
                
            }else{
                
                
            }
            
        } withFailureBlock:^(NSError *error) {
            
            [self showHint:error.description];
            
        }];
        
    }else{
     
        [BAIRUITECH_NetWorkManager FinanceLiveShow_addaddress:dic withSuccessBlock:^(NSDictionary *object) {
            
            
            
            [self showHint:object[@"msg"]];
            if([object[@"ret"] intValue] == 0){
                
                [self.navigationController popViewControllerAnimated:YES];
                //            self.list = object[@"data"];
                //            [self.tableView reloadData];
                
                
            }else{
                
                
            }
            
        } withFailureBlock:^(NSError *error) {
            
            [self showHint:error.description];
            
        }];
        
    }

}



@end
