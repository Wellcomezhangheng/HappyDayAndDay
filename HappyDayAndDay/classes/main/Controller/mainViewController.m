//
//  mainViewController.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "mainViewController.h"
#import "SeclectCityViewController.h"
#import "sousuoViewController.h"
#import "ActivityDetailViewController.h"
#import "mainTableViewCell.h"
#import "ThemeViewController.h"
#import "classifyViewController.h"
#import "GoodViewController.h"
#import "HotViewController.h"
//#import <AFURLSessionManager.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "mainModel.h"
#import <UIImageView+WebCache.h>

@interface mainViewController ()

@property (nonatomic, retain)UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数组
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数组
@property (nonatomic, strong) NSMutableArray *themeArray;
//广告图片数组
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *allView;//头部
@property (nonatomic, strong) UIImageView *ima;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *hotBtn;
@end

@implementation mainViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    //注册一下cell
    [self.tableView registerNib:[UINib nibWithNibName:@"mainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   //导航栏左右按钮
    [self Item];
    //网络请求
       [self work];
    //tableView的自定义头部标题
    [self configTableViewHeaderView];
   //定时器
    [self addTimer];
}

#pragma mark  page(页面实现方法)
- (void)pageSelectAction:(UIPageControl *)pageControl{
    NSInteger pageNum = pageControl.currentPage;
    CGFloat pageWidth = self.scroll.frame.size.width;
    self.scroll.contentOffset = CGPointMake(pageNum*pageWidth, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewWidth/2)/scrollViewWidth;
    self.pageControl.currentPage = page;
    
}
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
//    return NO;
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
- (void)addTimer{
//    if (self.timer !=nil ) {
//        
//    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
}

- (void)removeTimer{
    [self.timer invalidate];
//    self.timer = nil;//停止定时器后置为nil，再次启动
}

- (void)nextImage{
    int page = (int)self.pageControl.currentPage;
    if (page >= self.adArray.count-1) {
        
        page = 0;
        
        self.scroll.contentOffset = CGPointMake(0, 0);
    }
    else{
        page++;
        CGFloat x = page *self.scroll.frame.size.width;
        [self.scroll setContentOffset:CGPointMake(x, 0) animated:YES];

        
        
        
    }
//    CGFloat x = page *self.scroll.frame.size.width;
//   // [self.scroll setContentOffset:CGPointMake(x, 0) animated:YES];
//    
//    self.scroll.contentOffset = CGPointMake(x, 0);
    
}

#pragma mark  导航栏左右按钮
- (void)Item{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"郑州≡" style:UIBarButtonItemStylePlain target:self action:@selector(left:)];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 14, 14);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbarButtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightbarButtn;
    
}
#pragma mark  网络请
- (void)work{
    NSString *urling = kMainDataList;
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:urling parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        ZHLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //responseObject结果
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"]integerValue];
        if ([status isEqualToString:@"success"]&&code ==0 ) {
            NSDictionary *dic = resultDic[@"success"];
            NSArray *acDataArray = dic[@"acData"];//活动
            for (NSDictionary *dict in acDataArray) {
                mainModel *model = [[mainModel alloc] initWithDictionary:dict];
                [self.activityArray addObject:model];
                
            }
            [self.listArray addObject:self.activityArray];
            NSArray *adDataArray = dic[@"adData"];//广告
            for (NSDictionary *dict in adDataArray) {
                NSDictionary *dic = @{@"url":dict[@"url"],@"type":dict[@"type"],@"id":dict[@"id"]};

                [self.adArray addObject:dic];
               
            }
            [self configTableViewHeaderView];
            NSArray *rcDataArray = dic[@"rcData"];//专题
            for (NSDictionary *dict in rcDataArray) {
                mainModel *model = [[mainModel alloc] initWithDictionary:dict];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            [self.tableView reloadData];
            //
            NSString *cityname = dic[@"cityname"];
            //以请求回来的城市作为导航栏按钮标题
            self.navigationItem.leftBarButtonItem.title = cityname;
        }
       else{
            
        }
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
}
#pragma mark 自定义头部
- (void)configTableViewHeaderView{
    
    self.allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 343)];
    self.allView.backgroundColor=[UIColor whiteColor];
//设置tableView的自定义头部
    self.tableView.tableHeaderView = self.allView;
    self.ima = [UIImageView new];
    
    for (int i = 0; i<self.adArray.count; i++) {
      
    
        self.ima = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth*i, 0, kWidth, 186)];
        [self.ima sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]]placeholderImage:nil];
