//
//  WBFlashPointView.m
//  YHTagTest
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WBFlashPointView.h"
@interface WBFlashPointView(){
    UIImageView* imgView1;
    UIImageView* imgView2;
}
@end

@implementation WBFlashPointView
#define FLASHPOINTSRCWIDTH 16

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FLASHPOINTSRCWIDTH, FLASHPOINTSRCWIDTH)];
    imgView1.image = [UIImage imageNamed:@"tag_loc_pos"];
    imgView1.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    [self addSubview:imgView1];
    
    imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FLASHPOINTSRCWIDTH, FLASHPOINTSRCWIDTH)];
    imgView2.image = [UIImage imageNamed:@"tag_loc_pos2"];
    imgView2.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    [self addSubview:imgView2];
    
    [self playAnimation];
    
}

-(void)playAnimation{
    //缩放动画
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];//CATransform3DIdentity
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 1.0)];
    scaleAnim.removedOnCompletion = YES;
    
    //透明动画
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];//不是alpha
    opacityAnim.fromValue = [NSNumber numberWithFloat:0.7];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnim.removedOnCompletion = YES;
    
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:scaleAnim, opacityAnim, nil];
    animGroup.duration = 1.0;
    animGroup.repeatCount = MAXFLOAT;
    animGroup.autoreverses = NO;
    
    [imgView2.layer addAnimation:animGroup forKey:nil];
}

@end
