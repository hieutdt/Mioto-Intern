//
//  SignUpViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/4/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "SignUpViewController.h"
#import "UITextField.h"

@interface SignUpViewController()

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Background;
@property (strong, nonatomic) IBOutlet UITextField *textField_Name;
@property (strong, nonatomic) IBOutlet UITextField *textField_EmailOrPhone;
@property (strong, nonatomic) IBOutlet UITextField *textField_Password;
@property (strong, nonatomic) IBOutlet UITextField *textField_PasswordAgain;
@property (strong, nonatomic) IBOutlet UIButton *button_Checkbox1;
@property (strong, nonatomic) IBOutlet UIButton *button_Checkbox2;

@property bool checkBox1_Checked;
@property bool checkBox2_Checked;

- (IBAction)backLogInView:(id)sender;
- (IBAction)checkBox1OnClick:(id)sender;
- (IBAction)checkBox2OnClick:(id)sender;


@end

@implementation SignUpViewController

@synthesize imageView_Background;
@synthesize textField_Name;
@synthesize textField_EmailOrPhone;
@synthesize textField_Password;
@synthesize textField_PasswordAgain;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [imageView_Background setImage:[UIImage imageNamed:@"background_authentication_screen.jpg"]];
    
    [textField_Name setBottomBorder];
    [textField_EmailOrPhone setBottomBorder];
    [textField_Password setBottomBorder];
    [textField_PasswordAgain setBottomBorder];
    
    //set Place holder color
    textField_EmailOrPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Số điện thoại hoặc email" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
    
    textField_Password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mật khẩu" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
    
    textField_PasswordAgain.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nhập lại mật khẩu" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
    
    //set checkbox's statements
    _checkBox1_Checked = false;
    _checkBox2_Checked = false;
    
}

- (IBAction)backLogInView:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)checkBox1OnClick:(id)sender {
    if (_checkBox1_Checked == false) {
        [_button_Checkbox1 setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        _checkBox1_Checked = true;
    }
    else {
        [_button_Checkbox1 setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        _checkBox1_Checked = false;
    }
}

- (IBAction)checkBox2OnClick:(id)sender {
    if (_checkBox2_Checked == false) {
        [_button_Checkbox2 setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        _checkBox2_Checked = true;
    }
    else {
        [_button_Checkbox2 setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        _checkBox2_Checked = false;
    }
}

@end
