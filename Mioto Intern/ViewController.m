//
//  ViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/2/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "ViewController.h"
#import "UITextField.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Background;
@property (strong, nonatomic) IBOutlet UITextField *textField_Password;
@property (strong, nonatomic) IBOutlet UITextField *textField_Username;

- (IBAction)pushSignUpView:(id)sender;

@end



@implementation ViewController

@synthesize imageView_Background;
@synthesize textField_Password;
@synthesize textField_Username;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [imageView_Background setImage:[UIImage imageNamed:@"background_authentication_screen.jpg"]];
    
    
    [textField_Username setBottomBorder];
    [textField_Password setBottomBorder];

    textField_Password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mật khẩu" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
}

//Push to Sign Up View controller
- (IBAction)pushSignUpView:(id)sender {
    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
}
@end
