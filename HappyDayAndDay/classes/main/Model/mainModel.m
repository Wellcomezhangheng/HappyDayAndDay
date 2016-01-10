//
//  mainModel.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "mainModel.h"



@implementation mainModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        
        self.type = dict[@"type"];
        
        if ([self.type integerValue]==recommendTypeAcitivity) {
            self.price = dict[@"price"];
            self.lat = [dict [@"lat"]floatValue ];
            self.lng = [dict [@"lng"]floatValue];
            self.address = dict[@"address"];
            self.counts = dict[@"counts"]  ;
            self.startTime = dict[@"startTime"];
            self.endTime = dict[@"endTime"];
           

        }else{
            //如果是推荐专题
            self.activitydescription = dict[@"description"];
        }
        
        self.image_big = dict[@"image_big"];
        self.title = dict[@"title"];
                self.activityId = dict[@"id"];
 
        
    }
    return self;
}

@end
