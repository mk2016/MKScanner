//
//  MKQuadrilateral.m
//  MKScanner
//
//  Created by xiaomk on 2019/6/12.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKQuadrilateral.h"
#import "MKConst.h"

@implementation MKQuadrilateral
- (id)initWithRectangleFeature:(CIRectangleFeature *)feature{
    if (self = [super init]){
        _topLeft = feature.topLeft;
        _topRight = feature.topRight;
        _bottomLeft = feature.bottomLeft;
        _bottomRight = feature.bottomRight;
    }
    return self;
}

- (id)initWithRectangleObservation:(VNRectangleObservation *)observation size:(CGSize)size{
    if (self = [super init]) {
        self.topLeft = observation.topLeft;
        self.topRight = observation.topRight;
        self.bottomRight = observation.bottomRight;
        self.bottomLeft = observation.bottomLeft;

//        CGAffineTransform transform = CGAffineTransformMakeScale(size.width, size.height);
//        self.topLeft = CGPointApplyAffineTransform(topLeft, transform);
//        self.topRight = CGPointApplyAffineTransform(topRight, transform);
//        self.bottomRight = CGPointApplyAffineTransform(bottomRight, transform);
//        self.bottomLeft = CGPointApplyAffineTransform(bottomLeft, transform);
//        
//
//        CGPoint topLeft = CGPointMake(observation.bottomLeft.y, observation.bottomLeft.x);
//        CGPoint topRight = CGPointMake(observation.topLeft.y, observation.topLeft.x);
//        CGPoint bottomRight = CGPointMake(observation.topRight.y, observation.topRight.x);
//        CGPoint bottomLeft = CGPointMake(observation.bottomRight.y, observation.bottomRight.x);
//
////        self.topLeft = observation.topLeft;
////        self.topRight = observation.topRight;
////        self.bottomRight = observation.bottomRight;
////        self.bottomLeft = observation.bottomLeft;
//        NSLog(@"====1 : %@", [self description]);
////        self.topLeft = CGPointMake(observation.topLeft.x * size.height, observation.topLeft.y * size.width);
////        self.topRight = CGPointMake(observation.topRight.x * size.height, observation.topRight.y * size.width);
////        self.bottomRight = CGPointMake(observation.bottomRight.x * size.height, observation.bottomRight.y * size.width);
////        self.bottomLeft = CGPointMake(observation.bottomLeft.x * size.height, observation.bottomLeft.y * size.width);
//
//
//        CGAffineTransform transform = CGAffineTransformMakeScale(size.width, size.height);
//        self.topLeft = CGPointApplyAffineTransform(topLeft, transform);
//        self.topRight = CGPointApplyAffineTransform(topRight, transform);
//        self.bottomRight = CGPointApplyAffineTransform(bottomRight, transform);
//        self.bottomLeft = CGPointApplyAffineTransform(bottomLeft, transform);
//        NSLog(@"====2 : %@", [self description]);
    }
    return self;
}
- (MKQuadrilateral *)sortPoints{
    CGPoint tPoints[4];
    tPoints[0] = self.topLeft;
    tPoints[1] = self.topRight;
    tPoints[2] = self.bottomLeft;
    tPoints[3] = self.bottomRight;
}

- (CGFloat)perimeter{
    CGFloat topLength = hypotf(self.topLeft.x-self.topRight.x, self.topLeft.y-self.topRight.y);
    CGFloat leftLength = hypotf(self.topLeft.x-self.bottomLeft.x, self.topLeft.y-self.bottomLeft.y);
    CGFloat bottomLength = hypotf(self.bottomLeft.x-self.bottomRight.x, self.bottomLeft.y-self.bottomRight.y);
    CGFloat rightLength = hypotf(self.topRight.x-self.bottomRight.x, self.topRight.y-self.bottomRight.y);
    NSLog(@"lengths Top Left Bottom right : %@, %@, %@, %@",@(topLength),@(leftLength),@(bottomLength),@(rightLength));
    return topLength + leftLength + bottomLength + rightLength;
}

- (MKQuadrilateral *)translateToScaleWith:(CGRect)rect{
//    CGAffineTransform transform = CGAffineTransformMakeScale(size.width, size.height);
//    CGPointApplyAffineTransform(<#CGPoint point#>, <#CGAffineTransform t#>)
//    CGPointApplyAffineTransform(self., <#CGAffineTransform t#>)
    MKQuadrilateral *quad = [[MKQuadrilateral alloc] init];
    quad.topLeft = CGPointMake(self.topLeft.x/CGRectGetWidth(rect), self.topLeft.y/CGRectGetHeight(rect));
    quad.topRight = CGPointMake(self.topRight.x/CGRectGetWidth(rect), self.topRight.y/CGRectGetHeight(rect));
    quad.bottomLeft = CGPointMake(self.bottomLeft.x/CGRectGetWidth(rect), self.bottomLeft.y/CGRectGetHeight(rect));
    quad.bottomRight = CGPointMake(self.bottomRight.x/CGRectGetWidth(rect), self.bottomRight.y/CGRectGetHeight(rect));
    return quad;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"topLeft:%@, topRight:%@, bottomRight:%@, bottomLeft:%@",
            NSStringFromCGPoint(self.topLeft),
            NSStringFromCGPoint(self.topRight),
            NSStringFromCGPoint(self.bottomRight),
            NSStringFromCGPoint(self.bottomLeft)
            ];
}
@end
