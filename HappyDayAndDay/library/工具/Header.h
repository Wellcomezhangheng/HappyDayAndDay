//
//  Header.h
//  HappyDayAndDay
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 张衡. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ClassifyListType) {
    ClassifyListTypeShowRepertoire =1,//演出剧目
    ClassifyListTypeTouristPlace,      //景点场馆
    ClassifyListTypeStudyPUZ,          //学习益智
    ClassifyListTypeFamilyTravel      //亲子旅游
};



//首页数据接口
#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"

//活动详情接口
#define kActivityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&cityid=1&lat=34.61356779156581&lng=112.4141403843618"
//活动专题接口
#define kActivityTheme @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&lat=34.61349052974207&limit=30&lng=112.4139739846577&page=1"
//精选活动接口
#define kGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&type=1"
//热门专题接口
#define kHotTheme @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942"
//分类列表接口
#define kClassify @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"

//page=1&typeid=6
//发现
#define kDiscover @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411"

//新浪微博分享
#define kAppKey @"1218635076"
#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"
#define kAppSecrt e56bee3e6281cce105e8dbb254bb1596
#define kAppId @"wxc75333f44e67640a"
#define kweixinAppSecret 18f955856b32d9f471e3d52cb1b377d9
#endif /* Header_h */



