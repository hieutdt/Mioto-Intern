//
//  AppDelegate.h
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/2/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

@end

