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
@property (nonatomic, retain) UISegmentedControl *segmentControl;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *showDataArray;//负责展示的数组3
@property (nonatomic, strong) NSMutableArray *showArray;//演出剧目
@property (nonatomic, strong) NSMutableArray *touristArray;
@property (nonatomic, strong) NSMutableArray *studyArray;
@property (nonatomic, strong) NSMutableArray *familyArray;
@property (nonatomic, strong) VOSegmentedControl *segementedControl;
@property(nonatomic, strong) NSMutableArray *allGroupArray;
@end

@implementation classifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    //[self configData];
    [self showBarkButton];
    [self.view
     addSubview:self.segmentControl];
    [self.view addSubview:self.tableView];
    
    
      [self chooseRequest];
    
    
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







//网络请求

- (void)getOneRequest{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
   
    // typeid = 6 演出剧目
    [manger GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",kClassify,@(1),@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZHLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            _acData = successDic[@"acData"];
            for (NSDictionary *dic in self.acData) {
                goodActivityModel *goodModel = [[goodActivityModel alloc] initWithDictionary:dic];
                
                [self.showArray addObject:goodModel];
            }
            
        } else {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZHLog(@"error = %@",error);
    }];
   
}
- (void)getTwoRequest{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // typeid = 23 景点场馆
    [ProgressHUD show:@"加载中"];
    [manger GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",kClassify,@(1),@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            _acData = successDic[@"acData"];
            for (NSDictionary *dic in _acData) {
                goodActivityModel *goodModel = [[goodActivityModel alloc] initWithDictionary:dic];
                [self.touristArray addObject:goodModel];
            }
        } else {
    }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZHLog(@"error = %@",error);
    }];
    //根据上一页选择的按钮，确定选择具体的第几页的数据
    [self showPreviousSelectButton];
}
- (void)getThreeRequest{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // typeid = 22 学习益智
    [ProgressHUD show:@"加载中"];

    [manger GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",kClassify,@(1),@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        NSString *status = dict[@"status"];
        NSInteger code = [dict[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dict[@"success"];
            _acData = successDic[@"acData"];
            for (NSDictionary *dic in _acData) {
                goodActivityModel *goodModel = [[goodActivityModel alloc] initWithDictionary:dic];
                [self.studyArray addObject:goodModel];
            }
        } else {
    }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZHLog(@"error = %@",error);
    }];
    //根据上一页选择的按钮，确定选择具体的第几页的数据
    [self showPreviousSelectButton];
}
- (void)getFourRequest{
    //获取网络数据
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // typeid = 21 亲子旅游
    [ProgressHUD show:@"加载中"];

    [manger GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",kClassify,@(1),@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHLog(@"%@",responseObject);
    NSDictionary *dict = responseObject;
    NSString *status = dict[@"status"];
    NSInteger code = [dict[@"code"] integerValue];
    if ([status isEqualToString:@"success"] && code == 0) {
    NSDictionary *successDic = dict[@"success"];
    _acData = successDic[@"acData"];
    for (NSDictionary *dic in _acData) {
    goodActivityModel *goodModel = [[goodActivityModel alloc] initWithDictionary:dic];
    [self.familyArray addObject:goodModel];
}
            
} else {
            
}
//根据上一页选择的按钮，确定选择具体的第几页的数据
    [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    ZHLog(@"error = %@",error);
    }];
}

- (void)showPreviousSelectButton{
    
    if (self.showDataArray.count>0) {
        [self.showDataArray removeAllObjects];
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


#pragma mark      ------------------懒加载

-

- (VOSegmentedControl *)segmentControl{
    if (_segementedControl == nil) {
        
        
        
        __block NSInteger selectIndex;
        [self.segementedControl setIndexChangeBlock:^(NSInteger index) {
            selectIndex=index;
            
            
            NSLog(@"1: block --> %@", @(index));
        }];
        //self.classfylistType=selectIndex;
        [self.segementedControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
}
    return _segementedControl;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
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
