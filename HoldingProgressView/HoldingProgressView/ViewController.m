//
//  ViewController.m
//  HoldingProgressView
//
//  Created by coolerting on 2018/10/11.
//  Copyright © 2018年 coolerting. All rights reserved.
//

#import "ViewController.h"
#import "StripeProgressBar.h"
#import "Masonry.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface ViewController ()
@property (nonatomic, weak) StripeProgressBar *stripe;
@property (nonatomic, weak) UIView *holdingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self creatHoldingView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(resetView)];
}

- (void)creatHoldingView
{
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    UIView *holdingView = [[UIView alloc]init];
    holdingView.layer.backgroundColor = UIColor.whiteColor.CGColor;
    holdingView.layer.cornerRadius = 8;
    holdingView.layer.masksToBounds = YES;
    [self.view addSubview:holdingView];
    _holdingView = holdingView;
    [holdingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(300);
        make.center.mas_equalTo(CGPointZero);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"订单信息";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.backgroundColor = RGBA(0, 191, 255, 1);
    [holdingView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    UIView *infoView = [[UIView alloc]init];
    [holdingView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.bottom.mas_equalTo(-100);
    }];
    
    NSArray *array = @[@"G104 上海-北京",@"2018-10-10 周三 06：30发车",@"二等座",@"乘客：孙悟空"];
    NSMutableArray *labelArray = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        UILabel *infoLabel = [[UILabel alloc]init];
        infoLabel.font = [UIFont systemFontOfSize:15];
        infoLabel.text = array[i];
        [infoView addSubview:infoLabel];
        [labelArray addObject:infoLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc]init];
        arrowImageView.image = [UIImage imageNamed:@"icon_train_complete"];
        arrowImageView.alpha = 0;
        [infoView addSubview:arrowImageView];
        [imageArray addObject:arrowImageView];
    }
    [labelArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [labelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
    }];
    
    [imageArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [imageArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:15 leadSpacing:10 tailSpacing:10];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = RGBA(230, 230, 230, 1);
    [infoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1 / UIScreen.mainScreen.scale);
    }];
    
    [self.view layoutIfNeeded];
    
    StripeProgressBar *stripe = [[StripeProgressBar alloc]initWithFrame:CGRectMake(10, infoView.frame.origin.y + infoView.frame.size.height + 25, holdingView.frame.size.width - 20, 50)];
    stripe.imageBlock = ^(NSInteger index) {
        UIImageView *arrowImageView = imageArray[index];
        [UIView animateWithDuration:0.2 animations:^{
            arrowImageView.alpha = 1;
        }];
    };
    _stripe = stripe;
    [holdingView addSubview:stripe];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_stripe setProgress:1 duration:15 completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.holdingView removeFromSuperview];
        });
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self finish];
}

- (void)finish
{
    [_stripe setProgress:1 duration:0.5 completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.holdingView removeFromSuperview];
        });
    }];
}

- (void)resetView
{
    [self creatHoldingView];
    [_stripe setProgress:1 duration:15 completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.holdingView removeFromSuperview];
        });
    }];
}

@end
