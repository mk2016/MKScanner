//
//  MKScan_VC.m
//  MKScanner
//
//  Created by xiaomk on 2019/5/25.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKScan_VC.h"
#import "MKConst.h"
#import "MKFocusIndicatorView.h"
#import "MKShutterButton.h"
#import "MKOverView.h"
#import "MKSessionManager.h"
#import "MKSampleBufferUtils.h"
#import "MKQuadrilateral.h"

@interface MKScan_VC ()<MKSessionManagerDelegate>
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) MKFocusIndicatorView *focusIndicatorView;
@property (nonatomic, strong) MKShutterButton *shutterButton;
@property (nonatomic, strong) MKOverView *overView;
@property (nonatomic, strong) MKSessionManager *sessionManager;
@end

@implementation MKScan_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view addSubview:self.navigationBarView];
    [self.sessionManager start];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationBarView removeFromSuperview];
    [self.sessionManager stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    self.sessionManager = [[MKSessionManager alloc] init];
    self.sessionManager.delegate = self;
    [self.view.layer addSublayer:[self.sessionManager getVideoPreview]];
    
    self.overView = [[MKOverView alloc] initWithFrame:CGRectMake(0, 0, MK_SCREEN_WIDTH, MK_SCREEN_HEIGHT)];
    [self.view addSubview:self.overView];
    
    self.focusIndicatorView = [MKFocusIndicatorView createView];
    [self.view addSubview:self.focusIndicatorView];
    
    self.shutterButton = [[MKShutterButton alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    self.shutterButton.center = CGPointMake(MK_SCREEN_WIDTH/2, MK_SCREEN_HEIGHT-MK_SCREEN_IPHONEX_BOTTOM-60);
    [self.view addSubview:self.shutterButton];
    [self.shutterButton addTarget:self action:@selector(shutterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - ***** MKSessionManagerDelegate ******
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (sampleBuffer) {
        MK_WEAK_SELF
        [MKSampleBufferUtils biggestRectangleWith:sampleBuffer block:^(MKQuadrilateral * _Nonnull quadrilateral) {
            if (quadrilateral) {
                
                [weakSelf.overView refreshWith:quadrilateral];
                NSLog(@"-----%@", [quadrilateral description]);
            }
        }];
//        MKQuadrilateral *feature = [MKSampleBufferUtils biggestRectangleWith:sampleBuffer];
        
    }
    
}












/** 点击拍照 */
- (void)shutterButtonAction{
//    self.shutterButton.userInteractionEnabled = NO;
}


/** 点击屏幕对焦对焦 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    if (touch) {
        CGPoint touchPoint = [touch locationInView:self.view];
        [self.focusIndicatorView showWithPoint:touchPoint];
        [self.sessionManager focusWithPoint:touchPoint];
    }
}

+ (void)cameraPermissionsWithBlock:(MKBoolBlock)block{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                MK_BLOCK_EXEC(block, granted);
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
            MK_BLOCK_EXEC(block, YES);
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            MK_BLOCK_EXEC(block, NO);
            break;
        default:
            MK_BLOCK_EXEC(block, NO);
            break;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - ***** lazy ******
- (UIView *)navigationBarView{
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MK_SCREEN_WIDTH, MK_SCREEN_IPHONEX_NAVGATION)];
        _navigationBarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setImage:[UIImage imageNamed:@"public_img_back_1"] forState:UIControlStateNormal];
        btnBack.frame = CGRectMake(0, MK_SCREEN_IPHONEX_TOP, 68, 44);
        [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBarView addSubview:btnBack];
        
        UIButton *btnTorch = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTorch setImage:[UIImage imageNamed:@"scan_img_flash_0"] forState:UIControlStateNormal];
        [btnTorch setImage:[UIImage imageNamed:@"scan_img_flash_1"] forState:UIControlStateSelected];
        [btnTorch setImage:[UIImage imageNamed:@"scan_img_flash_1"] forState:UIControlStateHighlighted];
        btnTorch.frame = CGRectMake(68, MK_SCREEN_IPHONEX_TOP, MK_SCREEN_WIDTH/4, 44);
        [btnTorch addTarget:self action:@selector(btnTorchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBarView addSubview:btnTorch];
        
    }
    return _navigationBarView;
}

- (void)btnTorchAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    [self.sessionManager setTorch:sender.selected];
}

- (void)btnBackAction{
    [self.sessionManager setTorch:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
