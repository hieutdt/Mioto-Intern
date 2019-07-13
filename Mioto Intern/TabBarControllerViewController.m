//
//  TabBarControllerViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/13/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "TabBarControllerViewController.h"
#import "ProfileViewController.h"

@interface TabBarControllerViewController ()

@end

@implementation TabBarControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ProfileViewController *profileVC = (ProfileViewController *) [self.viewControllers objectAtIndex:0];
    profileVC.uid = self.uid;
}

/*- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    ProfileViewController *controllerB = (ProfileViewController *) [tabBarController.viewControllers objectAtIndex:0];
    
    controllerB.uid = self.uid;
}*/

@end
