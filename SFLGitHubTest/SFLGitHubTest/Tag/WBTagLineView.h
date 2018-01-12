//
//  WBTagDiagonalLineView.h
//  YHTagTest
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBTagLineView : UIView

@property (nonatomic,assign)int lineType;

//@property (nonatomic,retain)NSArray * pointsArray;
@property (nonatomic,retain)UIBezierPath *path;

@end
