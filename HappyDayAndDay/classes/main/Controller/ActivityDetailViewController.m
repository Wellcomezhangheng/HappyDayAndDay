//
//  ActivityDetailViewController.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MBProgressHUD.h>

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
   self.title = @"活动详情";
    [self showBarkButton];
    
   // [self getModel];
}




#pragma mark -----    Custom Method
- (void)getModel{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"+++++++++++++++++++++%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"================%@",error);
    }];
    
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
