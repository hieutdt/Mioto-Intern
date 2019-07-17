//
//  FriendListViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/13/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import <FIRDatabase.h>
#import "FriendListViewController.h"

@interface FriendListViewController ()
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) NSMutableArray *friendArray;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UITableView *tableView_FriendList;


- (void)setShadowSubView: (UIView*) view;

@end

@implementation FriendListViewController
@synthesize friendArray;
@synthesize ref;
@synthesize uid;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShadowSubView:self.topView];
    [self.topView setBackgroundColor:[UIColor colorWithRed:110/255.0f green:146/255.0f blue:174/255.0f alpha:1]];
    
    //get friend list data from Firebase database
    self.friendArray = [[NSMutableArray alloc] init];
    
    ref = [[FIRDatabase database] reference];
    
    [[ref child:@"friend_list"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *rawData = snapshot.value[self->uid];
        
        NSLog(@"Friend raw data = %@", rawData);
        
        NSArray *items = [rawData componentsSeparatedByString:@","];
        self.friendArray = [items copy];
        
        [self->_tableView_FriendList reloadData];
    }];
}

- (void)setShadowSubView: (UIView*) view {
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 5.f;
    view.layer.shadowOffset = CGSizeMake(.0f,2.5f);
    view.layer.shadowRadius = 1.5f;
    view.layer.shadowOpacity = .9f;
    view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    view.backgroundColor = [UIColor whiteColor];
}

///////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSelectionsInTableView: (UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friendArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //get UI widget references
    __block UIImageView *imageAvatar = [[cell contentView] viewWithTag:100];
    __block UILabel *labelName = [[cell contentView] viewWithTag:101];
    __block UILabel *labelEmail = [[cell contentView] viewWithTag:102];
    
    //get data in Index path and set up
    [[ref child:[friendArray objectAtIndex:indexPath.row]] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *name = snapshot.value[@"name"];
        NSString *avaURL = snapshot.value[@"avatar"];
        NSString *email = snapshot.value[@"email"];
        
        labelName.text = name;
        labelEmail.text = email;
        imageAvatar.layer.cornerRadius= imageAvatar.layer.bounds.size.width * .5;
        imageAvatar.layer.masksToBounds = YES;
        imageAvatar.layer.borderWidth = 2;
        
        if (![avaURL isEqual: @"nil"]) {
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:avaURL]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                imageAvatar.image = [UIImage imageWithData:data];
            }];
        }
    }];
    
    return cell;
}

@end
