//
//  hotModel.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "hotModel.h"

@implementation hotModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.counts = dict[@"counts"];
        self.ima = dict[@"img"];
        self.hotId = dict[@"id"];
    }
    return self;
}
@end
