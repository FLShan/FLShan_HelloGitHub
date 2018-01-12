//
//  WBTagView.m
//  YHTagTest
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WBTagView.h"
#import "WBFlashPointView.h"
#import "WBTagLineView.h"

@interface WBTagView(){//<UIGestureRecognizerDelegate>
    CGPoint _location;
    NSString* _brandStr;
    NSString* _currencyStr;
    NSString* _nationalStr;
    
    UILabel* _brandLabel;
    UILabel* _currencyLabel;
    UILabel* _nationalLabel;
    
   // int _tagType;
    
    CGPoint flashPoint;
    WBFlashPointView* flashView;
    
    WBTagLineView* lineView;
    
    NSTimer* timer;
    CGFloat radius;
    BOOL isShowAnimation;
    BOOL isHideAnimation;
    
    float _lastTransX;
    float _lastTransY;
    
    CGRect containerFrame;
}

@end
@implementation WBTagView

#define DIAGONALWIDTH 16  //斜线的宽度
#define TAGLOCPOINTWIDTH 40 //动画点宽度
#define TEXTVIEWHEIGHT 20 //文本高度
#define TEXTSPACE 10 //文本左右的空白宽度
#define TEXTVSPACE 8 //文本上下的空白宽度
#define FONTSIZE 14

- (instancetype)init
{
    self = [super init];
    if (self) {
        flashPoint = CGPointZero;
        _location = CGPointZero;
       // self.xpPoint = CGPointZero;
        _tagType = 1;
        //self.clipsToBounds = YES;
        //self.userInteractionEnabled = YES;
        _isXpOn = YES;
#warning 修改
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveAction:)];
       // pan.delegate = self;
        [self addGestureRecognizer:pan];
        
        self.isCanMove = NO;
        self.isCanTape = YES;
        //UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onLabelTapTouched:)];
        //singleTap.delegate = self;
        //[self addGestureRecognizer:singleTap];
        
    }
    return self;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#warning 修改
