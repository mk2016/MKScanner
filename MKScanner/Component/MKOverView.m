//
//  MKOverView.m
//  Taoqicar
//
//  Created by xiaomk on 2019/6/6.
//  Copyright © 2019 taoqicar. All rights reserved.
//

#import "MKOverView.h"

@interface MKOverView(){
    CGPoint _pointTL; //左上
    CGPoint _pointTR; //右上
    CGPoint _pointBR; //右下
    CGPoint _pointBL; //左下
}
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation MKOverView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.tintColor = UIColor.whiteColor;
    }
    return self;
}

- (void)remove{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (void)refreshWith:(MKQuadrilateral *)quadrilateral{
    if (quadrilateral){
        _pointTL = quadrilateral.topLeft;
        _pointTR = quadrilateral.topRight;
        _pointBR = quadrilateral.bottomRight;
        _pointBL = quadrilateral.bottomLeft;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.hidden){
                self.hidden = NO;
            }
            [self setNeedsDisplay];
        });
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self.tintColor set];
    CGContextRef curContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(curContext, 2.0f);
    
    if (self.showCorner){   // 四角
        int s = 25;
        CGContextMoveToPoint(curContext,    _pointTL.x,   _pointTL.y+s);
        CGContextAddLineToPoint(curContext, _pointTL.x,   _pointTL.y);
        CGContextAddLineToPoint(curContext, _pointTL.x+s, _pointTL.y);
        
        CGContextMoveToPoint(curContext,    _pointTR.x-s, _pointTR.y);
        CGContextAddLineToPoint(curContext, _pointTR.x,   _pointTR.y);
        CGContextAddLineToPoint(curContext, _pointTR.x,   _pointTR.y+s);
        
        CGContextMoveToPoint(curContext,    _pointBR.x,   _pointBR.y-s);
        CGContextAddLineToPoint(curContext, _pointBR.x,   _pointBR.y);
        CGContextAddLineToPoint(curContext, _pointBR.x-s, _pointBR.y);
        
        CGContextMoveToPoint(curContext,    _pointBL.x,   _pointBL.y-s);
        CGContextAddLineToPoint(curContext, _pointBL.x,   _pointBL.y);
        CGContextAddLineToPoint(curContext, _pointBL.x+s, _pointBL.y);
    }else{  //全框
        if (self.dashed){
            CGContextMoveToPoint(curContext, 0, 0);
            CGFloat arr1[] = {5,2}; //虚线 （绘制 5个点 跳过 2个点）
            CGContextSetLineDash(curContext, 0, arr1, 2);
        }
        CGContextMoveToPoint(curContext,    _pointTL.x, _pointTL.y);
        CGContextAddLineToPoint(curContext, _pointTR.x, _pointTR.y);
        CGContextAddLineToPoint(curContext, _pointBR.x, _pointBR.y);
        CGContextAddLineToPoint(curContext, _pointBL.x, _pointBL.y);
        CGContextAddLineToPoint(curContext, _pointTL.x, _pointTL.y);
    }
    CGContextStrokePath(curContext);

    //是否镂空效果
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    if (self.hollowOut){
        CGRect biggerRect = self.bounds;
        [maskPath moveToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
        [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect))];
        [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect))];
        [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect))];
        [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
        self.maskLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    }else{
        self.maskLayer.fillColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    }
    [maskPath moveToPoint:_pointTL];
    [maskPath addLineToPoint:_pointTR];
    [maskPath addLineToPoint:_pointBR];
    [maskPath addLineToPoint:_pointBL];
    [maskPath addLineToPoint:_pointTL];
    self.maskLayer.path = maskPath.CGPath;
}


#pragma mark - ***** lazy ******
- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_maskLayer];
    }
    return _maskLayer;
}
@end
