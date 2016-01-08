//
//  ActivityDateilView.h
//  HappyDayAndDay
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDateilView : UIView
//在外部使用
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *makeCallButton;
@property (nonatomic, retain) NSDictionary *dataDic;
@property (nonatomic, retain) NSDictionary *dataDi;


@end

