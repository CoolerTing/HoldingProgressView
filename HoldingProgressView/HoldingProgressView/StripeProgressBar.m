//
//  StripeProgressBar.m
//  EFSearch
//
//  Created by coolerting on 2018/10/9.
//  Copyright © 2018年 coolerting. All rights reserved.
//

#import "StripeProgressBar.h"
#import "Masonry.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface StripeProgressBar()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *backProgressLabel;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat progress;
@end
static CGFloat barWidth;
@implementation StripeProgressBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        barWidth = frame.size.width;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height / 2;
        CGFloat width = frame.size.width / 10;
        self.layer.backgroundColor = RGBA(245, 245, 245, 1).CGColor;
        
        UILabel *backNoticeLabel = [[UILabel alloc]init];
        backNoticeLabel.text = @"正在为您占座中...";
        backNoticeLabel.textColor = RGBA(0, 190, 255, 1);
        backNoticeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:backNoticeLabel];
        [backNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
        }];
        
        UILabel *backProgressLabel = [[UILabel alloc]init];
        backProgressLabel.text = @"0%";
        backProgressLabel.textAlignment = NSTextAlignmentCenter;
        backProgressLabel.textColor = RGBA(0, 190, 255, 1);
        backProgressLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:backProgressLabel];
        _backProgressLabel = backProgressLabel;
        [backProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(barWidth - 40);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(40);
        }];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        backView.layer.backgroundColor = RGBA(150, 220, 255, 1).CGColor;
        backView.layer.cornerRadius = frame.size.height / 2;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        _backView = backView;
        
        CALayer *stripeLayer = [CALayer layer];
        stripeLayer.frame = CGRectMake(-2 * width, 0, 12 * width, frame.size.height);
        [backView.layer addSublayer:stripeLayer];
        
        for (int i = 0; i < 12; i++) {
            CAShapeLayer *stripe = [CAShapeLayer layer];
            stripe.frame = CGRectMake(width * i, 0, width, frame.size.height);
            [stripeLayer addSublayer:stripe];
            UIBezierPath *bezier = [UIBezierPath bezierPath];
            [bezier moveToPoint:CGPointMake(0, frame.size.height)];
            [bezier addLineToPoint:CGPointMake(width * 2 / 4, 0)];
            [bezier addLineToPoint:CGPointMake(width, 0)];
            [bezier addLineToPoint:CGPointMake(width * 2 / 4, frame.size.height)];
            [bezier closePath];
            stripe.path = bezier.CGPath;
            stripe.fillColor = RGBA(135, 206, 235, 1).CGColor;
        }
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation.duration = 1.5;
        animation.fromValue = @(4 * width);
        animation.toValue = @(6 * width);
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        [stripeLayer addAnimation:animation forKey:@"move"];
        
        UILabel *progressLabel = [[UILabel alloc]init];
        progressLabel.text = @"0%";
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.textColor = UIColor.whiteColor;
        progressLabel.font = [UIFont systemFontOfSize:13];
        [backView addSubview:progressLabel];
        _progressLabel = progressLabel;
        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(barWidth - 40);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(40);
        }];
        
        UILabel *noticeLabel = [[UILabel alloc]init];
        noticeLabel.text = @"正在为您占座中...";
        noticeLabel.textColor = UIColor.whiteColor;
        noticeLabel.font = [UIFont systemFontOfSize:13];
        [backView addSubview:noticeLabel];
        _noticeLabel = noticeLabel;
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress duration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    _noticeLabel.text = @"正在为您占座中...";
    NSTimeInterval tempDuration = duration / ((progress - _progress) * 1000);
    __block CGFloat tempProgress = _progress;
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:tempDuration repeats:YES block:^(NSTimer * _Nonnull timer) {
        tempProgress += 0.001;
        self.progressLabel.text = [NSString stringWithFormat:@"%.f%%",tempProgress * 100];
        self.backProgressLabel.text = [NSString stringWithFormat:@"%.f%%",tempProgress * 100];
        self.backView.frame = CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, barWidth * tempProgress, self.backView.frame.size.height);
        self.progress = tempProgress;
        if ([self.progressLabel.text isEqualToString:@"20%"]) {
            if (self.imageBlock) {
                self.imageBlock(0);
            }
        }
        else if ([self.progressLabel.text isEqualToString:@"40%"])
        {
            if (self.imageBlock) {
                self.imageBlock(1);
            }
        }
        else if ([self.progressLabel.text isEqualToString:@"60%"])
        {
            if (self.imageBlock) {
                self.imageBlock(2);
            }
        }
        else if ([self.progressLabel.text isEqualToString:@"80%"])
        {
            if (self.imageBlock) {
                self.imageBlock(3);
            }
        }
        else if ([self.progressLabel.text isEqualToString:@"100%"])
        {
            self.noticeLabel.text = @"占座成功，即将为您跳转界面";
        }
        if (tempProgress >= progress) {
            [timer invalidate];
            timer = nil;
            if (completion) {
                completion();
            }
        }
    }];
    
    if (progress >= 1) {
        progress = 0;
    }
}

- (void)dealloc
{
    NSLog(@"StripeProgressBar dealloc");
}

@end
