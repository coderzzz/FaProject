//
//  PersonCenterViewController.m


#import "PersonCenterViewController.h"
#import "PersonCell.h"
#import "RangPickerView.h"
#import "PhotoManager.h"
#import "ASBirthSelectSheet.h"
#import "ChangeNameViewController.h"
#import "SexViewController.h"
#import "ChangePViewController.h"
@interface PersonCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,RangPickerViewDelegate,UITextFieldDelegate,ChangeNameDelegate,SexDelegate,ChangePViewControllerDelegate>

@property (strong, nonatomic) NSArray *lefeArray;

@property (nonatomic, strong) BAIRUITECH_BRAccount *userInfo;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *cityArray;

@property (nonatomic, strong) RangPickerView *pickerView;

@end

@implementation PersonCenterViewController
{
    
    NSIndexPath  *didSelectIndexPath;
    
    
    
}
#pragma mark getter



- (RangPickerView *)pickerView{
    
    if (_pickerView == nil) {
        
        _pickerView = [[RangPickerView alloc]init];
        
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

- (NSArray *)lefeArray
{
    if (_lefeArray == nil) {
        _lefeArray = @[@[@"头像"],@[@"昵称",@"性别",@"地区"],@[@"账号",@"手机号",@"房间号"]];
    }
    return _lefeArray;
}



#pragma mark ViewLife cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [BAIRUITECH_BRAccoutTool account];
    [self setupUi];
}

- (void)setupUi
{
    
    self.title = @"个人信息";
    self.navigationController.navigationBar.hidden = NO;
    self.tableview.backgroundColor = BGColor;
    UINib *nib  = [UINib nibWithNibName:@"PersonCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"perCell"];

    self.tableview.separatorColor = BGColor;
    
    [self loadUserInfo];
    [self loadCitys];
}


#pragma mark Action


#pragma mark Service
- (void)updateUserInfo:(NSDictionary *)dic{
    
    [self showHudInView:self.view];
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dic];
    [info setObject:user.userId forKey:@"userId"];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_updateUser:info withSuccessBlock:^(NSDictionary *object) {
        
        
       [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            
            [self loadUserInfo];
            
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
            if (![avtar hasPrefix:@"htt"]) {
                avtar = [NSString stringWithFormat:@"%@%@",ImageURL,_userInfo.userLogo];
            }else{
                avtar = user.userLogo;
            }
            NSString *name = _userInfo.nickName?_userInfo.nickName:@"";
            
            user.userLogo =avtar;
            user.nickName = name;
            [BAIRUITECH_BRAccoutTool saveAccount:user];
            
            
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
            [self.tableview reloadData];
            
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
//           [self showHint:error.description];
        
    }];
    
}

- (void)loadCitys{
    

    
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_city:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        
//        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            

            _cityArray = object[@"data"];
           
            self.pickerView.dataSource = _cityArray;
            
        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
//        [self showHint:error.description];
        
    }];
    
}

- (void)pickerView:(RangPickerView *)pickerView didSelectedString:(NSDictionary  *)dic rangPickerViewType:(RangPickerViewType)rangPickerViewType{
//    {
//        areaId = 3385;
//        areaName = "\U8862\U5dde\U5e02";
//    }
    
    [self updateUserInfo:@{@"cityAreaId":dic[@"areaId"]}];
    
}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lefeArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.lefeArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 ) {
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"perCell"];
        
        [cell.headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataSource[0][0]]] placeholderImage:nil];
        return cell;
    }
    
    
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.lefeArray[indexPath.section][indexPath.row];
    if (self.dataSource.count == 3) {
        
        cell.detailTextLabel.text = self.dataSource[indexPath.section][indexPath.row];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    didSelectIndexPath = indexPath;
    
    if (indexPath.section == 0) {
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [actionSheet showInView:self.view];
        actionSheet = nil;
        
        return;
    }

    if (indexPath.section == 1 && indexPath.row == 0) {

        ChangeNameViewController *vc = [ChangeNameViewController new];
        vc.title = @"修改昵称";
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        SexViewController *vc = [SexViewController new];
        vc.title = @"修改性别";
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        
        ChangePViewController *vc = [ChangePViewController new];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        
        if (_cityArray.count>0) {
         
            [self.pickerView showInView:self.navigationController.view];
            
        }
        
        return;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view         = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - ChangePViewControllerDelegate
- (void)changePhone:(NSString *)phone code:(NSString *)code{
    
    [self updateUserInfo:@{@"telephone":phone,@"verifyCode":code}];
}
#pragma mark - SexDelegate
- (void)changeSex:(NSString *)conten{
    
     [self updateUserInfo:@{@"sex":conten}];
}

#pragma mark - ChangeNameDelegate
- (void)changeName:(NSString *)conten{
    
    [self updateUserInfo:@{@"nickName":conten}];
    
    
}
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
        [self updateUserInfo:@{@"userLogo":object[@"data"][@"imgUrl"]}];

//        _imageDic = object[@"data"];
//        [self.tableview reloadData];
//        NSLog(@"%@",object);
        
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
    } withUpLoadProgress:^(float progress) {
        
    }];
}


@end
