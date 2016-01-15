//
//  activityThemeView.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "activityThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface activityThemeView ()
{
    //保存上一次图片底部的高度
    CGFloat _previousImageBottom;
    //上张图片的高度
    CGFloat _previousImageHeight;
    CGFloat _titleLableBottom;
    CGFloat _desLableBottom;
    CGFloat _lastLabelBottom;
    
    
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView *headImageView;

@end
@implementation activityThemeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}




#pragma mark   setDic  Model传值
//在set方法中赋值
-(void)setDataDic:(NSDictionary *)dataDic{
    NSString *headStr = dataDic[@"image"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headStr]placeholderImage:nil];
//    NSLog(@"%@",dataDic[@"image"]);
       [_mainScrollView addSubview:_headImageView];
     [self drawContentWithArray:dataDic[@"content"]];
    
    
    
}

- (void)drawContentWithArray:(NSArray *)contentArray{
    for (NSDictionary *dic in contentArray) {
        //每一段活动信息
        CGFloat height = [HWtools getTextHeightWithText:dic[@"description"] BigestSize:CGSizeMake(kWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_previousImageBottom > 186) { //如果图片底部的高度没有值（也就是小于500）,也就说明是加载第一个lable，那么y的值不应该减去500
            y = 186 + _previousImageBottom - 186;
        } else {
            y = 186 + _previousImageBottom;
        }
        NSString *title = dic[@"title"];
        if (title != nil) {
            //如果标题存在,标题的高度应该是上次图片的底部高度
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        //保留最后一个label的高度，+ 64是下边tabbar的高度
        _lastLabelBottom = label.bottom + 10 + 20;
        
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) { //当某一个段落中没有图片的时候，上次图片的高度用上次label的底部高度+10
            _previousImageBottom = label.bottom + 10;
        } else {
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlsArray) {
                CGFloat imgY;
                if (urlsArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) { //有title的算上title的30像素
                            imgY = _previousImageBottom + label.height + 30 + 5;
                        } else {
                            imgY = _previousImageBottom + label.height + 5;
                        }
                    } else {
                        imgY = lastImgbottom + 10;
                    }
                    
                } else {
                    //单张图片的情况
                    imgY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imgY, kWidth - 20, (kWidth - 20)/width * imageHeight)];
                imageView.backgroundColor = [UIColor redColor];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                _previousImageBottom = imageView.bottom + 5;
                if (urlsArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
                
            }
        }
        
    }
    if (_lastLabelBottom>_previousImageBottom) {
        self.mainScrollView.contentSize = CGSizeMake(kWidth, _lastLabelBottom+30);
    }else{
    self.mainScrollView.contentSize = CGSizeMake(kWidth, _previousImageBottom+30);
    }
}






- (void)configView{
    
    //[_mainScrollView addSubview:_headImageView];
    [self addSubview:self.mainScrollView];
    
}


#pragma mark   懒加载
-(UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 186)];
    }
    return _headImageView;
}
-(UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
//        //当网络请求速度比较慢
//        _mainScrollView.contentSize = CGSizeMake(kWidth, 10000);
    }
    return _mainScrollView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
