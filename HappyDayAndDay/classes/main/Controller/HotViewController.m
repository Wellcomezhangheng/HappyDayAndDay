//
//  HotViewController.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "HotViewController.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HWtools.h"
#import "HotTableViewCell.h"
#import "ThemeViewController.h"

@interface HotViewController ()<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _pageCount;//定义请求的页码
}
@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *rcArray;


@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title = @"热门专题";
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
    [self showBarkButton];
    
    
}

#pragma mark     UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotTableViewCell *hotCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    hotCell.model = self.rcArray[indexPath.row];

    
    return hotCell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rcArray.count;
}
#pragma mark     UITableViewDelegate
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    hotModel *Model = self.rcArray[indexPath.row];
    ThemeViewController *themeVC = [[ThemeViewController alloc] init];
    themeVC.themeId = Model.hotId;
    [self.navigationController pushViewController:themeVC animated:YES];
    
    
    
    
}
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    
    //下拉刷新，加载数据
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
    
}

//tableView上拉刷新时调用
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount = _pageCount + 1;
    
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
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld",kHotTheme,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDataArray = successDic[@"rcData"];
            for (NSDictionary *dic in acDataArray) {
                hotModel *hotmodel = [[hotModel alloc] initWithDictionary:dic];
                [self.rcArray addObject:hotmodel];
            }
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}//刷新完成时间
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
        self.tableView.rowHeight = 180;
        self.tableView.separatorColor = [UIColor clearColor];
        
    }
    return _tableView;
}

-(NSMutableArray *)rcArray{
    if (_rcArray ==nil) {
        self.rcArray = [NSMutableArray new];
    }
    return _rcArray;
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
