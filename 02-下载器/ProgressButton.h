//
//  ProgressButton.h
//  02-下载器
//
//  Created by 汤蓉 on 15/6/11.
//  Copyright (c) 2015年 zhm. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface ProgressButton : UIButton

///  进度 0~1
@property (nonatomic, assign) IBInspectable float progress;

///  线条颜色
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
///  线条宽度
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;

@end
