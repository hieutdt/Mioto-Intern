//
//  ViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/2/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "ViewController.h"
#import "ProfileViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Background;
@property (strong, nonatomic) IBOutlet UITextField *textField_Password;
@property (strong, nonatomic) IBOutlet UITextField *textField_Username;
@property (strong, nonatomic) IBOutlet UIButton *button_FacebookLogin;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) NSString *uid;

- (IBAction)pushSignUpView:(id)sender;
- (IBAction)logInOnClick:(id)sender;
- (IBAction)facebookLoginOnClick:(id)sender;

@end

@implementation ViewController

@synthesize imageView_Background;
@synthesize textField_Password;
@synthesize textField_Username;
@synthesize button_FacebookLogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [imageView_Background setImage:[UIImage imageNamed:@"background_authentication_screen.jpg"]];
    
    
    [textField_Username setBottomBorder];
    [textField_Password setBottomBorder];

    textField_Password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mật khẩu" attributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}];
    
    //setting Facebook login button
    button_FacebookLogin.layer.masksToBounds = TRUE;
    button_FacebookLogin.layer.cornerRadius = 10;
    
    [button_FacebookLogin setImage:[UIImage imageNamed:@"icons8-facebook-60"] forState:normal];
    button_FacebookLogin.tintColor = [UIColor whiteColor];
}

//Push to Sign Up View controller
- (IBAction)pushSignUpView:(id)sender {
    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
}

- (IBAction)logInOnClick:(id)sender {
    //Email/password auth
    self.ref = [[FIRDatabase database] reference];
    
    [[FIRAuth auth] signInWithEmail:textField_Username.text password:textField_Password.text completion:^(FIRAuthDataResult *_Nullable authData, NSError *_Nullable error) {
        if (authData) {
            [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
        }
    }];
}

//prepare to pass data to Profile view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProfileSegue"]) {
        ProfileViewController *destinationVC = segue.destinationViewController;
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
                     
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters: @{@"fields":@"id, name, first_name, last_name, picture.type(large), email, gender, cover.type(large)"}]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                          if (!error) {
                              //get data from result
                              NSLog(@"fetched user:%@", result);
                              NSString *name = result[@"name"];
                              NSString *avatarURL = result[@"picture"][@"data"][@"url"];
                              NSString *email = result[@"email"];
                              NSString *facebookID = result[@"id"];
                              
                              
                              
                              //write to Profile table of Firebase database
                              [[self.ref child:facebookID] setValue:@{@"name": name, @"birth": @"1/1/1900", @"email": email, @"gender:": @"Nam", @"avatar": avatarURL}];
                              
                              //set UID to pass to Profile view controller
                              self.uid = [facebookID copy];
                              
                              //open Profile view controller
                              [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
                          }
                      }];
                 }];
                
                //sign out after
                NSError *signOutError;
                BOOL status = [[FIRAuth auth] signOut:&signOutError];
                if (!status) {
                    NSLog(@"Error signing out!");
                    return;
                }
            }
        }
    }];
}

@end
