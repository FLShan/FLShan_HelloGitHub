//
//  WBTagView.h
//  YHTagTest
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBTagView;

@protocol WBTagViewDelegate <NSObject>

-(void)OnTagViewLableClicked:(WBTagView*)view tagType:(int)type;//1:Brand   2:Currency   3:National 4:商店
-(void)OnTagViewShowFinished:(WBTagView*)view;
-(void)OnTagViewHideFinished:(WBTagView*)view;

@end

@interface WBTagView : UIView

@property (nonatomic,assign) id <WBTagViewDelegate> delegate;
@property (nonatomic,assign) BOOL isCanMove;//是否能够被拖动,默认为false

@property (nonatomic,assign) BOOL isCanTape;//能否改变样式,默认为yes;


@property (nonatomic,copy)NSString * xpbrand;
@property (nonatomic,copy)NSString * xpbrand1;
@property (nonatomic,copy)NSString * xpcurrency;
@property (nonatomic,copy)NSString * xpcurrency1;
@property (nonatomic,copy)NSString * xpnational;
@property (nonatomic,copy)NSString * xpnational1;

//@property (nonatomic, copy)NSString *rmbCurrency;
//@property (nonatomic, assign)int *leftValue;
//@property (nonatomic, copy);

@property (nonatomic, assign)CGPoint xpPoint;
@property (nonatomic, assign)int tagType;
@property (nonatomic, assign)BOOL isXpOn;

-(void)CreateTagView:(CGPoint)locate brand :(NSString*)brand brand1 :(NSString*)brand1 currency:(NSString*)currency currency1:(NSString*)currency1 national:(NSString*)national national1:(NSString*)national1 tagType:(int)tagType;
-(void)setText:(NSString*)brand currency:(NSString*)currency national:(NSString*)national;
-(void)setTagType:(int)tagType;
-(void)setContainerFrame:(CGRect)frame;
-(void)changeTagType;
-(void)setPosition:(CGPoint)newLocate;
-(void)showViewWithAnimation;
-(void)hideViewWithAnimation;
@end