-(void)moveAction:(UIPanGestureRecognizer*)pan{
    if(!self.isCanMove)return;
    CGPoint translatedPoint = [pan translationInView:self];
    if([pan state] == UIGestureRecognizerStateBegan) {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    float dx = translatedPoint.x - _lastTransX;
    float dy = translatedPoint.y - _lastTransY;
    
    if((_location.y + dy - flashPoint.y >=0 && _location.y + dy - flashPoint.y<=containerFrame.size.height-self.frame.size.height) || (_location.y + dy - flashPoint.y <0 && _location.y + dy > _location.y) || (_location.y + dy - flashPoint.y > containerFrame.size.height-self.frame.size.height && _location.y + dy < _location.y)){
        [self setPosition:CGPointMake(_location.x + dx, _location.y + dy)];
        
        _lastTransX = translatedPoint.x;
        _lastTransY = translatedPoint.y;
    }
   // NSLog(@"移动中的%f  %f",_location.x + dx, _location.y + dy);
    self.xpPoint = CGPointMake(_location.x + dx, _location.y + dy);
}

-(void)CreateTagView:(CGPoint)locate brand :(NSString*)brand brand1 :(NSString*)brand1 currency:(NSString*)currency currency1:(NSString*)currency1 national:(NSString*)national national1:(NSString*)national1 tagType:(int)tagType
{
    
    _location = locate;
    self.xpPoint = locate;
//    if (brand.length == 0 ) {
//        self.xpbrand = [NSNull null];
//        
//    }
//    if (brand1.length == 0) {
//        self.xpbrand1 = [NSNull null];
//    }
    //去掉两端的空格
    if (brand.length == 0 && brand1.length == 0) {
        brand = nil;
    }else {
        brand = [brand stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        brand1 = [brand1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.xpbrand = brand;
        self.xpbrand1 = brand1;
        brand = [NSString stringWithFormat:@"%@ %@",brand,brand1];
    }
    _brandStr = brand;
    
    //去掉两端的空格
//    if (currency.length == 0 ) {
//        self.xpcurrency = [NSNull null];
//        
//    }
//    if (currency1.length == 0) {
//        self.xpcurrency1 = [NSNull null];
//    }
    if (currency.length == 0 && currency1.length == 0) {
        currency = nil;
    }else {
    //去掉两端的空格
    currency = [currency stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    currency1 = [currency1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
    self.xpcurrency = currency;
    self.xpcurrency1 = currency1;
    currency = [NSString stringWithFormat:@"%@ %@",currency,currency1];
    }

    _currencyStr = currency;
  
//    if (national.length == 0 ) {
//        self.xpnational = [NSNull null];
//        
//    }
//    if (national1.length == 0) {
//        self.xpnational1 = [NSNull null];
//    }
    if (national.length == 0 && national1.length == 0) {
        national = nil;
    }else {
    //去掉两端的空格
    national = [national stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    national1 = [national1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    self.xpnational = national;
    self.xpnational1 = national1;
    national = [NSString stringWithFormat:@"%@ %@",national,national1];
    }
    _nationalStr = national;
    
    if(tagType<=0 || tagType>4){
        _tagType = 1;
    }else{
        _tagType = tagType;
    }

    [self CreateView];
    
    //先隐藏，以防止播放显示动画时的闪烁
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(flashPoint.x, flashPoint.y) radius:0 startAngle:0 endAngle:M_PI*2.0 clockwise:YES];
    [self setRealCellArea:path];
}

-(void)showViewWithAnimation{
    if(timer!=nil)return;
    radius = 0;
    self.hidden = NO;
    isShowAnimation = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerSchedule) userInfo:nil repeats:YES];
}

-(void)hideViewWithAnimation{
    if(timer!=nil)return;
    radius = self.frame.size.width > self.frame.size.height ? self.frame.size.width : self.frame.size.height;
    isHideAnimation = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerSchedule) userInfo:nil repeats:YES];
}

-(void)timerSchedule{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(flashPoint.x, flashPoint.y) radius:radius startAngle:0 endAngle:M_PI*2.0 clockwise:YES];
    [self setRealCellArea:path];
    //NSLog(@"radius:%f",radius);
    if(isShowAnimation){
        if(radius >self.frame.size.width && radius > self.frame.size.height){
            isShowAnimation = NO;
            [timer invalidate];
            timer = nil;
            self.layer.mask = nil;
            if(self.delegate!=nil){
                if([self.delegate respondsToSelector:@selector(OnTagViewShowFinished:)]){
                    [self.delegate OnTagViewShowFinished:self];
                }
            }
        }else{
            float mw = self.frame.size.width > self.frame.size.height ? self.frame.size.width : self.frame.size.height;
            if(mw - flashPoint.x > flashPoint.x){
                mw = mw - flashPoint.x;
            }else{
                mw = flashPoint.x;
            }
            if (mw <= 0) {
                mw = 1;
            }
            radius += mw/50.0;
        }
    }else
    if(isHideAnimation){
        float mw = self.frame.size.width > self.frame.size.height ? self.frame.size.width : self.frame.size.height;
        if(mw - flashPoint.x > flashPoint.x){
            mw = mw - flashPoint.x;
        }else{
            mw = flashPoint.x;
        }
        radius -= (mw/50.0);
        if(radius <=0){
            isHideAnimation = NO;
            [timer invalidate];
            timer = nil;
            
            if(self.delegate!=nil){
                if([self.delegate respondsToSelector:@selector(OnTagViewHideFinished:)]){
                    [self.delegate OnTagViewHideFinished:self];
                }
            }
        }
    }else{
        [timer invalidate];
        timer = nil;
    }
}

-(void)setRealCellArea:(UIBezierPath *)realCellArea{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.shouldRasterize = YES;//抗锯齿
    maskLayer.path = [realCellArea CGPath];
    maskLayer.masksToBounds = YES;
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.frame = self.bounds;
    
    //CABasicAnimation *chompAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    //chompAnimation.duration = 0.25;
    //chompAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //chompAnimation.repeatCount = HUGE_VALF;
    //chompAnimation.autoreverses = YES;
    //// Animate between the two path values
    //chompAnimation.fromValue = (id)[realCellArea CGPath];
    //chompAnimation.toValue = (id)[realCellArea CGPath];
    //[maskLayer addAnimation:chompAnimation forKey:@"chompAnimation"];
    self.layer.mask = maskLayer;
}

-(void)setAlphaDis:(float)dis{
    //渐变图层
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1] CGColor],(id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor],nil]];
    [gradientLayer setLocations:@[@0,[NSNumber numberWithFloat:dis],[NSNumber numberWithFloat:dis+0.1],@1.1]];
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    self.layer.mask = gradientLayer;
}

-(void)onLabelTapTouched:(UITapGestureRecognizer*)tap{
    
    if(self.delegate!=nil){
        int index = (int)tap.view.tag;
        if (index == 3) {
            CGPoint point  = [tap locationInView:_nationalLabel];
            NSLog(@"%@",NSStringFromCGPoint(point));
            UIFont* font = [UIFont systemFontOfSize:FONTSIZE];
            CGSize strSize1 = [self sizeWithString:self.xpnational font:font withMaxSize:CGSizeMake(3600, 3600)];
            CGFloat w = strSize1.width + TEXTSPACE + 4 ;
            if (_tagType == 1 || _tagType == 2) {
                w = strSize1.width + TEXTSPACE * 1.5 + 4;
            }
            if (point.x < w ) {
                index = 3;
            }else{
                index = 4;
            }
        }
        
        if([self.delegate respondsToSelector:@selector(OnTagViewLableClicked:tagType:)]){
            [self.delegate OnTagViewLableClicked:self tagType:index];
        }
    }
}

