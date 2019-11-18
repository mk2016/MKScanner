//
//  MKFocusIndicatorView.h
//  MKScanner
//
//  Created by xiaomk on 2019/5/25.
//  Copyright © 2019 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFocusIndicatorView : UIView

+ (MKFocusIndicatorView *)createView;

- (void)showWithPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
