//
//  goodActivityModel.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "goodActivityModel.h"

@implementation goodActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict [@"title"];
        self.image = dict [@"image"];
        self.age = dict [@"age"];
        self.counts = dict [@"counts"];
        self.type = dict [@"type"];
        self.price = dict [@"price"];
        self.activityId = dict [@"id"];
        self.address = dict [@"address"];
    }
    return self;
}

@end
