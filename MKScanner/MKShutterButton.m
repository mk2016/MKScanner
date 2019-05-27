//
//  MKShutterButton.m
//  MKScanner
//
//  Created by xiaomk on 2019/5/26.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKShutterButton.h"
#import <QuartzCore/QuartzCore.h>

@interface MKShutterButton (){
    CGFloat _outterRingRatio;
    CGFloat _innerRingRatio;
}

@property (nonatomic, strong) CAShapeLayer *outterRingLayer;
@property (nonatomic, strong) CAShapeLayer *innerCircleLayer;
@property (nonatomic, strong) id impactFeedbackGenerator;
@end

@implementation MKShutterButton

static void *MKShutterButtonContext = &MKShutterButtonContext;


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _outterRingRatio = 0.80;
        _innerRingRatio = 0.75;
        
        self.outterRingLayer = [[CAShapeLayer alloc] init];
        self.innerCircleLayer = [[CAShapeLayer alloc] init];
        
        [self.layer addSublayer:self.outterRingLayer];
        [self.layer addSublayer:self.innerCircleLayer];
        self.backgroundColor = UIColor.clearColor;
        self.isAccessibilityElement = true;
        self.accessibilityTraits = UIAccessibilityTraitButton;
        
        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:MKShutterButtonContext];
        
        if (@available(iOS 10.0, *)) {
            self.impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [(UIImpactFeedbackGenerator *)self.impactFeedbackGenerator prepare];
        }
    }
    return self;
}

/** kvo */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == MKShutterButtonContext && [keyPath isEqualToString:@"highlighted"]) {
        BOOL oldValue = [[change objectForKey:NSKeyValueChangeOldKey] boolValue];
        BOOL newValue = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (oldValue != newValue) {
            [self animateInnerCircleLayer:newValue];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)animateInnerCircleLayer:(BOOL)highlighted{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSArray *values = nil;
    if (highlighted) {
        values = @[
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.93, 0.93, 0.93)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)],
          ];
    }else{
        values = @[
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]
                   ];
    }

    animation.values = values;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = highlighted ? 0.35 : 0.1;
    
    [self.innerCircleLayer addAnimation:animation forKey:@"transform"];
    if (self.impactFeedbackGenerator && [self.impactFeedbackGenerator respondsToSelector:@selector(impactOccurred)]) {
        [self.impactFeedbackGenerator performSelector:@selector(impactOccurred)];
    }
//    else{
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    self.outterRingLayer.frame = rect;
    self.outterRingLayer.path = [self pathForOutterRingWith:rect].CGPath;
    self.outterRingLayer.fillColor = UIColor.whiteColor.CGColor;
    self.outterRingLayer.rasterizationScale = [UIScreen mainScreen].scale;
    self.outterRingLayer.shouldRasterize = true;
    
    self.innerCircleLayer.frame = rect;
    self.innerCircleLayer.path = [self pathForInnerCircleWith:rect].CGPath;
    self.innerCircleLayer.fillColor = UIColor.whiteColor.CGColor;
    self.innerCircleLayer.rasterizationScale = [UIScreen mainScreen].scale;
    self.innerCircleLayer.shouldRasterize = true;
    
}

- (UIBezierPath *)pathForOutterRingWith:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    CGRect innerRect = [self rectWith:rect andRatio:_outterRingRatio];
    UIBezierPath *innerPath = [[UIBezierPath bezierPathWithOvalInRect:innerRect] bezierPathByReversingPath];
    [path appendPath:innerPath];
    return path;
}

- (UIBezierPath *)pathForInnerCircleWith:(CGRect)rect{
    CGRect tRect = [self rectWith:rect andRatio:_innerRingRatio];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:tRect];
    return path;
}

/** 根据 rect 和 缩放比例， 生成一个 同中心点 的 rect */
- (CGRect)rectWith:(CGRect)rect andRatio:(CGFloat)ratio{
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(ratio, ratio);
    CGRect scaledRect = CGRectApplyAffineTransform(rect, scaleTransform);
    
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(
                                                                            rect.origin.x * (1 - ratio) + (rect.size.width - scaledRect.size.width) / 2.0,
                                                                            rect.origin.y * (1 - ratio) + (rect.size.height - scaledRect.size.height) / 2.0
                                                                            );
    CGRect tRect = CGRectApplyAffineTransform(scaledRect, translateTransform);
    return tRect;
}

/** dealloc */
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"highlighted" context:MKShutterButtonContext];
}

@end


