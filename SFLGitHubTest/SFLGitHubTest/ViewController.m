//
//  ViewController.m
//  SFLGitHubTest
//
//  Created by 单方良 on 16/11/22.
//  Copyright © 2016年 FLShan. All rights reserved.
//

#import "ViewController.h"
#import "WBTagView.h"
#import "SFLFlowerView.h"
@interface ViewController ()<WBTagViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    WBTagView *tagView          = [[WBTagView alloc]init];
    tagView.delegate            = self;
    tagView.isCanMove           = false;
    tagView.isCanTape           = YES;
    CGFloat x                   = 200;
    CGFloat y                   = 200;
   
    CGPoint point               = CGPointMake(x, y);
    
    [tagView CreateTagView:point brand:@"woqu" brand1:@"woqu" currency:@"woqu" currency1:@"woqu" national:@"woqu" national1:@"woqu" tagType:2];
    [self.view addSubview:tagView];
    [tagView showViewWithAnimation];
    
    SFLFlowerView *flowerView = [[SFLFlowerView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    [self.view addSubview:flowerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