//用户交互
        self.ima.userInteractionEnabled = YES;
      
        [self.scroll addSubview:self.ima];
        [self.allView addSubview:self.pageControl];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = self.ima.frame;
        touchBtn.tag = 100+i;
        [touchBtn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll addSubview:touchBtn];
        
        
    }
    for (int i =0; i<5; i++) {
        self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(kWidth/4*i,186 , kWidth/4, kWidth/4);
        NSString *imastr = [NSString stringWithFormat:@"home_icon_%d",i+1];
        [_button1 setImage:[UIImage imageNamed:imastr] forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(mainActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.allView addSubview:_button1];
    }
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(0, 186+kWidth/4, kWidth/2, 343-186-kWidth/4);
    NSString *Actstr = [NSString stringWithFormat:@"home_huodong"];
    [self.selectBtn setImage:[UIImage imageNamed:Actstr] forState:UIControlStateNormal];
    [self.selectBtn addTarget:self action:@selector(jingxuanActivity) forControlEvents:UIControlEventTouchUpInside];
    [self.allView addSubview:self.selectBtn];

    
    
    
    
    

    
#pragma mark  6个按钮
    
    
    
    self.hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hotBtn.frame = CGRectMake(kWidth/2, 186+kWidth/4, kWidth/2, 343-186-kWidth/4);
    NSString *Topicstr = [NSString stringWithFormat:@"home_zhuanti"];
    [self.hotBtn setImage:[UIImage imageNamed:Topicstr] forState:UIControlStateNormal];
    [self.hotBtn addTarget:self action:@selector(TopicActivity) forControlEvents:UIControlEventTouchUpInside];
    [self.allView addSubview:self.hotBtn];
    
    
}
#pragma mark  点击广告方法
- (void)touch:(UIButton *)adBtn{
    
    NSString *type = self.adArray[adBtn.tag - 100][@"type"];
    if ([type integerValue] == 1) {
        ActivityDetailViewController *activityVC = [[ActivityDetailViewController alloc] init];
        //活动id
        activityVC.activityId = self.adArray[adBtn.tag - 100][@"id"];
        
        
        [self.navigationController pushViewController:activityVC animated:YES];
    }
    else{
        HotViewController *hotVC = [[HotViewController alloc] init];
        [self.navigationController pushViewController:hotVC animated:YES];
    }
    
    
}


#pragma mark  精选活动按钮方法
- (void)jingxuanActivity{
 
    GoodViewController *goodVC = [[GoodViewController alloc] init];
    [self.navigationController pushViewController:goodVC animated:YES];
    
}
#pragma mark  热门专题按钮方法
- (void)TopicActivity{
    HotViewController *hotVC = [[HotViewController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];
}
#pragma mark 4个按钮方法
- (void)mainActivityButtonAction{
    
    classifyViewController *classVC = [[classifyViewController alloc] init];
    [self.navigationController pushViewController:classVC animated:YES];
    
}

#pragma mark 懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}
- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}
- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
#pragma mark  图片轮播
      
    }
    return _adArray;
}
- (UIScrollView *)scroll{
    if (_scroll == nil) {
        //self.scroll = [UIScrollView new];
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 186)];
        self.scroll.contentSize = CGSizeMake(kWidth*self.adArray.count, 186);
        self.scroll.pagingEnabled = YES;
        self.scroll.bounces = NO;
        //不显示水平方向的滚动条
        self.scroll.showsHorizontalScrollIndicator = NO;
        self.scroll.alwaysBounceHorizontal = NO;
        self.scroll.delegate = self;
 [self.allView addSubview:self.scroll];
    }
    return _scroll;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [UIPageControl new];
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 160, kWidth, 30)];
        self.pageControl.numberOfPages = 5;
        [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventTouchUpInside];
       

    }
    return _pageControl;
}
- (UIButton *)button1{
    if (_button1 == nil) {
        self.button1 = [UIButton new];
           }
    return _button1;
}
- (UIButton *)selectBtn{
    if (_selectBtn == nil) {
        self.selectBtn = [UIButton new];
    }
    return _selectBtn;
}


#pragma mark  左右导航栏按钮方法
#pragma mark  搜索
- (void)right:(UIButton *)Barbtn{
    
    sousuoViewController *sousuoVC = [[sousuoViewController alloc] init];
    [self.navigationController pushViewController:sousuoVC animated:YES];
   
    
}
#pragma mark  选择城市
- (void)left:(UIBarButtonItem *)Barbtn{
    SeclectCityViewController *secVC = [[SeclectCityViewController alloc] init];
    [self.navigationController presentViewController:secVC animated:YES completion:nil];

   
}

#pragma mark 每个分区里有几行

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }else{
        return self.themeArray.count;
    }
}
#pragma mark  自定义分区头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
     UIView *view1 = [[UIView alloc] init];
     UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-160, 5, 320, 16)];
    if (section == 0) {
       
       
        imageV.image = [UIImage imageNamed:@"home_recommed_ac.png"];
        [view1 addSubview:imageV];
        
    }
    else{
       
        
        imageV.image = [UIImage imageNamed:@"home_recommd_rc.png"];
        [view1 addSubview:imageV];

    }
    return view1;
}
#pragma mark  几个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
#pragma mark  Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    mainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.model=array[indexPath.row];
    return mainCell;
    
}



#pragma mark    每个分区里每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 203;
    
    }
    else{
        return 186;
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityDetailViewController *acDe = [[ActivityDetailViewController alloc] init];
        [self.navigationController pushViewController:acDe animated:YES];
    }else{
        ThemeViewController *thVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:thVC animated:YES];
    }
    
    
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
