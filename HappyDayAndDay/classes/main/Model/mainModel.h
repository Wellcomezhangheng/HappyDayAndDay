//
//  mainModel.h
//  HappyDayAndDay
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    //推荐活动
    recommendTypeAcitivity = 1,
    //推荐专题
    recommendTypeTheme
    
    
    
}recommendType;

@interface mainModel : NSObject
//首页大图
@property (nonatomic, copy) NSString *image_big;
//标题
@property (nonatomic, copy) NSString *title;
//价格
@property (nonatomic, copy) NSString *price;
//经纬度
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, copy) NSString *counts;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *activitydescription;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end