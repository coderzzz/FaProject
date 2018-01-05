//
//  RoomSettingController.m
//  Farbic
//
//  Created by bairuitech on 2017/12/29.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "RoomSettingController.h"
#import "PhotoManager.h"
@interface RoomSettingController ()<UITextFieldDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *descTF;

@end

@implementation RoomSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房间设置";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)pickImage:(id)sender {
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet showInView:self.view];
    actionSheet = nil;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField == _nameTF && _nameTF.text.length>0) {
        
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        [self update:@{@"userId":user.userId,@"roomName":_nameTF.text}];
        return YES;
        
    }
    
    if (textField == _descTF && _descTF.text.length>0) {
        
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        [self update:@{@"userId":user.userId,@"mainBusiness":_descTF.text}];
        return YES;
        
    }
    
    return YES;
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
        
       
        
        //        NSString  *base64Sting = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [self upLoadAvtar:image];
        
    };
}

- (void)upLoadAvtar:(UIImage *)image{
    
     NSData *data  = UIImageJPEGRepresentation(image, 0.2);
    [self showHudInView:self.view];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_uploadPic:@{} withFullUrlString:@"/base/imgUpload" withImageData:data withSuccessBlock:^(NSDictionary *object) {
        
        [self hideHud];
//        [self updateUserInfo:@{@"userLogo":object[@"data"][@"imgUrl"]}];
        
        //        _imageDic = object[@"data"];
        //        [self.tableview reloadData];
        //        NSLog(@"%@",object);
        self.imageV.image = image;
        
        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
        NSString *imgURL = [NSString stringWithFormat:@"%@%@",object[@"data"][@"imgUrlPre"],object[@"data"][@"imgUrl"]];
        [self update:@{@"userId":user.userId,@"imgPath":imgURL}];
        
        
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
    } withUpLoadProgress:^(float progress) {
        
    }];
}


- (void)update:(NSDictionary *)dic{
    
    

    [BAIRUITECH_NetWorkManager FinanceLiveShow_roomSet:dic withSuccessBlock:^(NSDictionary *object) {
        
        
        
        [self showHint:object[@"msg"]];
        if([object[@"ret"] intValue] == 0){
            

        }else{
            
            
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self showHint:error.description];
        
    }];
}

@end
