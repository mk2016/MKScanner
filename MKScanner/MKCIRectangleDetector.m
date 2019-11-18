//
//  MKCIRectangleDetector.m
//  MKScanner
//
//  Created by xiaomk on 2019/5/29.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKCIRectangleDetector.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@implementation MKCIRectangleDetector

+ (CIRectangleFeature *)biggestRectangleWith:(CIImage *)ciImage{
    CIImage *tempImage = [CIFilter filterWithName:@"CIColorControls"
                              withInputParameters:@{@"inputContrast":@(1.1),kCIInputImageKey:ciImage}].outputImage;
    NSArray <CIFeature *>*features = [[self highAccuracyRectangleDetector] featuresInImage:tempImage];
    return [self biggestRectangleInRectangles:features];
}

// 选取feagure rectangles中最大的矩形
+ (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles{
    if (![rectangles count]) return nil;
    float halfPerimiterValue = 0;
    CIRectangleFeature *biggestRectangle = [rectangles firstObject];
    if (rectangles.count > 1) {
        NSLog(@"rectangles count : %@", @(rectangles.count));
        for (CIRectangleFeature *rect in rectangles){
            CGPoint p1 = rect.topLeft;
            CGPoint p2 = rect.topRight;
            CGFloat width = hypotf(p1.x - p2.x, p1.y - p2.y);
            
            CGPoint p3 = rect.topLeft;
            CGPoint p4 = rect.bottomLeft;
            CGFloat height = hypotf(p3.x - p4.x, p3.y - p4.y);
            
            CGFloat currentHalfPerimiterValue = height + width;
            
            if (halfPerimiterValue < currentHalfPerimiterValue){
                halfPerimiterValue = currentHalfPerimiterValue;
                biggestRectangle = rect;
            }
        }
    }
    return biggestRectangle;
}


// 高精度边缘识别
+ (CIDetector *)highAccuracyRectangleDetector{
    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        detector = [CIDetector detectorOfType:CIDetectorTypeRectangle
                                      context:nil
                                      options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    });
    return detector;
}

// 低精度边缘识别器
+ (CIDetector *)lowAccuracyRectangleDetetor{
    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        detector = [CIDetector detectorOfType:CIDetectorTypeRectangle
                                      context:nil
                                      options:@{CIDetectorAccuracy:CIDetectorAccuracyLow,
                                                CIDetectorTracking : @(YES)}];
    });
    return detector;
}

@end
