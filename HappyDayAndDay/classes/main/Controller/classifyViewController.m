//
//  classifyViewController.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "classifyViewController.h"
#import "VOSegmentedControl.h"
#import "PullingRefreshTableView.h"
#import "goodTableViewCell.h"
#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HWtools.h"
#import "ProgressHUD.h"
@interface classifyViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _pageCount;//定义请求的页码
}
@property(nonatomic, strong) NSArray *acData;

@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *showDataArray;//负责展示的数组3
@property (nonatomic, strong) NSMutableArray *showArray;//演出剧目
@property (nonatomic, strong) NSMutableArray *touristArray;
@property (nonatomic, strong) NSMutableArray *studyArray;
@property (nonatomic, strong) NSMutableArray *familyArray;
@property (nonatomic, strong) VOSegmentedControl *segementedControl;

@end

@implementation classifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    [self showBarkButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"goodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.title = @"分类列表";
    [self.view addSubview:self.segementedControl];
    [self.view addSubview:self.tableView];
    _pageCount = 1;
    //[self chooseRequest];
}
//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark      ------------------UITabelViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    goodTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    goodCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    goodCell.model=_showDataArray[indexPath.row];
    
    return goodCell;
}
//几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showDataArray.count;
    
}
#pragma mark      ------------------UITabelViewDelegate
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    goodActivityModel *model = self.showDataArray[indexPath.row];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
    ActivityDetailViewController *activityVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    
    
    activityVC.activityId = model.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];
}
#pragma mark      ------------------PullingRefreshTabelViewDelegate
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    //下拉刷新，加载数据
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}
//tableView上拉刷新时调用
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount = _pageCount + 1;
    self.refreshing = NO;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
}
#pragma mark      ------------------Custom Method

- (void)chooseRequest{
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getOneRequest];
            break;
        case ClassifyListTypeTouristPlace:
            [self getTwoRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getThreeRequest];
            break;
        case ClassifyListTypeFamilyTravel:
            [self getFourRequest];
            break;
        default:
            break;
    }
}
- (void)getOneRequest{
     [ProgressHUD show:@"加载中"];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    [self.tableView reloadData];
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassify,_pageCount,@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
ZHLog(@"download=%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHLog(@"responseObject=%@",responseObject);
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.refreshing) {
                if (self.showArray.count>0) {
                    [self.showArray removeAllObjects];
                }
            }
                      for (NSDictionary *dic in acDataArray) {
                goodActivityModel *goodMod = [[goodActivityModel alloc] initWithDictionary:dic];
                [self.showArray addObject:goodMod];
            }
            [self.tableView reloadData];
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZHLog(@"error=%@",error);
    }];
    //根据上一页选择的按钮，确定选择具体的第几页的数据
    [self showPreviousSelectButton];
}
- (void)getTwoRequest{
     [ProgressHUD show:@"加载中"];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    [self.tableView reloadData];
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassify,_pageCount,@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZHLog(@"download=%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHLog(@"responseObject=%@",responseObject);
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.refreshing) {
                if (self.touristArray.count>0) {
                    [self.touristArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in acDataArray) {
                goodActivityModel *goodMod = [[goodActivityModel alloc] initWithDictionary:dic];
                [self.touristArray addObject:goodMod];
            }
            [self.tableView reloadData];
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZHLog(@"error=%@",error);
    }];
    //根据上一页选择的按钮，确定选择具体的第几页的数据
    [self showPreviousSelectButton];
}
- (void)getThreeRequest{
     [ProgressHUD show:@"加载中"];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    [self.tableView reloadData];
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassify,_pageCount,@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZHLog(@"download=%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHLog(@"responseObject=%@",responseObject);
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            if (self.refreshing) {
                if (self.studyArray.count>0) {
                    [self.studyArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in acDataArray) {
                goodActivityModel *goodMod = [[goodActivityModel alloc] initWithDictionary:dic];
                [self.studyArray addObject:goodMod];
            }
            [self.tableView reloadData];
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZHLog(@"error=%@",error);
    }];
    //根据上一页选择的按钮，确定选择具体的第几页的数据
    [self showPreviousSelectButton];
}
- (void)getFourRequest{
     [ProgressHUD show:@"加载中"];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    [self.tableView reloadData];
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manger GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassify,_pageCount,@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZHLog(@"download=%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHLog(@"responseObject=%@",responseObject);
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            NSArray *acDataArray = successDic[@"acData"];
            for (NSDictionary *dic in acDataArray) {
                if (self.refreshing) {
                    if (self.familyArray.count>0) {
                        [self.familyArray removeAllObjects];
                    }
                }
                goodActivityModel *goodMod = [[goodActivityModel alloc] initWithDictionary:dic];
                [self.familyArray addObject:goodMod];
            }
            [self.tableView reloadData];
        }
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZHLog(@"error=%@",error);
    }];
    //根据上一页选择的按钮，确定选择具体的第几页的数据
    [self showPreviousSelectButton];
}
- (void)showPreviousSelectButton{
    if (self.refreshing) {//下拉删除原来的数据
        if (self.showDataArray.count>0) {
            [self.showDataArray removeAllObjects];
        }
    }
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;
        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;
        case ClassifyListTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
        }
            break;
        default:
            break;
    }
    //完成加载
    //    [self.tableView tableViewDidFinishedLoading];
    //    self.tableView.reachedTheEnd = NO;
    //刷新
    [self.tableView reloadData];
}





- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight-64-40)pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 120;
//        self.tableView.separatorColor = [UIColor clearColor];
        
    }
    return _tableView;
}
- (NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}
- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}
- (NSMutableArray *)touristArray{
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}
- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}
- (NSMutableArray *)familyArray{
    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
}
- (NSArray *)acData{
    
    if (_acData == nil) {
        _acData =[[NSArray alloc]init];
        
        
    }
    return _acData;
}
- (VOSegmentedControl *)segementedControl{
    if (_segementedControl == nil) {
        _segementedControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点场馆"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子旅游"}]];
        self.segementedControl.textColor=[UIColor grayColor];
        self.segementedControl.selectedTextColor=[UIColor colorWithRed:0 green:185/255.0f blue:189/255.0f alpha:1.0];
        self.segementedControl.selectedIndicatorColor=[UIColor colorWithRed:0 green:185/255.0f blue:189/255.0f alpha:1.0];
        self.segementedControl.contentStyle = VOContentStyleTextAlone;
        self.segementedControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segementedControl.backgroundColor = [UIColor whiteColor];
        self.segementedControl.indicatorColor=[UIColor colorWithRed:0 green:185/255.0f blue:189/255.0f alpha:1.0];
        self.segementedControl.allowNoSelection = NO;
        self.segementedControl.frame = CGRectMake(0 , 0, kWidth,44);
        self.segementedControl.selectedSegmentIndex=self.classifyListType+1;
        self.segementedControl.indicatorThickness = 4;
        __block NSInteger selectIndex;
        [self.segementedControl setIndexChangeBlock:^(NSInteger index) {
            selectIndex=index;
            NSLog(@"1: block --> %@", @(index));
        }];
        [self.segementedControl addTarget:self action:@selector(segementCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segementedControl;
}
- (void)segementCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
    self.classifyListType = segmentCtrl.selectedSegmentIndex+1;
    [self chooseRequest];
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
