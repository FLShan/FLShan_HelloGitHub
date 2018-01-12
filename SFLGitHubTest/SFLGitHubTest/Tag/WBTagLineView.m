//
//  WBTagDiagonalLineView.m
//  YHTagTest
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WBTagLineView.h"

@implementation WBTagLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;//YES时背景为黑色
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //[super drawRect:rect];
    // Drawing code
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextClearRect(context, rect);
    //    [[UIColor whiteColor] setStroke];
    //    CGContextSetLineWidth(context, 1.0f);
    //    if(_lineType==0){
    //        CGContextMoveToPoint(context, 0, 0);
    //        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    //    }else if(_lineType==1){
    //        CGContextMoveToPoint(context, rect.size.width, 0);
    //        CGContextAddLineToPoint(context, 0, rect.size.height);
    //    }else{//_lineType==2
    //        CGContextMoveToPoint(context, rect.size.width/2.0, 0);
    //        CGContextAddLineToPoint(context, rect.size.width/2.0, rect.size.height);
    //    }
    //    //CGContextClosePath(context);
    //    CGContextDrawPath(context, kCGPathStroke);
    
    //    if(self.pointsArray!=nil && self.pointsArray.count >0){
    //        CGContextRef context = UIGraphicsGetCurrentContext();
    //        UIBezierPath *path = [UIBezierPath bezierPath];
    //        CGPoint spoint = CGPointFromString([self.pointsArray objectAtIndex:0]);
    //        NSLog(@"%@",[self.pointsArray objectAtIndex:0]);
    //        [path moveToPoint:spoint];
    //        for (int i=1; i < self.pointsArray.count; i++) {
    //            CGPoint point = CGPointFromString([self.pointsArray objectAtIndex:i]);
    //            [path addLineToPoint:point];
    //            NSLog(@"%@",[self.pointsArray objectAtIndex:i]);
    //        }
    //        //[path closePath];
    //        [path setLineWidth:1.0];//0.5
    //        path.lineCapStyle = kCGLineCapRound; //线条拐角
    //        path.lineJoinStyle = kCGLineCapRound; //终点处理
    //        [[UIColor whiteColor] setStroke];
    //        [path stroke];
    //        //[[UIColor whiteColor] setFill];
    //        //[path fill];
    //        CGContextStrokePath(context);
    //    }
    
    if(self.path!=nil && !self.path.isEmpty){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShadow(context, CGSizeMake(0, 0), 5);
        UIBezierPath *path = self.path;
        //[path closePath];
        [path setLineWidth:1.0];//0.5
        path.lineCapStyle = kCGLineCapRound; //线条拐角
        path.lineJoinStyle = kCGLineCapRound; //终点处理
        [[UIColor whiteColor] setStroke];
        [path stroke];
        CGContextStrokePath(context);
    }
    
}


@end
