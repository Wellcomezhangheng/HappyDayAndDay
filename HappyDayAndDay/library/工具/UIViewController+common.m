//
//  UIViewController+common.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "UIViewController+common.h"

@implementation UIViewController (common)


- (void)showBarkButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES ];
    
}
@end
