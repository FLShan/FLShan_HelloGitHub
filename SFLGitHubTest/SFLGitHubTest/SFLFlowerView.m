//
//  SFLFlowerView.m
//  SFLGitHubTest
//
//  Created by 单方良 on 16/12/2.
//  Copyright © 2016年 FLShan. All rights reserved.
//

#import "SFLFlowerView.h"



@implementation SFLFlowerView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    CGSize size = self.bounds.size;
//    
//    CGFloat margin = 10;
//    
//    CGFloat radius = rintf(MIN(size.height - margin, size.width - margin) / 4);
//    
//    CGFloat xOffset, yOffset;
//    
//    CGFloat offset = rintf((size.height - size.width) / 2);
//    
//    if (offset > 0) {
//        xOffset = rintf(margin/2);
//        yOffset = offset;
//    }else{
//        xOffset = -offset;
//        yOffset = rintf(margin/2);
//    }
//    
//    [[UIColor redColor] setFill];
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    
//    [path addArcWithCenter:CGPointMake(radius * 2 + xOffset, radius + yOffset) radius:radius startAngle:-M_PI endAngle:0 clockwise:YES];
//    
//    [path addArcWithCenter:CGPointMake(radius * 3 + xOffset, radius * 2 + yOffset) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
//    
//    [path addArcWithCenter:CGPointMake(radius * 2 + xOffset, radius * 3 + yOffset) radius:radius startAngle:0 endAngle:M_PI clockwise:YES];
//    
//    [path addArcWithCenter:CGPointMake(radius + xOffset, radius * 2 +yOffset) radius:radius startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:YES];
//    
//    [path closePath];
//    
//    [path fill];
//    
//    
//    
//}
- (void)drawRect:(CGRect)rect {
    CALayer
    // Drawing code
    CGSize size = self.bounds.size;
    
    CGFloat margin = 10;
    
    CGFloat radius = rintf(MIN(size.height - margin, size.width - margin) / 4);
    
    CGFloat xOffset, yOffset;
    
    CGFloat offset = rintf((size.height - size.width) / 2);
    
    if (offset > 0) {
        xOffset = rintf(margin/2);
        yOffset = offset;
    }else{
        xOffset = -offset;
        yOffset = rintf(margin/2);
    }
    
    [[UIColor redColor] setFill];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(radius * 2 + xOffset, radius + yOffset) radius:radius startAngle:-M_PI endAngle:0 clockwise:YES];
    
    [path addArcWithCenter:CGPointMake(radius * 3 + xOffset, radius * 2 + yOffset) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    
    [path addArcWithCenter:CGPointMake(radius * 2 + xOffset, radius * 3 + yOffset) radius:radius startAngle:0 endAngle:M_PI clockwise:YES];
    
    [path addArcWithCenter:CGPointMake(radius + xOffset, radius * 2 +yOffset) radius:radius startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:YES];
    
    [path closePath];
    
    [path fill];
    
    
    
}

@end
