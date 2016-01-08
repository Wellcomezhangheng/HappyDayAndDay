//
//  ActivityDateilView.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "ActivityDateilView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
@interface ActivityDateilView ()
{
    //保存上一次图片底部的高度
    CGFloat _previousImageBottom;
    //上张图片的高度
    CGFloat _previousImageHeight;
    CGFloat _titleLableBottom;
    CGFloat _desLableBottom;
    CGFloat _lastLabelBottom;
    
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLable;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;
@property (weak, nonatomic) IBOutlet UIImageView *headimageView;
@property (weak, nonatomic) IBOutlet UILabel *activityAdressLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLable;



@end


    



@implementation ActivityDateilView
- (void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 10000);
    
    
}
//- (void)setDataDic:(NSDictionary *)dic{
//    
//}

- (void)setDataDic:(NSDictionary *)dataDic{
    NSArray *urls = dataDic[@"urls"];
    
    
    [self.headimageView sd_setImageWithURL:[NSURL URLWithString:urls[0]]placeholderImage:nil];
    
self.activityTitleLable.text = dataDic[@"title"];
    NSString *starTime = [HWtools getDateFromString:dataDic[@"new_start_date"]];
    NSString *endTime = [HWtools getDateFromString:dataDic[@"new_end_date"]];
    self.activityTimeLable.text = [NSString stringWithFormat:@"正在进行：%@-%@",starTime,endTime];
    
    
    
    self.favoriteLable.text = [NSString stringWithFormat:@"%@人已喜欢",dataDic[@"fav"]];
    self.activityPriceLable.text = dataDic[@"pricedesc"];
    self.activityAdressLable.text = dataDic[@"address"];
    self.phoneNumberLable.text = dataDic[@"tel"];
    [self drawContentWithArray:dataDic[@"content"]];
    
    
}
- (void)drawContentWithArray:(NSArray *)contentArray{
//    
//   
//
//    for (NSDictionary *dic in contentArray) {
//        
//       
//        //每一段活动信息
//        CGFloat height = [HWtools
//                          getTextHeightWithText:dic[@"description"] BigestSize:CGSizeMake(kWidth, 1000) textFont:15.0];
//        CGFloat y;
//        if (_previousImageBottom > 450) {
//            y = 450 + _previousImageBottom - 450;
//        }else{
//            y = 450 + _previousImageBottom;
//        }
//        //如果标题存在
//        NSString *title = dic[@"title"];
//        if (title != nil) {
//            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, 30)];
//            titleLable.text = title;
//            [self.mainScrollView addSubview:titleLable];
//            y+=30;
//        }
//        else{
//            
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, height)];
//            label.text = dic[@"description"];
//            label.numberOfLines = 0;
//            label.font = [UIFont systemFontOfSize:15.0];
//            [self.mainScrollView addSubview:label];
//            
//            NSArray *urlsArray = dic[@"urls"];
//            if (urlsArray == nil) {
//                //当某一个段落中没有图片的时候，上次图片的
//                _previousImageBottom = label.bottom + 10;
//            }else{
//                for (NSDictionary *urldic in urlsArray) {
//                    
//                    if (urlsArray.count>1) {
//                        //图片不只一张
//                        CGFloat width = [urldic[@"width"] integerValue];
//                        CGFloat imageHeight = [urldic[@"height"]integerValue];
//                        
//                                               
//                       
//                                               
//                                               
//                    }
//                    
//                    
//                    
//                    CGFloat width = [urldic[@"width"] integerValue];
//                    CGFloat imageHeight = [urldic[@"height"] integerValue];
//                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.bottom, kWidth - 20, (kWidth - 20)/width * imageHeight)];
//                    imageView.backgroundColor = [UIColor redColor];
//                    [imageView sd_setImageWithURL:[NSURL URLWithString:urldic[@"url"]] placeholderImage:nil];
//                    [self.mainScrollView addSubview:imageView];
//                    _previousImageBottom = imageView.bottom;
//                    _previousImageHeight = imageView.height;
//                }
//                
//            }
//        }
//
//        }
    
//    for (NSDictionary *dic in contentArray) {
//        //每一段活动信息
//        CGFloat height = [HWtools getTextHeightWithText:dic[@"description"] BigestSize:CGSizeMake(kWidth, 1000) textFont:15.0];
//        CGFloat y;
//        if (_previousImageBottom > 450) {
//            y =  _previousImageBottom ;
//        }else{
//            y = 450 + _previousImageBottom;
//        }
//        
//        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, height)];
//        titleLable.text = dic[@"title"];
//        titleLable.numberOfLines = 0;
//        titleLable.font = [UIFont systemFontOfSize:15.0];
//        [self.mainScrollView addSubview:titleLable];
//        _titleLableBottom = titleLable.bottom;
//        
//        UILabel *deslable = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleLableBottom, kWidth-20, height)];
//        deslable.text = dic[@"description"];
//        deslable.numberOfLines = 0;
//        deslable.font = [UIFont systemFontOfSize:15.0];
//        [self.mainScrollView addSubview:deslable];
//        _desLableBottom = deslable.bottom;
//        
//        NSArray *urlsArray = dic[@"urls"];
//        for (NSDictionary *urldic in urlsArray) {
//            CGFloat width = [urldic[@"width"]integerValue];
//            CGFloat height = [urldic[@"height"]integerValue];
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _desLableBottom, kWidth-20, (kWidth-20)/width*height)];
//            imageView.backgroundColor = [UIColor redColor];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:urldic[@"url"]] placeholderImage:nil];
//            [self.mainScrollView addSubview:imageView];
//            _previousImageBottom = imageView.bottom;
//            
//        }
//        
//        
//    }
    
        
            for (NSDictionary *dic in contentArray) {
                //每一段活动信息
                CGFloat height = [HWtools getTextHeightWithText:dic[@"description"] BigestSize:CGSizeMake(kWidth, 1000) textFont:15.0];
                CGFloat y;
                if (_previousImageBottom > 450) { //如果图片底部的高度没有值（也就是小于500）,也就说明是加载第一个lable，那么y的值不应该减去500
                    y = 450 + _previousImageBottom - 450;
                } else {
                    y = 450 + _previousImageBottom;
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
    self.mainScrollView.contentSize = CGSizeMake(kWidth, _lastLabelBottom+20);
        
}

        
        
    
 
            
//            if (urldic.count ==1) {
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _desLableBottom, kWidth-20, (kWidth-20)/width*height)];
//                [self.mainScrollView addSubview:imageView];
//                _previousImageBottom = imageView.bottom;}
//            else{
//                for (int i =0; i<urldic.count; i++) {
//                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _previousImageBottom, kWidth-20, (kWidth-20)/width*height)];
//                    [self.mainScrollView addSubview:imageView];
//                    _previousImageBottom = imageView.bottom;
//                    
//                }
//            }
        

            
            
            
    


//- (void)setDataDi:(NSDictionary *)dic{
////    [self.headimageView sd_setImageWithURL:[NSURL URLWithString:dic[@"image_big"]]placeholderImage:nil];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
