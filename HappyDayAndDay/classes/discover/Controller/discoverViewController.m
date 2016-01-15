//
//  discoverViewController.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "discoverViewController.h"
#import "discoverTableViewCell.h"
#import "HWtools.h"
#import <AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "AdScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface discoverViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *likeArray;
@property (nonatomic, strong) NSMutableArray *headImageArray;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation discoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发现";
    [self.view addSubview:self.tableView];
  [self.tableView registerNib:[UINib nibWithNibName:@"discoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //删除边缘效果
  self.edgesForExtendedLayout = UIRectEdgeNone;
    //tableView的头部标题
     [self loadData];
   [self configHeaderView];
  
}
- (void)configHeaderView{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 90+kWidth/3)];
//    self.headView.backgroundColor = [UIColor blueColor];
    self.tableView.tableHeaderView = self.headView;
    self.headImageView = [UIImageView new];
    self.headImageView.backgroundColor=[UIColor cyanColor];
    for (int i =0; i<self.likeArray.count; i++) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/3*i, 40, kWidth/3, kWidth/3)];

         [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.likeArray[i][@"url"]]placeholderImage:nil];
       
        [self.scrollView addSubview:self.headImageView];
    }

    
    
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.likeArray.count;
}
-(UITableViewCell *)tableView:(PullingRefreshTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}
-(NSMutableArray *)likeArray{
    if (_likeArray == nil) {
        _likeArray = [NSMutableArray new];
    }
    return _likeArray;
}
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0,0 , kWidth, kHeight-64-44)style:UITableViewStylePlain];
        self.tableView.delegate =self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 132;
        self.tableView.separatorColor = [UIColor clearColor];
        [self.tableView setHeaderOnly:YES];
//        M_PI 180°
       
    }
    return _tableView;

}
- (NSMutableArray *)headImageArray{
    if (_headImageArray == nil) {
        self.headImageArray = [NSMutableArray new];
    }
    return _headImageArray;
}
- (UIView *)headView{
    if (_headView == nil) {
        _headView = [UIView new];
    }
    return _headView;
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kWidth/3, kWidth/3)];
        self.scrollView.contentSize = CGSizeMake(kWidth/3*self.likeArray.count, kWidth/3);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        //不显示水平方向的滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.alwaysBounceHorizontal = NO;
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor redColor];
        [self.headView addSubview:self.scrollView];

    }
    return _scrollView;
}

- (void)loadData{
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"正在加载"];
    [manger GET:[NSString stringWithFormat:@"%@",kDiscover] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        //ZHLog(@"%@",responseObject);
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *likeArray = successDic[@"like"];
            for (NSDictionary *dic in likeArray) {
                NSDictionary *dict = @{@"image":dic[@"image"],@"type":dic[@"type"],@"title":dic[@"title"]};
                
                [self.likeArray addObject:dict];
                
                
            }
            
            
            NSArray *gouwuArray = successDic[@"gouwu"];
            NSArray *yuer = successDic[@"yuer"];
            
            
           
                
                
                
            
            [self.tableView reloadData];
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        //刷新tableView
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
