//
//  SignUpViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/4/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "SignUpViewController.h"
#import "UITextField.h"
#import "Mioto_Intern-Swift.h"

@interface SignUpViewController()

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Background;
@property (strong, nonatomic) IBOutlet UITextField *textField_Name;
@property (strong, nonatomic) IBOutlet UITextField *textField_EmailOrPhone;
@property (strong, nonatomic) IBOutlet UITextField *textField_Password;
@property (strong, nonatomic) IBOutlet UITextField *textField_PasswordAgain;
@property (strong, nonatomic) IBOutlet UIButton *button_Checkbox1;
@property (strong, nonatomic) IBOutlet UIButton *button_Checkbox2;
@property (strong, nonatomic) IBOutlet ZFRippleButton *button_SignUp;
@property (strong, nonatomic) IBOutlet ZFRippleButton *button_Back;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property bool checkBox1_Checked;
@property bool checkBox2_Checked;

- (IBAction)backLogInView:(id)sender;
- (IBAction)checkBox1OnClick:(id)sender;
- (IBAction)checkBox2OnClick:(id)sender;
- (IBAction)signUpOnClick:(id)sender;



@end

@implementation SignUpViewController

@synthesize imageView_Background;
@synthesize textField_Name;
@synthesize textField_EmailOrPhone;
@synthesize textField_Password;
@synthesize textField_PasswordAgain;
@synthesize button_SignUp;
@synthesize button_Back;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //set background
    [imageView_Background setImage:[UIImage imageNamed:@"background"]];
    
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
    
    //set sign up button
    [button_SignUp setRippleOverBounds:NO];
    [button_SignUp setRipplePercent:1.0f];
    [button_SignUp setRippleColor:[UIColor colorWithRed:42/255.0f green:122/255.0f blue:34/255.0f alpha:1]];
    [button_SignUp setRippleBackgroundColor:[UIColor colorWithRed:41/255.0f green:99/255.0f blue:27/255.0f alpha:1]];
    [button_SignUp shadowRippleEnable];
    
    [button_Back setRippleOverBounds:YES];
    [button_Back setRipplePercent:1.0f];
    [button_Back setRippleColor:[UIColor colorWithRed:234/255.0f green:242/255.0f blue:248/255.0f alpha:1]];
    [button_Back setRippleBackgroundColor:[UIColor clearColor]];
    
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

//Sign Up new User --------------------------------------------------------------------
- (IBAction)signUpOnClick:(id)sender {
    if (textField_EmailOrPhone.text.length == 0) {
        return;
    }
    
    //Check password
    if (![textField_Password.text isEqualToString:textField_PasswordAgain.text]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Mật khẩu không trùng khớp" message:@"Vui lòng kiểm tra và thử lại!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //nothing
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    self.ref = [[FIRDatabase database] reference];
    
    if (self.ref != nil) {
        [[FIRAuth auth] createUserWithEmail:textField_EmailOrPhone.text password:textField_Password.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            
            //add new user to Info table
            [[self.ref child:authResult.user.uid] setValue:@{@"name": self->textField_Name.text, @"birth": @"1/1/1900", @"email": self->textField_EmailOrPhone.text, @"gender": @"Nam", @"avatar": @"nil", @"phone": @"000000000"}];
            
            
            [self dismissViewControllerAnimated:true completion:nil];
        }];
    } else {
        NSLog(@"can't reference");
    }
}

@end
