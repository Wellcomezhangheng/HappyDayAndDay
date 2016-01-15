//
//  hotModel.h
//  HappyDayAndDay
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hotModel : NSObject
@property (nonatomic, copy) NSString *counts;
@property (nonatomic, copy) NSString *ima;
@property (nonatomic, copy) NSString *hotId;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
