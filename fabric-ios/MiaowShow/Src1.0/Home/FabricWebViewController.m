//
//  FabricWebViewController.m
//  MiaowShow
//
//  Created by bairuitech on 2017/9/12.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "FabricWebViewController.h"
#import <WebKit/WebKit.h>
@interface FabricWebViewController ()

@property (nonatomic,strong) WKWebView *webView;


@end

@implementation FabricWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"商城";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回-1"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64)];
    [self.view addSubview:self.webView];
    NSLog(@"webView loadRequest %@",self.strUrl);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
}


- (void)back{
    
    if (self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

@end
