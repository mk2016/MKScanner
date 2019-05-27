//
//  MKSessionManager.h
//  MKScanner
//
//  Created by xiaomk on 2019/5/27.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSessionManager : NSObject

- (void)start;
- (void)stop;

- (AVCaptureVideoPreviewLayer *)getVideoPreview;
- (void)focusWithPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
