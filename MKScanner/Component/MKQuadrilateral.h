//
//  MKQuadrilateral.h
//  MKScanner
//
//  Created by xiaomk on 2019/6/12.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Vision/Vision.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKQuadrilateral : NSObject
@property (nonatomic, assign) CGPoint topLeft;
@property (nonatomic, assign) CGPoint topRight;
@property (nonatomic, assign) CGPoint bottomLeft;
@property (nonatomic, assign) CGPoint bottomRight;

- (id)initWithRectangleFeature:(CIRectangleFeature *)feature;
- (id)initWithRectangleObservation:(VNRectangleObservation *)observation size:(CGSize)size;
- (MKQuadrilateral *)sortPoints;
- (MKQuadrilateral *)translateToScaleWith:(CGRect)rect;
- (CGFloat)perimeter;
- (NSString *)description;
@end

NS_ASSUME_NONNULL_END
