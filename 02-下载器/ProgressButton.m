//
//  ProgressButton.m
//  02-下载器
//
//  Created by 汤蓉 on 15/6/11.
//  Copyright (c) 2015年 zhm. All rights reserved.
//

#import "ProgressButton.h"

@implementation ProgressButton

- (void)setProgress:(float)progress
{
    _progress = progress;
    //设置按钮文字
    //NSString *lable = [NSString stringWithFormat:@"%.02f%%",progress * 100];
    //NSLog(@"%@  %@", lable, [NSThread currentThread]);
    [self setTitle:[NSString stringWithFormat:@"%.02f%%",progress * 100] forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //bezier曲线
    CGFloat radius = self.frame.size.width * 0.5 - self.lineWidth;
    CGFloat start = -M_PI / 2;
    CGFloat end = M_PI * 2 * self.progress + start;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius:radius startAngle:start endAngle:end clockwise:YES];
    [self.lineColor setStroke];
    path.lineWidth = self.lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    [path stroke];
}


@end