-(void)setContainerFrame:(CGRect)frame{//拖动时需要的参数
    containerFrame = frame;
}

-(void)setPosition:(CGPoint)newLocate{
    _location = newLocate;
    
    self.frame = CGRectMake(newLocate.x - flashPoint.x, newLocate.y - flashPoint.y, self.frame.size.width, self.frame.size.height);
    
}


-(void) setText:(NSString*)brand currency:(NSString*)currency national:(NSString*)national{
    if ([brand isEqualToString:@"(null) (null)"]) {
        brand = nil;
    }
    _brandStr = brand;
    _currencyStr = currency;
    if ([national isEqualToString:@"(null) (null)"]) {
        national = nil;
    }
    _nationalStr = national;
    [self CreateView];
}

-(void)setTagType:(int)tagType{
    if(tagType<=0 || tagType>4){
        _tagType = 1;
    }else{
        _tagType = tagType;
    }
    [self CreateView];
}

-(void)changeTagType{
    if(!self.isCanTape) return;
    _tagType++;
    if (_tagType>4) {
        _tagType = 1;
    }
    [self CreateView];
    [self showViewWithAnimation];
}


-(void)CreateView{
    int cnt = 0;
    if (_brandStr!=nil) {
        cnt ++;
        if(_brandLabel==nil){
            _brandLabel = [[UILabel alloc]init];
            _brandLabel.font = [UIFont systemFontOfSize:FONTSIZE];
            _brandLabel.textColor = [UIColor whiteColor];
            _brandLabel.tag = 1;
            _brandLabel.textAlignment = NSTextAlignmentCenter;
            _brandLabel.userInteractionEnabled = YES;
            _brandLabel.shadowColor = [UIColor blackColor];
            _brandLabel.shadowOffset = CGSizeMake(0, 0);
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onLabelTapTouched:)];
            //singleTap.delegate = self;
            [_brandLabel addGestureRecognizer:singleTap];
        }

        _brandLabel.text = _brandStr;
        [self addSubview:_brandLabel];
    }else{
        if(_brandLabel!=nil){
            [_brandLabel removeFromSuperview];
            _brandLabel = nil;
        }
    }
    
    if (_currencyStr!=nil) {
        cnt ++;
        if(_currencyLabel==nil){
            _currencyLabel = [[UILabel alloc]init];
            _currencyLabel.font = [UIFont systemFontOfSize:FONTSIZE];
            _currencyLabel.textColor = [UIColor whiteColor];
            _currencyLabel.tag = 2;
            _currencyLabel.textAlignment = NSTextAlignmentCenter;
            _currencyLabel.userInteractionEnabled = YES;
            _currencyLabel.shadowColor = [UIColor blackColor];
            _currencyLabel.shadowOffset = CGSizeMake(0, 0);
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onLabelTapTouched:)];
            [_currencyLabel addGestureRecognizer:singleTap];
        }
//        _currencyStr = [_currencyStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];

        _currencyLabel.text = _currencyStr;
        [self addSubview:_currencyLabel];
    }else{
        if(_currencyLabel!=nil){
            [_currencyLabel removeFromSuperview];
            _currencyLabel = nil;
        }
    }
    
    if (_nationalStr!=nil) {
        cnt ++;
        if(_nationalLabel==nil){
            _nationalLabel = [[UILabel alloc]init];
            _nationalLabel.font = [UIFont systemFontOfSize:FONTSIZE];
            _nationalLabel.textColor = [UIColor whiteColor];
            _nationalLabel.tag = 3;
            _nationalLabel.textAlignment = NSTextAlignmentCenter;
            _nationalLabel.userInteractionEnabled = YES;
            _nationalLabel.shadowColor = [UIColor blackColor];
            _nationalLabel.shadowOffset = CGSizeMake(0, 0);
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onLabelTapTouched:)];
            [_nationalLabel addGestureRecognizer:singleTap];
        }
