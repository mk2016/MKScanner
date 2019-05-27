//
//  MKSessionManager.m
//  MKScanner
//
//  Created by xiaomk on 2019/5/27.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKSessionManager.h"
#import "MKConst.h"



@interface MKSessionManager()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;       /*!< 输入流 */
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureOutput;  /*!< 输出流 */
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@end

@implementation MKSessionManager

- (AVCaptureVideoPreviewLayer *)getVideoPreview{
    return self.preview;
}

- (id)init{
    if ([super init]) {
        [self initializeCamera];
    }
    return self;
}

- (void)initializeCamera{
    self.session = [[AVCaptureSession alloc] init];
//    [self.session beginConfiguration];
    [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            self.device = device;
        }
    }
    
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if ([self.session canAddInput:self.captureInput]) {
        [self.session addInput:self.captureInput];
    }
    
    self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [self.captureOutput setSampleBufferDelegate:self queue:dispatch_queue_create("com.mk.scanner", NULL)];
    
    NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    [self.captureOutput setVideoSettings:[NSDictionary dictionaryWithObject:value forKey:key]];
    if ([self.session canAddOutput:self.captureOutput]){
        [self.session addOutput:self.captureOutput];
    }
    
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]){
                self.videoConnection = connection;
                break;
            }
        }
        if (self.videoConnection) {
            break;
        }
    }
    self.videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.frame = CGRectMake(0, 0, MK_SCREEN_WIDTH, MK_SCREEN_HEIGHT);
    [self.preview setAffineTransform:CGAffineTransformMakeScale(kMK_FOCAL_SCALE,kMK_FOCAL_SCALE)];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
}

- (void)start{
    [self.session startRunning];
}

- (void)stop{
    [self.session stopRunning];
}

#pragma mark - ***** AVCaptureSession delegate ******
- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
}

/** focus with touch position */
- (void)focusWithPoint:(CGPoint)point{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    CGPoint pointOfInterst = CGPointZero;
    pointOfInterst = CGPointMake(point.y / MK_SCREEN_HEIGHT, 1.f - (point.x / MK_SCREEN_WIDTH));
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                device.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
            }
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                device.focusMode = AVCaptureFocusModeAutoFocus;
                device.focusPointOfInterest = pointOfInterst;
            }
            if ([device isExposurePointOfInterestSupported] &&
                [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                device.exposurePointOfInterest = pointOfInterst;
                device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            }
            [device unlockForConfiguration];
        }
    }
}

@end
