//
//  RealNameViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/10/11.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "RealNameViewController.h"
#import "PhotoManager.h"
#import "InputNameCell.h"
#import "UpCell.h"
#import "UIButton+WebCache.h"
@interface RealNameViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BAIRUITECH_BRAccount *userInfo;

@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) IBOutlet UIView *foot;

@property (nonatomic, copy) NSDictionary *imageDic;
@end

@implementation RealNameViewController

#pragma mark getter


//
//- (NSArray *)lefeArray
//{
//    if (_lefeArray == nil) {
//        _lefeArray = @[@[@"头像"],@[@"昵称",@"性别",@"地区"],@[@"账号",@"手机号",@"房间号"]];
//    }
//    return _lefeArray;
//}



#pragma mark ViewLife cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [BAIRUITECH_BRAccoutTool account];
    [self setupUi];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回-1"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
}
    
    
- (void)back{
    
    if (self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}
- (void)setupUi
{
    
  
//    self.navigationController.navigationBar.hidden = NO;
    self.tableView.backgroundColor = BGColor;
    UINib *nib  = [UINib nibWithNibName:@"InputNameCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"in"];
    
    UINib *nib2  = [UINib nibWithNibName:@"UpCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"up"];

    [self.tableView setTableFooterView:self.foot];
    
    self.tableView.separatorColor = BGColor;
    
    
    _dataSource =@[@[@"企业名称",@"请输入企业名称"],@[@"营业执照编码",@"请输入营业执照编码"],@[@"真实姓名",@"请输入您的真实姓名"],@[@"身份证号",@"仅支持中国大陆公民身份证"],@[@"手机号码",@"请输入手机号码"],@[@"验证码",@"请输入短信验证码"]].mutableCopy;
    
//    [self loadUserInfo];
//     self.title = @"实名认证";
}


#pragma mark Action
- (IBAction)done:(id)sender {
    
    NSArray *list = self.tableView.visibleCells;
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    NSMutableDictionary *info = @{}.mutableCopy;
    [info setObject:user.userId forKey:@"userId"];
    NSArray *key = @[@"companyName",@"businessLicense",@"realName",@"idCard",@"Mobile",@"businessLicenseImgUrl",@"verifyCode"];
    for (id cell in list) {
        if ([cell isKindOfClass:[InputNameCell class]]) {
            
            InputNameCell *input = (InputNameCell *)cell;
            
            if (!(input.tf.text.length>0)) {
                
                
                [self showHint:input.tf.placeholder];
                break;
            }
            else{
                
                [info setObject:input.tf.text forKey:key[[list indexOfObject:cell]]];
                
            }
        }
        
        if ([cell isKindOfClass:[UpCell class]]) {
            
            UpCell *up = (UpCell *)cell;
            if (!_imageDic) {
                
                [self showHint:@"请上传营业执照"];
                break;

            }else{
                NSString *img = _imageDic[@"imgUrl"]?_imageDic[@"imgUrl"]:@"";
                [info setObject:img forKey:key[[list indexOfObject:cell]]];
            }
        }
        
        
        
    }
    
    
    [self up:info];
    
}


#pragma mark Service
- (void)up:(NSDictionary *)dic{
    
    [self showHudInView:self.view];

    [BAIRUITECH_NetWorkManager FinanceLiveShow_real:dic withSuccessBlock:^(NSDictionary *object) {
        
        
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
    
}
- (void)loadUserInfo{
    
    //     [self showHudInView:self.view];
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_user:@{@"userId":user.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        
        //        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            _userInfo = [BAIRUITECH_BRAccount mj_objectWithKeyValues:object[@"data"]];
            
            NSString *avtar = _userInfo.userLogo?_userInfo.userLogo:@"";
            NSString *name = _userInfo.nickName?_userInfo.nickName:@"";
            
            NSString *sex = @"保密";
            if ([_userInfo.sex isEqualToString:@"M"]) {
                
                sex = @"男";
            }
            else if ([_userInfo.sex isEqualToString:@"W"]){
                sex = @"女";
            }
            
            NSString *address = _userInfo.address?_userInfo.address:@"";
            NSString *count = _userInfo.loginName?_userInfo.loginName:@"";
            NSString *phone = _userInfo.phone?_userInfo.phone:@"";
            NSString *room = _userInfo.roomId?_userInfo.roomId:@"";
            
            _dataSource = [@[@[avtar],@[name,sex,address],@[count,phone,room]]mutableCopy];
            [self.tableView reloadData];
            
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        //           [self showHint:error.description];
        
    }];
    
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 5) {
        
        UpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"up"];
        [cell.btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_imageDic[@"imgUrlPre"],_imageDic[@"imgUrl"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"上传图片"]];
        [cell setClick:^{
           
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
            [actionSheet showInView:self.view];
            
            
        }];
        return cell;
    }
    else{
        
        InputNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"in"];
        
        if (indexPath.row == 4) {
            cell.getTestCodeBtn.hidden = NO;
            BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
            cell.tf.text =user.phone;
            cell.tf.userInteractionEnabled = NO;
        }else{
            cell.tf.userInteractionEnabled = YES;
            cell.getTestCodeBtn.hidden = YES;
        }
        if (indexPath.row == 6) {
            cell.titlab.text = self.dataSource[indexPath.row-1][0];
            cell.tf.placeholder = self.dataSource[indexPath.row-1][1];
        }
        else{
            
            cell.titlab.text = self.dataSource[indexPath.row][0];
            cell.tf.placeholder = self.dataSource[indexPath.row][1];
        }
        return cell;
        
    }
    
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
  }


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view         = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) return 90;

    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 10;
//}


#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    if(buttonIndex == 0)
    {
        [self presentViewController:[PhotoManager shareManager].camera animated:YES completion:nil];
    }
    else if(buttonIndex == 1)
    {
        [self presentViewController:[PhotoManager shareManager].pickingImageView animated:YES completion:nil];
    }
    
    [PhotoManager shareManager].configureBlock = ^(id image){
        if(image == nil)
        {
            return ;
        }
        //        image = [image imageWithSize:CGSizeMake(ScreenWidth-20, 200)];
        
        NSData *data  = UIImageJPEGRepresentation(image, 0.2);
        
//        NSString  *base64Sting = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [self upLoadAvtar:data];
        
    };
}

- (void)upLoadAvtar:(NSData *)image{
    
    [self showHudInView:self.view];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_uploadPic:@{} withFullUrlString:@"/base/imgUpload" withImageData:image withSuccessBlock:^(NSDictionary *object) {
        
        [self hideHud];
        _imageDic = object[@"data"];
        [self.tableView reloadData];
        NSLog(@"%@",object);
        
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
    } withUpLoadProgress:^(float progress) {
        
    }];
}

@end