//        _nationalStr = [_nationalStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        // NSLog(@"%@",_currencyStr);

        _nationalLabel.text = _nationalStr;
        [self addSubview:_nationalLabel];
    }else{
        if(_nationalLabel!=nil){
            [_nationalLabel removeFromSuperview];
            _nationalLabel = nil;
        }
    }
    
    if(cnt == 0)return ;
    flashPoint = CGPointMake(0, 0);
    
    if(flashView==nil){
        flashView = [[WBFlashPointView alloc]initWithFrame:CGRectMake(0, 0, TAGLOCPOINTWIDTH, TAGLOCPOINTWIDTH)];
#warning 修改代码
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTagType)];
        [flashView addGestureRecognizer:singleTap];
        [self addSubview:flashView];
    }
    
    if(lineView == nil){
        lineView = [[WBTagLineView alloc]init];
        [self addSubview:lineView];
        [self sendSubviewToBack:lineView];//必须放到底层否则会影响Label的点击效果
    }
    
    if(cnt==1){
        [self createOneLabel];
    }else if(cnt==2){
        [self createTwoLabel];
    }else{ //cnt==3
        [self createThreeLabel];
    }
    
    lineView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 5);
    [lineView setNeedsDisplay];
    flashPoint = flashView.center;
    
    [self bringSubviewToFront:flashView];
    
    [self setPosition:_location];
    
    //self.backgroundColor = [UIColor greenColor];
}

-(void)createOneLabel{
    UILabel* textView = _brandLabel;
    NSString* text = _brandStr;
    if(textView==nil){
        textView = _currencyLabel;
        text = _currencyStr;
    }
    if(textView==nil){
        textView = _nationalLabel;
        text = _nationalStr;
    }
    UIFont* font = [UIFont systemFontOfSize:FONTSIZE];
    
    CGSize strSize = [self sizeWithString:text font:font withMaxSize:CGSizeMake(3600, 3600)];
    int strWidth = (int)(strSize.width+0.5);
    int strHeight = (int)(strSize.height+0.5) + TEXTVSPACE;
    
    
    int labelWidth = (int)(strWidth + TEXTSPACE*3 + 0.5);
    int frameWidth = labelWidth + (int)(TAGLOCPOINTWIDTH/2 + 0.5);
    int frameHeight = TAGLOCPOINTWIDTH;
    
    
    if(_tagType==1){
        if(frameHeight/2.0 < strHeight){
            frameHeight = (int)(TAGLOCPOINTWIDTH/2.0 + strHeight + 0.5);
            flashView.center = CGPointMake(labelWidth, strHeight);
            textView.frame = CGRectMake(0, 0, labelWidth, strHeight);
        }else{
            flashView.center = CGPointMake(labelWidth, TAGLOCPOINTWIDTH/2.0);
            textView.frame = CGRectMake(0, TAGLOCPOINTWIDTH/2.0 - strHeight, labelWidth, strHeight);
        }
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, flashView.center.y)];
        [path addLineToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [lineView setPath:path];
    }else if(_tagType==2){
        if(frameHeight/2.0 < strHeight){
            frameHeight = (int)(TAGLOCPOINTWIDTH/2.0 + strHeight + 0.5);            flashView.center = CGPointMake(TAGLOCPOINTWIDTH/2.0, strHeight);
            textView.frame = CGRectMake(TAGLOCPOINTWIDTH/2.0, 0, labelWidth, strHeight);
        }else{
            flashView.center = CGPointMake(TAGLOCPOINTWIDTH/2.0, TAGLOCPOINTWIDTH/2.0);
            textView.frame = CGRectMake(TAGLOCPOINTWIDTH/2.0, TAGLOCPOINTWIDTH/2.0 - strHeight, labelWidth, strHeight);
        }
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [path addLineToPoint:CGPointMake(frameWidth, flashView.center.y)];
        [lineView setPath:path];
    }else if(_tagType==3){
        labelWidth = (int)(strWidth + TEXTSPACE*2 + 0.5);
        frameWidth = labelWidth + (int)(TAGLOCPOINTWIDTH/2 + DIAGONALWIDTH + 0.5);
        frameHeight = TAGLOCPOINTWIDTH;
        
        if(frameHeight/2.0 < DIAGONALWIDTH){
            frameHeight = (int)(TAGLOCPOINTWIDTH/2.0 + DIAGONALWIDTH + 0.5);
        }
        
        flashView.center = CGPointMake(labelWidth + DIAGONALWIDTH, TAGLOCPOINTWIDTH/2.0);
        
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        textView.frame = CGRectMake(0, frameHeight - strHeight, labelWidth, strHeight);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, frameHeight-1)];
        [path addLineToPoint:CGPointMake(labelWidth, frameHeight-1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [lineView setPath:path];
    }else if(_tagType==4){
        labelWidth = (int)(strWidth + TEXTSPACE*2 + 0.5);
        frameWidth = labelWidth + (int)(TAGLOCPOINTWIDTH/2 + DIAGONALWIDTH + 0.5);
        frameHeight = TAGLOCPOINTWIDTH;
        
        if(frameHeight/2.0 < DIAGONALWIDTH){
            frameHeight = (int)(TAGLOCPOINTWIDTH/2.0 + strHeight + 0.5);
            frameHeight = (int)(TAGLOCPOINTWIDTH/2.0 + DIAGONALWIDTH + 0.5);
        }
        flashView.center = CGPointMake(TAGLOCPOINTWIDTH/2.0, TAGLOCPOINTWIDTH/2.0);
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        textView.frame = CGRectMake(TAGLOCPOINTWIDTH/2.0 + DIAGONALWIDTH, frameHeight - strHeight, labelWidth, strHeight);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [path addLineToPoint:CGPointMake(textView.frame.origin.x, frameHeight-1)];
        [path addLineToPoint:CGPointMake(frameWidth, frameHeight-1)];
        [lineView setPath:path];
    }
}

