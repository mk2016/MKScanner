//
//  MKSampleBufferUtils.h
//  MKScanner
//
//  Created by xiaomk on 2019/6/12.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "MKQuadrilateral.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKSampleBufferUtils : NSObject

+ (MKQuadrilateral *)biggestRectangleWith:(CMSampleBufferRef)sampleBuffer;
+ (void)biggestRectangleWith:(CMSampleBufferRef)sampleBuffer block:(void(^)(MKQuadrilateral *quadrilateral))block;

@end

NS_ASSUME_NONNULL_END
