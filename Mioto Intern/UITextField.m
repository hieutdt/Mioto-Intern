//
//  UITextField.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/2/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "UITextField.h"

@implementation UITextField (MyTextField)

- (void) setPadding {
    CGRect rect = CGRectMake(0, 0, 10, self.frame.size.height);
    UIView *paddingView = [[UIView alloc] init];
    [paddingView setAccessibilityFrame:rect];
    self.leftView = paddingView;
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

- (void) setBottomBorder {
    CALayer *border = [[CALayer alloc] initWithLayer:self.layer];
    border.frame = CGRectMake(0, self.layer.frame.size.height - 1, self.layer.frame.size.width, 2.0);
    border.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:border];
}

@end