-(void)createTwoLabel{
    
    UILabel* textView1 = _brandLabel;
    NSString* str1 = _brandStr;
    UILabel* textView2 = _currencyLabel;
    NSString* str2 = _currencyStr;
    if(textView1==nil){
        textView1 = _nationalLabel;
        str1 = _nationalStr;
    }else{
        if(textView2==nil){
            textView2 = _nationalLabel;
            str2 = _nationalStr;
        }
    }
    
    UIFont* font = [UIFont systemFontOfSize:FONTSIZE];
    CGSize strSize1 = [self sizeWithString:str1 font:font withMaxSize:CGSizeMake(3600, 3600)];
    CGSize strSize2 = [self sizeWithString:str2 font:font withMaxSize:CGSizeMake(3600, 3600)];
    
    int strWidth1 = (int)(strSize1.width+0.5);
    int strHeight1 = (int)(strSize1.height+0.5) + TEXTVSPACE;
    
    int strWidth2 = (int)(strSize2.width+0.5);
    int strHeight2 = (int)(strSize2.height+0.5) + TEXTVSPACE;
    
    if(strWidth1 < TAGLOCPOINTWIDTH/2.0 && strWidth2 < TAGLOCPOINTWIDTH/2.0){
        if(strWidth1 > strWidth2){
            strWidth1 = TAGLOCPOINTWIDTH/2.0 + 2;
        }else{
            strWidth2 = TAGLOCPOINTWIDTH/2.0 + 2;
        }
    }
    
    if(_tagType==1){
        int labelWidth1 = (int)(strWidth1 + TEXTSPACE*3 + 0.5);
        int labelWidth2 = (int)(strWidth2 + TEXTSPACE*3 + 0.5);
        
        int maxStrWidth = labelWidth1 > labelWidth2 ? labelWidth1 : labelWidth2;
        
        if (maxStrWidth==labelWidth1) {
            textView1.frame = CGRectMake(0.5, 1.5, labelWidth1, strHeight1);
        }else{
            textView1.frame = CGRectMake(maxStrWidth - labelWidth1+0.5, 1.5, labelWidth1, strHeight1);
        }
        
        int frameWidth = maxStrWidth + (int)(TAGLOCPOINTWIDTH/2.0 + 0.5);
        int frameHeight = strHeight1 + 2*DIAGONALWIDTH;
        
        if (maxStrWidth==labelWidth2) {
            textView2.frame = CGRectMake(0.5, frameHeight - strHeight2+0.5, labelWidth2, strHeight2);
        }else{
            textView2.frame = CGRectMake(maxStrWidth - labelWidth2+0.5, frameHeight - strHeight2+0.5, labelWidth2, strHeight2);
        }
        
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        flashView.center = CGPointMake(maxStrWidth, strHeight1+DIAGONALWIDTH);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(maxStrWidth - labelWidth1, strHeight1)];
        [path addLineToPoint:CGPointMake(maxStrWidth, strHeight1)];
        [path addLineToPoint:CGPointMake(maxStrWidth, frameHeight-1)];
        [path addLineToPoint:CGPointMake(maxStrWidth - labelWidth2, frameHeight-1)];
        [lineView setPath:path];
    }else if(_tagType==2){
        int labelWidth1 = (int)(strWidth1 + TEXTSPACE*3 + 0.5);
        int labelWidth2 = (int)(strWidth2 + TEXTSPACE*3 + 0.5);
        
        int maxStrWidth = labelWidth1 > labelWidth2 ? labelWidth1 : labelWidth2;
        
        
        int frameWidth = maxStrWidth + (int)(TAGLOCPOINTWIDTH/2.0 + 0.5);
        int frameHeight = strHeight1 + 2*DIAGONALWIDTH;
        
        textView1.frame = CGRectMake(TAGLOCPOINTWIDTH/2.0 - 0.5, 1, labelWidth1, strHeight1);
        
        textView2.frame = CGRectMake(TAGLOCPOINTWIDTH/2.0 -0.5, frameHeight - strHeight2 + 0.5, labelWidth2, strHeight2);
        
        
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        flashView.center = CGPointMake(TAGLOCPOINTWIDTH/2.0, strHeight1+DIAGONALWIDTH);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(frameWidth - (maxStrWidth - labelWidth1), strHeight1)];
        [path addLineToPoint:CGPointMake(TAGLOCPOINTWIDTH/2.0, strHeight1)];
        [path addLineToPoint:CGPointMake(TAGLOCPOINTWIDTH/2.0, frameHeight-1)];
        [path addLineToPoint:CGPointMake(TAGLOCPOINTWIDTH/2.0 + labelWidth2, frameHeight-1)];
        [lineView setPath:path];
    }else if(_tagType==3){
        int labelWidth1 = (int)(strWidth1 + TEXTSPACE*2 + 0.5);
        int labelWidth2 = (int)(strWidth2 + TEXTSPACE*2 + 0.5);
        
        int maxStrWidth = labelWidth1 > labelWidth2 ? labelWidth1 : labelWidth2;
        
        if (maxStrWidth==labelWidth1) {
            textView1.frame = CGRectMake(0, 0, labelWidth1, strHeight1);
        }else{
            textView1.frame = CGRectMake(maxStrWidth - labelWidth1, 0, labelWidth1, strHeight1);
        }
        
        int frameHeight = strHeight1 + 2*DIAGONALWIDTH;
        if (maxStrWidth==labelWidth2) {
            textView2.frame = CGRectMake(0, frameHeight - strHeight2, labelWidth2, strHeight2);
        }else{
            textView2.frame = CGRectMake(maxStrWidth - labelWidth2, frameHeight - strHeight2, labelWidth2, strHeight2);
        }
        
        
        int frameWidth = maxStrWidth + (int)(TAGLOCPOINTWIDTH/2.0 + 0.5) + DIAGONALWIDTH;
        
        
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        flashView.center = CGPointMake(maxStrWidth+DIAGONALWIDTH, strHeight1+DIAGONALWIDTH);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(maxStrWidth - labelWidth1, strHeight1)];
        [path addLineToPoint:CGPointMake(maxStrWidth, strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [path addLineToPoint:CGPointMake(maxStrWidth, frameHeight-1)];
        [path addLineToPoint:CGPointMake(maxStrWidth - labelWidth2, frameHeight-1)];
        [lineView setPath:path];
    }else if(_tagType==4){
        int labelWidth1 = (int)(strWidth1 + TEXTSPACE*2 + 0.5);
        int labelWidth2 = (int)(strWidth2 + TEXTSPACE*2 + 0.5);
        
        int maxStrWidth = labelWidth1 > labelWidth2 ? labelWidth1 : labelWidth2;
        
        textView1.frame = CGRectMake(TAGLOCPOINTWIDTH/2 + DIAGONALWIDTH, 0, labelWidth1, strHeight1);
        
        int frameWidth = maxStrWidth + (int)(TAGLOCPOINTWIDTH/2.0 + 0.5) + DIAGONALWIDTH;
        int frameHeight = strHeight1 + 2*DIAGONALWIDTH;
        
        textView2.frame = CGRectMake(TAGLOCPOINTWIDTH/2 + DIAGONALWIDTH, frameHeight - strHeight2, labelWidth2, strHeight2);
        
        
        
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        flashView.center = CGPointMake(TAGLOCPOINTWIDTH/2.0, strHeight1+DIAGONALWIDTH);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(frameWidth - (maxStrWidth - labelWidth1), strHeight1)];
        [path addLineToPoint:CGPointMake(TAGLOCPOINTWIDTH/2.0 + DIAGONALWIDTH, strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [path addLineToPoint:CGPointMake(TAGLOCPOINTWIDTH/2.0 + DIAGONALWIDTH, frameHeight-1)];
        [path addLineToPoint:CGPointMake(TAGLOCPOINTWIDTH/2.0 + DIAGONALWIDTH + labelWidth2, frameHeight-1)];
        [lineView setPath:path];
    }
    
}

-(void)createThreeLabel{
    
    int diagonalWidth = DIAGONALWIDTH;
    if(_tagType==1 || _tagType==2){
        diagonalWidth += 14;
    }
    
    UILabel* textView1 = _brandLabel;
    UILabel* textView2 = _currencyLabel;
    UILabel* textView3 = _nationalLabel;
    
    UIFont* font = [UIFont systemFontOfSize:FONTSIZE];
    CGSize strSize1 = [self sizeWithString:_brandStr font:font withMaxSize:CGSizeMake(3600, 3600)];
    CGSize strSize2 = [self sizeWithString:_currencyStr font:font withMaxSize:CGSizeMake(3600, 3600)];
    CGSize strSize3 = [self sizeWithString:_nationalStr font:font withMaxSize:CGSizeMake(3600, 3600)];
    
    int strWidth1 = (int)(strSize1.width+0.5);
    int strHeight1 = (int)(strSize1.height+0.5) + TEXTVSPACE;
    
    int strWidth2 = (int)(strSize2.width+0.5);
    int strHeight2 = (int)(strSize2.height+0.5) + TEXTVSPACE;
    
    int strWidth3 = (int)(strSize3.width+0.5);
    int strHeight3 = (int)(strSize3.height+0.5) + TEXTVSPACE;
    
    if(strWidth1 < TAGLOCPOINTWIDTH/2.0 && strWidth2 < TAGLOCPOINTWIDTH/2.0 && strWidth3 < TAGLOCPOINTWIDTH/2.0){
        if(strWidth1 >= strWidth2 && strWidth1 >= strWidth3){
            strWidth1 = TAGLOCPOINTWIDTH/2.0 + 2;
        }else if(strWidth2 >= strWidth1 && strWidth2 >= strWidth1){
            strWidth2 = TAGLOCPOINTWIDTH/2.0 + 2;
        }else{
            strWidth3 = TAGLOCPOINTWIDTH/2.0 + 2;
        }
    }
    
    
    if(_tagType==1){
        int labelWidth1 = (int)(strWidth1 + TEXTSPACE*3 + 0.5);
        int labelWidth2 = (int)(strWidth2 + TEXTSPACE*3 + 0.5);
        int labelWidth3 = (int)(strWidth3 + TEXTSPACE*3 + 0.5);
        int maxStrWidth = labelWidth1 > labelWidth3 ? labelWidth1 : labelWidth3;
        
        if(maxStrWidth < labelWidth2){
            maxStrWidth = labelWidth2;
        }
        
        if (maxStrWidth==labelWidth1) {
            textView1.frame = CGRectMake(0, 0, labelWidth1, strHeight1);
        }else{
            textView1.frame = CGRectMake(maxStrWidth - labelWidth1, 0, labelWidth1, strHeight1);
        }
        
        if (maxStrWidth==labelWidth2) {
            textView2.frame = CGRectMake(0, diagonalWidth + strHeight1 - strHeight2, labelWidth2, strHeight2);
        }else{
            textView2.frame = CGRectMake(maxStrWidth - labelWidth2, diagonalWidth + strHeight1 - strHeight2, labelWidth2, strHeight2);
        }
        
        int frameWidth = maxStrWidth + (int)(TAGLOCPOINTWIDTH/2.0 + 0.5);
        int frameHeight = strHeight1 + 2*diagonalWidth;
        
        if (maxStrWidth==labelWidth3) {
            textView3.frame = CGRectMake(0, frameHeight - strHeight2, labelWidth3, strHeight3);
        }else{
            textView3.frame = CGRectMake(maxStrWidth - labelWidth3, frameHeight - strHeight2, labelWidth3, strHeight3);
        }
    
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        flashView.center = CGPointMake(maxStrWidth, strHeight1+diagonalWidth);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(maxStrWidth - labelWidth1, strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, frameHeight-1)];
        [path addLineToPoint:CGPointMake(maxStrWidth - labelWidth3, frameHeight-1)];
        [path moveToPoint:CGPointMake(maxStrWidth - labelWidth2, flashView.center.y)];
        [path addLineToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [lineView setPath:path];
    }else if(_tagType==2){
        int labelWidth1 = (int)(strWidth1 + TEXTSPACE*3 + 0.5);
        int labelWidth2 = (int)(strWidth2 + TEXTSPACE*3 + 0.5);
        int labelWidth3 = (int)(strWidth3 + TEXTSPACE*3 + 0.5);
        
        int maxStrWidth = labelWidth1 > labelWidth3 ? labelWidth1 : labelWidth3;
        
        if(maxStrWidth < labelWidth2){
            maxStrWidth = labelWidth2;
        }
        
        int frameWidth = maxStrWidth + (int)(TAGLOCPOINTWIDTH/2.0 + 0.5);
        int frameHeight = strHeight1 + 2*diagonalWidth;
        
        textView1.frame = CGRectMake(TAGLOCPOINTWIDTH/2.0, 0, labelWidth1, strHeight1);
        textView2.frame = CGRectMake(TAGLOCPOINTWIDTH/2.0, diagonalWidth + strHeight1 - strHeight2, labelWidth2, strHeight2);
        textView3.frame = CGRectMake(TAGLOCPOINTWIDTH/2.0, frameHeight - strHeight3, labelWidth3, strHeight3);
        
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        flashView.center = CGPointMake(TAGLOCPOINTWIDTH/2.0, strHeight1+diagonalWidth);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(frameWidth - (maxStrWidth - labelWidth1), strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, frameHeight-1)];
        [path addLineToPoint:CGPointMake(frameWidth - (maxStrWidth - labelWidth3), frameHeight-1)];
        [path moveToPoint:CGPointMake(frameWidth - (maxStrWidth - labelWidth2), flashView.center.y)];
        [path addLineToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [lineView setPath:path];
    }else if(_tagType==3){
        int labelWidth1 = (int)(strWidth1 + TEXTSPACE*2 + 0.5);
        int labelWidth2 = (int)(strWidth2 + TEXTSPACE*2 + 0.5);
        int labelWidth3 = (int)(strWidth3 + TEXTSPACE*2 + 0.5);
        
        int maxStrWidth = labelWidth1 > labelWidth3 ? labelWidth1 : labelWidth3;
        
        
        if (maxStrWidth==labelWidth1) {
            textView1.frame = CGRectMake(0, 0, labelWidth1, strHeight1);
        }else{
            textView1.frame = CGRectMake(maxStrWidth - labelWidth1, 0, labelWidth1, strHeight1);
        }
        
        
        int frameWidth = maxStrWidth + labelWidth2 + diagonalWidth*2;
        int frameHeight = strHeight1 + 2*diagonalWidth;
        textView2.frame = CGRectMake(maxStrWidth + 2*diagonalWidth, frameHeight - strHeight2, labelWidth2, strHeight2);
    
        
        if (maxStrWidth==labelWidth3) {
            textView3.frame = CGRectMake(0, frameHeight - strHeight2, labelWidth3, strHeight3);
        }else{
            textView3.frame = CGRectMake(maxStrWidth - labelWidth3, frameHeight - strHeight2, labelWidth3, strHeight3);
        }
        
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        flashView.center = CGPointMake(maxStrWidth+diagonalWidth, strHeight1+diagonalWidth);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(maxStrWidth - labelWidth1, strHeight1)];
        [path addLineToPoint:CGPointMake(maxStrWidth, strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [path addLineToPoint:CGPointMake(maxStrWidth, frameHeight-1)];
        [path addLineToPoint:CGPointMake(maxStrWidth - labelWidth3, frameHeight-1)];
        [path moveToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [path addLineToPoint:CGPointMake(flashView.center.x + diagonalWidth, frameHeight-1)];
        [path addLineToPoint:CGPointMake(frameWidth, frameHeight-1)];
        [lineView setPath:path];
    }else if(_tagType==4){
        int labelWidth1 = (int)(strWidth1 + TEXTSPACE*2 + 0.5);
        int labelWidth2 = (int)(strWidth2 + TEXTSPACE*2 + 0.5);
        int labelWidth3 = (int)(strWidth3 + TEXTSPACE*2 + 0.5);
        
        int maxStrWidth = labelWidth1 > labelWidth3 ? labelWidth1 : labelWidth3;
        
    
        textView1.frame = CGRectMake(labelWidth2 + 2*diagonalWidth, 0, labelWidth1, strHeight1);
        
        
        int frameWidth = maxStrWidth + labelWidth2 + diagonalWidth*2;
        int frameHeight = strHeight1 + 2*diagonalWidth;
        textView2.frame = CGRectMake(0, frameHeight - strHeight2, labelWidth2, strHeight2);
        
        
        textView3.frame = CGRectMake(labelWidth2 + 2*diagonalWidth, frameHeight - strHeight2, labelWidth3, strHeight3);
        
        self.frame = CGRectMake(0, 0, frameWidth, frameHeight);
        
        flashView.center = CGPointMake(labelWidth2+diagonalWidth, strHeight1+diagonalWidth);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(frameWidth - (maxStrWidth - labelWidth1), strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x + diagonalWidth, strHeight1)];
        [path addLineToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [path addLineToPoint:CGPointMake(flashView.center.x + diagonalWidth, frameHeight-1)];
        [path addLineToPoint:CGPointMake(frameWidth - (maxStrWidth - labelWidth3), frameHeight-1)];
        [path moveToPoint:CGPointMake(flashView.center.x, flashView.center.y)];
        [path addLineToPoint:CGPointMake(labelWidth2, frameHeight-1)];
        [path addLineToPoint:CGPointMake(0, frameHeight-1)];
        [lineView setPath:path];
    }
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font withMaxSize:(CGSize)maxSize
{
    CGRect rect = [string boundingRectWithSize:maxSize//限制最大的宽度和高度 CGSizeMake(3600, 3600)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传入的字体字典
                                       context:nil];
    
    return rect.size;
}


@end
