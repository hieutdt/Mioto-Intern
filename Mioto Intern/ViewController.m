//
//  ViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/2/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "ViewController.h"
#import "TabBarControllerViewController.h"
#import "Mioto_Intern-Swift.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Background;
@property (strong, nonatomic) IBOutlet UITextField *textField_Password;
@property (strong, nonatomic) IBOutlet UITextField *textField_Username;
@property (strong, nonatomic) IBOutlet ZFRippleButton *button_FacebookLogin;
@property (strong, nonatomic) IBOutlet ZFRippleButton *button_Login;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) NSString *uid;

- (IBAction)pushSignUpView:(id)sender;
- (IBAction)logInOnClick:(id)sender;
- (IBAction)facebookLoginOnClick:(id)sender;
- (IBAction)logInButtonTouchDown:(id)sender;
- (IBAction)logInButtonTouchUpOutside:(id)sender;
- (void)showAlertWithTitle:(NSString*) title andDescription: (NSString*) des;

@end

@implementation ViewController

@synthesize imageView_Background;
@synthesize textField_Password;
@synthesize textField_Username;
@synthesize button_FacebookLogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background
    [imageView_Background setImage:[UIImage imageNamed:@"background"]];
    
    
    [textField_Username setBottomBorder];
    [textField_Password setBottomBorder];

    textField_Password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mật khẩu" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
    
    //setting Facebook login button
    button_FacebookLogin.layer.masksToBounds = TRUE;
    button_FacebookLogin.layer.cornerRadius = 10;
    
    [button_FacebookLogin setImage:[UIImage imageNamed:@"icons8-facebook-60"] forState:normal];
    button_FacebookLogin.tintColor = [UIColor whiteColor];
    
    [button_FacebookLogin setRippleOverBounds:YES];
    [button_FacebookLogin setRipplePercent:1.0f];
    [button_FacebookLogin setRippleColor:[UIColor colorWithRed:37/255.0f green:97/255.0f blue:144/255.0f alpha:1]];
    [button_FacebookLogin setRippleBackgroundColor:[UIColor colorWithRed:30/255.0f green:84/255.0f blue:126/255.0f alpha:1]];
    
    //setting Login button
    _button_Login.layer.backgroundColor = [UIColor colorWithRed:76/255.0f green:203/255.0f blue:45/255.0f alpha:1].CGColor;
    
    [_button_Login setRippleOverBounds:YES];
    [_button_Login setRipplePercent:1.0f];
    [_button_Login setRippleColor:[UIColor colorWithRed:42/255.0f green:122/255.0f blue:34/255.0f alpha:1]];
    [_button_Login setRippleBackgroundColor:[UIColor colorWithRed:41/255.0f green:99/255.0f blue:27/255.0f alpha:1]];
}

//Push to Sign Up View controller
- (IBAction)pushSignUpView:(id)sender {
    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
}

//LOG IN CLICK--------------------------------------------------------------
- (IBAction)logInOnClick:(id)sender {
    //check
    if (self.textField_Username.text.length == 0) {
        [self showAlertWithTitle:@"Đăng nhập thất bại" andDescription:@"Tên đăng nhập không được để trống!"];
    }
    else if (self.textField_Password.text.length == 0) {
        [self showAlertWithTitle:@"Đăng nhập thất bại" andDescription:@"Mật khẩu không được để trống!"];
    }
    
    //set up this button to normal state
    self.button_Login.layer.backgroundColor = [UIColor colorWithRed:76/255.0f green:203/255.0f blue:45/255.0f alpha:1].CGColor;
    
    //Email/password auth
    self.ref = [[FIRDatabase database] reference];
    
    [[FIRAuth auth] signInWithEmail:textField_Username.text password:textField_Password.text completion:^(FIRAuthDataResult *_Nullable authData, NSError *_Nullable error) {
        if (error) {
            [self showAlertWithTitle:@"Đăng nhập thất bại!" andDescription:@"Tên đăng nhập hoặc mật khẩu không chính xác"];
        }
        if (authData) {
            self.uid = authData.user.uid;
            [self performSegueWithIdentifier:@"TabBarSegue" sender:self];
        }
    }];
}

//prepare to pass data to Tab bar view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TabBarSegue"]) {
        TabBarControllerViewController *destinationVC = segue.destinationViewController;
        NSLog(@"Source's uid is %@", self.uid);
        destinationVC.uid = self.uid;
    }
}

//Log in with Facebook account --------------------------------------------------------
- (IBAction)facebookLoginOnClick:(id)sender {
    //create login manager
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    //set up Firebase reference
    self.ref = [[FIRDatabase database] reference];
    
    [loginManager logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    
    [loginManager logInWithPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if (error) {
            //Facebook login failed!
            NSLog(@"Process error!");
        }
        else if (result.isCancelled) {
            //Facebook login failed!
            NSLog(@"Process error!");
        }
        else {
            //Facebook login succeed!
            if ([FBSDKAccessToken currentAccessToken]) {
                NSString *accessTokenString = [FBSDKAccessToken.currentAccessToken tokenString];
                FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessTokenString];
                
                //authen with Facebook account!
                //if succeed, Facebook user auto add into Firebase users db
                [[FIRAuth auth] signInWithCredential:credential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                    
                    NSLog(@"Log in to Facebook succeed!");
                }];
                
                //get profile of User and save it to Profile database in Firebase
                [FBSDKProfile loadCurrentProfileWithCompletion:
                 ^(FBSDKProfile *profile, NSError *error) {
                     
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters: @{@"fields":@"id, name, first_name, last_name, picture.type(large), email, gender"}]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                          if (!error) {
                              //get data from result
                              NSLog(@"fetched user:%@", result);
                              NSString *name = result[@"name"];
                              NSString *avatarURL = result[@"picture"][@"data"][@"url"];
                              NSString *email = result[@"email"];
                              NSString *facebookID = result[@"id"];
                              
                              //check this Facebook user in database
                              [[self->_ref child:facebookID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                                  if (![snapshot hasChild:@"email"]) {
                                      //write to Profile table of Firebase database
                                      [[self.ref child:facebookID] setValue:@{@"name": name, @"birth": @"1/1/1900", @"email": email, @"gender": @"Nam", @"avatar": avatarURL, @"phone": @"000000000"}];
                                  }
                              }];
                              
                              //set UID to pass to Profile view controller
                              self.uid = [facebookID copy];
                              
                              //open Profile view controller
                              [self performSegueWithIdentifier:@"TabBarSegue" sender:self];
                          }
                      }];
                 }];
            }
        }
    }];
}

- (IBAction)logInButtonTouchDown:(id)sender {
    self.button_Login.layer.backgroundColor = [UIColor colorWithRed:44/255.0f green:142/255.0f blue:21/255.0f alpha:1].CGColor;
}

- (IBAction)logInButtonTouchUpOutside:(id)sender {
    self.button_Login.layer.backgroundColor = [UIColor colorWithRed:76/255.0f green:203/255.0f blue:45/255.0f alpha:1].CGColor;
}

- (void)showAlertWithTitle:(NSString*) title andDescription: (NSString*) des {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:des preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //nothing
                                }];
    
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
