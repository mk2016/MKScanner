//
//  MKFocusIndicatorView.m
//  MKScanner
//
//  Created by xiaomk on 2019/5/25.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKFocusIndicatorView.h"

@implementation MKFocusIndicatorView

+ (MKFocusIndicatorView *)createView{
    MKFocusIndicatorView *view = [[MKFocusIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    return view;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = 4;
        self.alpha = 0;
    }
    return self;
}

- (void)showWithPoint:(CGPoint)point{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setCenter:point];
        self.alpha = 0.0;
        self.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 1.0;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.alpha = 0.f;
            }];
        }];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
