//
//  RangPickerView.m
//  iwen
//
//  Created by Interest on 15/10/20.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "RangPickerView.h"

#define AnimateWithDuration  0.2

#define ToolBarHeight        48

#define PickerViewHeight        216


#define DoneBtnFont          [UIFont systemFontOfSize:14]

@implementation RangPickerView
{
    NSInteger index;
}
- (id)init{
    
    self = [super init];
    
    if (self) {
        
        index = 0;
        
        [self addSubview:self.toolbar];
        
        [self addSubview:self.pickerView];
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, ToolBarHeight + PickerViewHeight);
        
    }
    return self;
}

#pragma Action

- (void)done{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectedString:rangPickerViewType:)]) {
        
//        NSString *str = self.dataSource[[self.pickerView selectedRowInComponent:1]];
        
        NSArray *citys = self.dataSource[index][@"cities"];
        NSDictionary *dic = citys[[self.pickerView selectedRowInComponent:1]];
        
        [self.delegate pickerView:self didSelectedString:dic rangPickerViewType:self.rangPickerViewType];
        
    }
    
    
    
    [self dismiss];
    
}


- (void)showInView:(UIView *)view{
    
    [self removeFromSuperview];
    
    [view addSubview:self];
    
    [UIView animateWithDuration:AnimateWithDuration animations:^{
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT-64-ToolBarHeight-PickerViewHeight, SCREEN_WIDTH,  ToolBarHeight + PickerViewHeight);
        
        
    }];
    
    self.isShowing = YES;
}


- (void)dismiss{
    
    
    [UIView animateWithDuration:AnimateWithDuration animations:^{
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, ToolBarHeight + PickerViewHeight);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.isShowing = NO;
            
            [self removeFromSuperview];
        }
    }];
    
    
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        
        return  self.dataSource.count;

    }
    else{
        
        NSArray *citys = self.dataSource[index][@"cities"];
        return citys.count;
        
    }
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        
        return  self.dataSource[row][@"provinceAreaName"];;
        
    }
    else{
        
        NSArray *citys = self.dataSource[index][@"cities"];
        return citys[row][@"areaName"];
        
    }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (component == 0) {
        index = row;
        [pickerView reloadComponent:1];
    }
    
}



#pragma  mark getter

- (void)setDataSource:(NSMutableArray *)dataSource{
    
    if (dataSource) {
        
        _dataSource = dataSource;
        
        [self.pickerView reloadAllComponents];
        
        
    }
    
    
    
}

- (UIToolbar *)toolbar{
    
    if (_toolbar == nil) {
        
        _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ToolBarHeight)];
        
        
         _toolbar.backgroundColor = BGColor;
        
        UIBarButtonItem *spaceItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:self
                                                                                   action:nil];
        
        UIButton *doneBtn         = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        doneBtn.titleLabel.font   = DoneBtnFont;
        
        [doneBtn addTarget:self action:@selector(done)
            forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
        
        _toolbar.items              = @[spaceItem,doneItem];
        
        
        
       
        
    }
    
    return _toolbar;
}

- (UIPickerView *)pickerView{
    
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ToolBarHeight, SCREEN_WIDTH, PickerViewHeight)];
        
        _pickerView.dataSource = self;
        
        _pickerView.delegate   = self;
        
        _pickerView.backgroundColor = BGColor;
        
    }
    
    return _pickerView;
    
}



@end
