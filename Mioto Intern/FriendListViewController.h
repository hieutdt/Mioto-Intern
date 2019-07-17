//
//  FriendListViewController.h
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/13/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *uid;

@end

NS_ASSUME_NONNULL_END
