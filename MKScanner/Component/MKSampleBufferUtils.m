//
//  MKSampleBufferUtils.m
//  MKScanner
//
//  Created by xiaomk on 2019/6/12.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKSampleBufferUtils.h"
#import "MKConst.h"
#import <Vision/Vision.h>

@implementation MKSampleBufferUtils

+ (void)biggestRectangleWith:(CMSampleBufferRef)sampleBuffer block:(void(^)(MKQuadrilateral *quadrilateral))block{
//}
//+ (MKQuadrilateral *)biggestRectangleWith:(CMSampleBufferRef)sampleBuffer{
    if (sampleBuffer){
        CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        if (@available(iOS 11.0, *)) {
            CGSize imageSize = CGSizeMake(CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer));
            void (^VNRequestCompletionHandler)(VNRequest *request, NSError * _Nullable error) = ^(VNRequest *request, NSError * _Nullable error){
//                [self biggestRectangleWithRequest:request size:imageSize];
                if (request.results && request.results.count > 0) {
                    MKQuadrilateral *biggest = nil;
                    CGFloat maxPerimiter = 0;
                    
                    for (VNRectangleObservation *obs in request.results) {
                        MKQuadrilateral *quads = [[MKQuadrilateral alloc] initWithRectangleObservation:obs size:imageSize];
                        CGFloat tQuadrilateralPerimeter = [quads perimeter];
                        if (maxPerimiter < tQuadrilateralPerimeter) {
                            maxPerimiter = tQuadrilateralPerimeter;
                            biggest = quads;
                        }
                    }
                    
                    CGAffineTransform transform = CGAffineTransformMakeScale(imageSize.width, imageSize.height);
                    biggest.topLeft = CGPointApplyAffineTransform(biggest.topLeft, transform);
                    biggest.topRight = CGPointApplyAffineTransform(biggest.topRight, transform);
                    biggest.bottomRight = CGPointApplyAffineTransform(biggest.bottomRight, transform);
                    biggest.bottomLeft = CGPointApplyAffineTransform(biggest.bottomLeft, transform);

                    
                    
//                    MKQuadrilateral *realFeature = [self leftCartesianToScreenUPCoordinateWith:featureScale];
                    MK_BLOCK_EXEC(block, biggest);
                }
            };
            VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCVPixelBuffer:pixelBuffer options:@{}];
            VNDetectRectanglesRequest *request = [[VNDetectRectanglesRequest alloc] initWithCompletionHandler:VNRequestCompletionHandler];
            request.minimumAspectRatio = 0.1;
            request.maximumObservations = 0;
            [handler performRequests:@[request] error:nil];
        }else{
            CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                        sampleBuffer,
                                                                        kCMAttachmentMode_ShouldPropagate);
            CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
            if (ciImage){
                MKQuadrilateral *feature = [self biggestRectangleWithCIImage:ciImage];
                MKQuadrilateral *featureScale = [feature translateToScaleWith:ciImage.extent];
                
                MKQuadrilateral *realFeature = [self leftCartesianToScreenUPCoordinateWith:featureScale];
                MK_BLOCK_EXEC(block, realFeature);
                return;
            }
        }
    }
    MK_BLOCK_EXEC(block,nil);
}

+ (MKQuadrilateral *)translatePreviewPointsBy:(MKQuadrilateral *)feature imageRect:(CGRect)imageRect{
    
    
    [feature translateToScaleWith:imageRect];
    return feature;
}



+ (MKQuadrilateral *)leftCartesianToScreenUPCoordinateWith:(MKQuadrilateral *)scale{
    MKQuadrilateral *quad = [[MKQuadrilateral alloc] init];
    quad.topLeft = CGPointMake(scale.bottomLeft.y * MK_SCREEN_WIDTH, scale.bottomLeft.x * MK_SCREEN_HEIGHT);
    quad.topRight = CGPointMake(scale.topLeft.y * MK_SCREEN_WIDTH , scale.topLeft.x * MK_SCREEN_HEIGHT);
    quad.bottomLeft = CGPointMake(scale.bottomRight.y * MK_SCREEN_WIDTH , scale.bottomRight.x * MK_SCREEN_HEIGHT);
    quad.bottomRight = CGPointMake(scale.topRight.y * MK_SCREEN_WIDTH , scale.topRight.x * MK_SCREEN_HEIGHT);
    return quad;
}

+ (MKQuadrilateral *)biggestRectangleWithCIImage:(CIImage *)ciImage{
    CIImage *tempImage = [CIFilter filterWithName:@"CIColorControls"
                              withInputParameters:@{@"inputContrast":@(1.1),kCIInputImageKey:ciImage}].outputImage;
    NSArray <CIFeature *>*features = [[self highAccuracyRectangleDetector] featuresInImage:tempImage];
    return [self biggestRectangleInRectangles:features];
}

+ (MKQuadrilateral *)biggestRectangleInRectangles:(NSArray *)rectangles{
    if (![rectangles count]) return nil;
    MKQuadrilateral *biggest = nil;
    CGFloat maxPerimiter = 0;
    for (CIRectangleFeature *feature in rectangles) {
        MKQuadrilateral *tQuadrilateral = [[MKQuadrilateral alloc] initWithRectangleFeature:feature];
        CGFloat tQuadrilateralPerimeter = [tQuadrilateral perimeter];
        if (maxPerimiter < tQuadrilateralPerimeter) {
            maxPerimiter = tQuadrilateralPerimeter;
            biggest = tQuadrilateral;
        }
    }
    return biggest;
}

//+ (MKQuadrilateral *)biggestRectangleWithRequest:(VNRequest *)request size:(CGSize)size{
//    if (request.results && request.results.count > 0) {
//        for (VNRectangleObservation *obs in request.results) {
//            MKQuadrilateral *quads = [[MKQuadrilateral alloc] initWithRectangleObservation:obs size:size];
//
//        }
//    }
//}


#pragma mark - ***** rectangle detetor (high || low) ******
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

