//
//  AdDataModel.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "AdDataModel.h"

@implementation AdDataModel
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
- (instancetype)initWithary:(NSArray *)imageArray{
    self = [super init];
    if (self) {
        self.imageNameArray = imageArray;
        
    }
    return self;
}

//+ (id)adDataModelWithImageName
//{
//    return [[self alloc]initWithImageName];
//}
//
//+ (id)adDataModelWithImageNameAndAdTitleArray
//{
//    return [[self alloc]initWithImageNameAndAdTitleArray];
//}

@end
