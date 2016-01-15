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
#import "HWtools.h"
#import "ActivityDetailViewController.h"
//#import <MBProgressHUD.h>

@interface GoodViewController ()<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _pageCount;//定义请求的页码
}
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *acArray;
//@property (nonatomic, strong) goodTableViewCell *

@end

@implementation GoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"精选活动";
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"goodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    [self showBarkButton];

    
}
#pragma mark     UITableViewDataSource
- (UITableViewCell *)tableView:(PullingRefreshTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    goodTableViewCell *goodCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   
    goodCell.model=_acArray[indexPath.row];
    
    return goodCell;
    
}
//几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.acArray.count;
}
#pragma mark     UITableViewDelegate
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    goodActivityModel *model = self.acArray[indexPath.row];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
    ActivityDetailViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    
    
    
    
    activityVC.activityId = model.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];

    
    
    
    
}
#pragma mark       PullingRefreshDelegate
////tableView下拉刷新的时候
//- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
//    _pageCount = 1;
//    self.refreshing = YES;
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
//   
//    
//    
//}
////tableView上拉刷新开始的时候调用
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
//    _pageCount += 1;
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
//}

-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;

    //下拉刷新，加载数据
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
    
}

//tableView上拉刷新时调用
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount = _pageCount + 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
    
}


//加载数据调用此方法
- (void)loadData{
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld",kGoodActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            //下拉刷新的时候需要移除数组中的元素
            if (self.refreshing) {
                //下拉
                if (self.acArray.count>0) {
                    [self.acArray removeAllObjects];
                }
                
            }
            
            for (NSDictionary *dic in acDataArray) {
                goodActivityModel *goodMod = [[goodActivityModel alloc] initWithDictionary:dic];
                [self.acArray addObject:goodMod];
              
                
                
            }
            [self.tableView reloadData];
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        //刷新tableView
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}


#pragma mark        lazyLoading

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)pullingDelegate:self];
        self.tableView.delegate =self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 132;
        self.tableView.separatorColor = [UIColor clearColor];
        
    }
    return _tableView;
}

- (NSMutableArray *)acArray{
    if (_acArray == nil) {
        self.acArray = [NSMutableArray new];
    }
    return _acArray;
}





































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
