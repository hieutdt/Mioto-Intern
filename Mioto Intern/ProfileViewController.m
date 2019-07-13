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

- (IBAction)backButtonOnClick:(id)sender;

@end

@implementation ProfileViewController
@synthesize ref;
@synthesize uid;
@synthesize imageView_Avatar;
@synthesize imageView_Background;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
    NSLog(@"This UID is: %@", self.uid);
    
    //get data from Firebase database with UID
    [[ref child:self.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *name = snapshot.value[@"name"];
        NSString *email = snapshot.value[@"email"];
        NSString *avatarURL = snapshot.value[@"avatar"];
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:avatarURL]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            self.imageView_Avatar.image = [UIImage imageWithData:data];
        }];
    }];
    
    //setting round avatar
    imageView_Avatar.layer.cornerRadius= imageView_Avatar.layer.bounds.size.width * .5;
    imageView_Avatar.layer.masksToBounds = YES;
    
    //setting cover photo
    
}

- (IBAction)backButtonOnClick:(id)sender {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
