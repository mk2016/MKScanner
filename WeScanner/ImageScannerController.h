//
//  ImageScannerController.h
//  MKScanner
//
//  Created by xiaomk on 2019/6/11.
//  Copyright © 2019 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageScannerResults : NSObject
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *scannedImage;
@property (nonatomic, strong) UIImage *enhancedImage;
@property (nonatomic, assign) BOOL doesUserPreferEnhancedImage;
//@property (nonatomic, strong) Quadrilateral *detectedRectangle;

@end

@class ImageScannerController;
@protocol ImageScannerControllerDelegate <NSObject>
- (void)imageScannerController:(ImageScannerController *)scanner results:(ImageScannerResults *)results;
- (void)imageScannerControllerDidCancel:(ImageScannerController *)scanner;
- (void)imageScannerController:(ImageScannerController *)scanner didFailWithError:(NSError *)error;
@end

@interface ImageScannerController : UINavigationController

@end

NS_ASSUME_NONNULL_END
