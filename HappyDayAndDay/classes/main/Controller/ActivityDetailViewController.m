//
//  ActivityDetailViewController.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "AFHTTPSessionManager.h"

#import "MBProgressHUD.h"
#import "ActivityDateilView.h"
#import "AppDelegate.h"
@interface ActivityDetailViewController ()
//全局变量
//{
//    NSString *phoneNum;
//}
@property (strong, nonatomic) IBOutlet ActivityDateilView *activityDetailView;
@property (copy, nonatomic) NSString *phoneNum;
@property (weak, nonatomic) UIButton *btn;



@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   self.title = @"活动详情";
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn.frame = CGRectMake(0, 600, kWidth, 75);
//    [self.btn setTitle:@"123" forState:UIControlStateNormal];
//    self.btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.btn];


    
//   
//         UIBarButtonItem *b=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:nil action:nil];
//         UIBarButtonItem *c=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
//         self.navigationItem.rightBarButtonItems=@[b,c];
    
//    self.mainScrollView.contentSize = CGSizeMake(kWidth, 10000) ;
    
    
    //去地图页面
    [self.activityDetailView.mapButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //打电话
    [self.activityDetailView.makeCallButton addTarget:self action:@selector(makeCallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self showBarkButton];
     self.tabBarController.tabBar.hidden = YES;
    
    
    [self getModel];
}
#pragma mark 导航栏右方按钮
//- (void)clickSetting{
//    
//}
//- (void)clickEdit{
//    
//}


#pragma mark -----    Custom Method
- (void)getModel{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        //NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //NSLog(@"%@",responseObject);
      
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"]&&code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityDetailView.dataDic = successDic;
            _phoneNum = successDic[@"tel"];
        
            
        }else{
            NSLog(@"解析不成功");
        }
        
        
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

       // NSLog(@"================%@",error);
    }];
    
}
#pragma mark -------------区地图页面

- (void)mapButtonAction:(UIButton *)button{
    
    
    
}

#pragma mark -------------打电话
- (void)makeCallButtonAction:(UIButton *)button{
    
    //程序外打电话，不返回当前程序
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString :[NSString stringWithFormat:@"tel://%@",_phoneNum]]];
//    
    //程序内打电话，打完电话还返回当前应用程序
    
    UIWebView *cellPhoneWebView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString :[NSString stringWithFormat:@"tel://%@",_phoneNum]]];
    [cellPhoneWebView loadRequest:request];
    [self.view addSubview:cellPhoneWebView];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
