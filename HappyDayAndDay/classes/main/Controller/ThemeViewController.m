//
//  ThemeViewController.m
//  HappyDayAndDay
//  活动专题
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "ThemeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MBProgressHUD.h>
#import "activityThemeView.h"
@interface ThemeViewController ()
@property (nonatomic, strong)activityThemeView *themeView;
@end

@implementation ThemeViewController


- (void)loadView{
    [super loadView];
    self.themeView = [[activityThemeView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.themeView];
    [self getModel];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBarkButton];
    
}
- (void)getModel{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivityTheme,self.themeId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         //NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"]&&code == 0) {
            self.themeView.dataDic = dic[@"success"];
            //NSLog(@"%@",dic[@"success"]);
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // NSLog(@"================%@",error);
    }];
    
}

-(activityThemeView *)themeView{
    if (_themeView == nil) {
        self.themeView = [[activityThemeView alloc] init];
        
    }
    return _themeView;
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
