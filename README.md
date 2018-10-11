# HoldingProgressView
仿同城火车票占座动画。
## 说明
项目功能。

重点在于条纹进度条。

带有条纹旋转动画，更美观。

可根据需求修改代码。
## 示例
![HoldingProgressView](https://github.com/CoolerTing/HoldingProgressView/blob/master/HoldingProgressView.gif)
## 使用

```objective-c
#import "StripeProgressBar.h"
```
创建对象
```
StripeProgressBar *stripe = [[StripeProgressBar alloc]initWithFrame:CGRectMake(10, infoView.frame.origin.y + infoView.frame.size.height + 25, holdingView.frame.size.width - 20, 50)];
    stripe.imageBlock = ^(NSInteger index) {
        UIImageView *arrowImageView = imageArray[index];
        [UIView animateWithDuration:0.2 animations:^{
            arrowImageView.alpha = 1;
        }];
    };
    _stripe = stripe;
    [holdingView addSubview:stripe];
```
#### imageBlock
百分比回调，进度为20%，40%，60%，80%回调，显示成功状态图标，可在block里自行操作。

#### 设置进度动画
```objective-c
[_stripe setProgress:1 duration:15 completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.holdingView removeFromSuperview];
        });
    }];
```

### 参数
* progress：需要达到的进度百分比(0 - 1)
* duration：动画时长
* completion：动画完成回调
