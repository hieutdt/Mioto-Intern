//
//  ProfileViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/12/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import <FIRDatabase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ProfileViewController ()

//Properties---------------------------------------------------------
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Avatar;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Background;
@property (strong, nonatomic) IBOutlet UILabel *label_UID;
@property (strong, nonatomic) IBOutlet UILabel *label_Name;
@property (strong, nonatomic) IBOutlet UILabel *label_StartDate;
@property (strong, nonatomic) IBOutlet UILabel *label_Birth;
@property (strong, nonatomic) IBOutlet UILabel *label_Gender;
@property (strong, nonatomic) IBOutlet UILabel *label_Email;

@property (strong, nonatomic) IBOutlet UIButton *button_Edit;
@property (strong, nonatomic) IBOutlet UITabBarItem *TabBarItem_Profile;

@property (strong, nonatomic) IBOutlet UIImageView *subViewName;
@property (strong, nonatomic) IBOutlet UIImageView *subViewBirth;
@property (strong, nonatomic) IBOutlet UIView *subviewContact;
@property (strong, nonatomic) IBOutlet UILabel *label_Phonenumber;

//Methods------------------------------------------------------------
- (IBAction)backButtonOnClick:(id)sender;
- (void)setShadowSubImageView: (UIView*) imageView;
- (IBAction)editButtonOnClick:(id)sender;
- (IBAction)editButtonTouchDown:(id)sender;
- (IBAction)editButtonTouchCancel:(id)sender;

@end

// IMPLEMENT /////////////////////////////////////////////////////////////
@implementation ProfileViewController
@synthesize ref;
@synthesize uid;
@synthesize imageView_Avatar;
@synthesize imageView_Background;
@synthesize TabBarItem_Profile;

//Even if you get back from another screen, this function will still be called
- (void)viewDidAppear:(BOOL)animated {
    //get data from Firebase database with UID
    NSLog(@"This UID = %@", self.uid);
    NSLog(@"View Will Appear called!");
    
    [[ref child:self.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *name = snapshot.value[@"name"];
        NSString *email = snapshot.value[@"email"];
        NSString *avatarURL = snapshot.value[@"avatar"];
        NSString *gender = snapshot.value[@"gender"];
        NSString *birth = snapshot.value[@"birth"];
        NSString *phoneNumber = snapshot.value[@"phone"];
        
        if (![avatarURL isEqual: @"nil"]) {
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:avatarURL]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                self.imageView_Avatar.image = [UIImage imageWithData:data];
            }];
        }
        
        //set user's name label
        [self.label_Name setText:name];
        [self.label_Birth setText:birth];
        [self.label_Gender setText:gender];
        [self.label_Email setText:email];
        [self.label_Phonenumber setText:phoneNumber];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
    NSLog(@"This UID is: %@", self.uid);
    
    
    //setting avatar image view
    imageView_Avatar.layer.cornerRadius= imageView_Avatar.layer.bounds.size.width * .5;
    imageView_Avatar.layer.masksToBounds = YES;
    imageView_Avatar.layer.backgroundColor = [UIColor blackColor].CGColor;
    imageView_Avatar.layer.borderWidth = 2;
    
    //setting cover photo
    [imageView_Background setImage:[UIImage imageNamed:@"oto_background"]];
 
    //setting name subview
    [self setShadowSubImageView:_subViewName];
    [self setShadowSubImageView:_subViewBirth];
    [self setShadowSubImageView:_subviewContact];
    
    //setting Edit butotn
    //[[self.button_Edit imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.button_Edit setBackgroundColor:[UIColor whiteColor]];
    self.button_Edit.layer.cornerRadius = 10;
    self.button_Edit.layer.masksToBounds = YES;
    self.button_Edit.layer.borderWidth = 2;
    self.button_Edit.layer.borderColor = [UIColor colorWithRed:41/255.0f green:146/255.0f blue:185/255.0f alpha:1].CGColor;
    [self.button_Edit setTitleColor:[UIColor colorWithRed:41/255.0f green:146/255.0f blue:185/255.0f alpha:1] forState:UIControlStateNormal];
}

- (IBAction)backButtonOnClick:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Dang xuat chua thanh cong!");
    }
    else {
        NSLog(@"Dang xuat thanh cong!");
    }
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)setShadowSubImageView: (UIView*) imageView {
    imageView.layer.masksToBounds = NO;
    imageView.layer.cornerRadius = 5.f;
    imageView.layer.shadowOffset = CGSizeMake(.0f,2.5f);
    imageView.layer.shadowRadius = 1.5f;
    imageView.layer.shadowOpacity = .9f;
    imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
    imageView.backgroundColor = [UIColor whiteColor];
}


// Button edit handlers //////////////////////////////////////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditProfileSegue"]) {
        EditProfileViewController *destinationVC = segue.destinationViewController;
        destinationVC.uid = self.uid;
    }
}

- (IBAction)editButtonOnClick:(id)sender {
    //set that button to normal state UI
    [self.button_Edit setBackgroundColor:[UIColor whiteColor]];
    self.button_Edit.layer.borderColor = [UIColor colorWithRed:41/255.0f green:146/255.0f blue:185/255.0f alpha:1].CGColor;
    [self.button_Edit setTitleColor:[UIColor colorWithRed:41/255.0f green:146/255.0f blue:185/255.0f alpha:1] forState:UIControlStateNormal];
    
    //go to Edit profile view controller
    [self performSegueWithIdentifier:@"EditProfileSegue" sender:self];
}

- (IBAction)editButtonTouchDown:(id)sender {
    [self.button_Edit setBackgroundColor:[UIColor colorWithRed:41/255.0f green:146/255.0f blue:185/255.0f alpha:1]];
    self.button_Edit.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.button_Edit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)editButtonTouchCancel:(id)sender {
    [self.button_Edit setBackgroundColor:[UIColor whiteColor]];
    self.button_Edit.layer.borderColor = [UIColor colorWithRed:41/255.0f green:146/255.0f blue:185/255.0f alpha:1].CGColor;
    [self.button_Edit setTitleColor:[UIColor colorWithRed:41/255.0f green:146/255.0f blue:185/255.0f alpha:1] forState:UIControlStateNormal];
}

@end
