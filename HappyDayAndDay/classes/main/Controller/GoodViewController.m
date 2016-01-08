//
//  GoodViewController.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "GoodViewController.h"
#import "PullingRefreshTableView.h"
#import "goodTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MBProgressHUD.h>

@interface GoodViewController ()<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _pageCount;//定义请求的页码
}
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
//@property (nonatomic, strong) goodTableViewCell *

@end

@implementation GoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精选活动";
    self.tabBarController.tabBar.hidden = YES;
    [self showBarkButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"goodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
//    self.tableView.tableFooterView = [[UIView alloc] init];
    //启动刷新
    [self.tableView launchRefreshing];
    
    
    [self loadData];
}
#pragma mark     UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    goodTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return goodCell;
    
}
//几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
#pragma mark     UITableViewDelegate
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark       PullingRefreshDelegate
//tableView下拉刷新的时候
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
   
    
    
}
//tableView上拉刷新开始的时候调用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}


//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
}

//加载数据
- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%@",kGoodActivity,@(1)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // NSLog(@"%@",responseObject);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // NSLog(@"================%@",error);
    }];

    
    
    
    
    
  //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    
}
//手指开始拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
}


#pragma mark        lazyLoading

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)pullingDelegate:self];
        self.tableView.delegate =self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 90;
        
    }
    return _tableView;
}








































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
