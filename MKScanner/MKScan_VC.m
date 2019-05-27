//
//  MKScan_VC.m
//  MKScanner
//
//  Created by xiaomk on 2019/5/25.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKScan_VC.h"
#import "MKFocusIndicatorView.h"
#import "MKConst.h"
#import "MKShutterButton.h"

@interface MKScan_VC ()
@property (nonatomic, strong) UIView *navigationBarView;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) MKFocusIndicatorView *focusIndicatorView;
@property (nonatomic, strong) MKShutterButton *shutterButton;
@end

@implementation MKScan_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view addSubview:self.navigationBarView];
//    
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar addSubview:self.navigationBarView];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    self.navigationBarView.frame = self.view.layer.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    //点击屏幕对焦对焦
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
//    if (singleTap) {
//        [self.view addGestureRecognizer:singleTap];
//    }
    
    self.focusIndicatorView = [MKFocusIndicatorView createView];
    [self.view addSubview:self.focusIndicatorView];
    
    self.shutterButton = [[MKShutterButton alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    self.shutterButton.center = CGPointMake(MK_SCREEN_WIDTH/2, MK_SCREEN_HEIGHT-MK_SCREEN_IPHONEX_BOTTOM-60);
    [self.view addSubview:self.shutterButton];
    [self.shutterButton addTarget:self action:@selector(shutterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shutterButtonAction{
//    self.shutterButton.userInteractionEnabled = NO;
}

/** 点击屏幕对焦 */
- (void)singleTapAction:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    [self.focusIndicatorView showWithPoint:point];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - ***** lazy ******
- (UIView *)navigationBarView{
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MK_SCREEN_WIDTH, MK_SCREEN_IPHONEX_NAVGATION)];
        _navigationBarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//        _navigationBarView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//        _navigationBarView.frame = CGRectMake(0, 0, MK_SCREEN_WIDTH, MK_SCREEN_IPHONEX_NAVGATION);
    }
    return _navigationBarView;
}

@end
