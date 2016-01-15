//
//  discoverModel.h
//  HappyDayAndDay
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface discoverModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *discoverId;
//@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;



- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
