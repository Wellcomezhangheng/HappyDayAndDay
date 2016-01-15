//
//  discoverModel.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "discoverModel.h"

@implementation discoverModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        self.title = dict[@"title"];
        self.discoverId = dict[@"id"];
//        self.image = dict[@"image"];
        self.type = dict[@"type"];
        self.url = dict[@"url"];
        
        
    }
    return self;
}

@end
