//
//  ProfileViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/12/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "ProfileViewController.h"
#import <FIRDatabase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ProfileViewController ()

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
@property (strong, nonatomic) IBOutlet UIImageView *subViewContact;

- (IBAction)backButtonOnClick:(id)sender;
- (void)setShadowSubImageView: (UIImageView*) imageView;

@end

@implementation ProfileViewController
@synthesize ref;
@synthesize uid;
@synthesize imageView_Avatar;
@synthesize imageView_Background;
@synthesize TabBarItem_Profile;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
    NSLog(@"This UID is: %@", self.uid);
    
    //get data from Firebase database with UID
    [[ref child:self.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *name = snapshot.value[@"name"];
        NSString *email = snapshot.value[@"email"];
        NSString *avatarURL = snapshot.value[@"avatar"];
        NSString *gender = snapshot.value[@"gender"];   
        NSString *birth = snapshot.value[@"birth"];
        
        if (![avatarURL  isEqual: @"nil"]) {
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:avatarURL]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                self.imageView_Avatar.image = [UIImage imageWithData:data];
            }];
        }
        
        //set user's name label
        [self.label_Name setText:name];
        [self.label_Birth setText:birth];
        [self.label_Gender setText:gender];
        [self.label_Email setText:email];
    }];
    
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
    [self setShadowSubImageView:_subViewContact];
    
    //setting Edit butotn
    //[[self.button_Edit imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.button_Edit setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.button_Edit setBackgroundColor:[UIColor whiteColor]];
    self.button_Edit.layer.cornerRadius = _button_Edit.layer.bounds.size.width * 0.5;
    self.button_Edit.layer.masksToBounds = YES;
    
    //[TabBarItem_Profile setImage:[UIImage imageNamed:@"user"]];
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

- (void)setShadowSubImageView: (UIImageView*) imageView {
    imageView.layer.masksToBounds = NO;
    imageView.layer.cornerRadius = 5.f;
    imageView.layer.shadowOffset = CGSizeMake(.0f,2.5f);
    imageView.layer.shadowRadius = 1.5f;
    imageView.layer.shadowOpacity = .9f;
    imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
    imageView.backgroundColor = [UIColor whiteColor];
}

@end
