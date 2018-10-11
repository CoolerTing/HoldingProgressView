//
//  StripeProgressBar.h
//  EFSearch
//
//  Created by coolerting on 2018/10/9.
//  Copyright © 2018年 coolerting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StripeProgressBar : UIView
@property (nonatomic, copy) void(^imageBlock)(NSInteger index);
- (void)setProgress:(CGFloat)progress duration:(NSTimeInterval)duration completion:(void(^)(void))completion;
@end
