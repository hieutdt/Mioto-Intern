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

- (IBAction)backButtonOnClick:(id)sender;

@end

@implementation ProfileViewController
@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
    [[ref child:@"trandinhtonhieu2"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
    }];
}

- (IBAction)backButtonOnClick:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
