//
//  EditProfileViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/13/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "EditProfileViewController.h"
#import <FIRDatabase.h>

@interface EditProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)chooseImageOnClick:(id)sender;

@property (nonatomic) NSString *avatarImagePath;
@property (nonatomic) UIImage *avatarImage;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *avatarURL;
@property (nonatomic) NSString *birth;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (strong, nonatomic) IBOutlet UITextField *textField_Day;
@property (strong, nonatomic) IBOutlet UITextField *textField_Month;
@property (strong, nonatomic) IBOutlet UITextField *textField_Year;
@property (strong, nonatomic) IBOutlet UIButton *button_Male;
@property (strong, nonatomic) IBOutlet UIButton *button_Female;
@property (strong, nonatomic) IBOutlet UIButton *button_Avatar;
@property (strong, nonatomic) IBOutlet UITextField *textField_Name;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Background;
@property (strong, nonatomic) IBOutlet UIView *view_Name;
@property (strong, nonatomic) IBOutlet UIView *view_Birth;


- (IBAction)buttonMaleTapped:(id)sender;
- (IBAction)buttonFemaleTapped:(id)sender;
- (void)setShadowSubView: (UIView*) view;
- (IBAction)backButtonTapped:(id)sender;

@end

@implementation EditProfileViewController
@synthesize ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"UID = %@", self.uid);
    //set up views
    [self setShadowSubView:_view_Name];
    [self setShadowSubView:_view_Birth];
    
    //set up background
    [_imageView_Background setImage:[UIImage imageNamed:@"oto_background"]];
    
    //set up avatar button
    _button_Avatar.layer.masksToBounds = YES;
    _button_Avatar.layer.cornerRadius = _button_Avatar.layer.bounds.size.width * .5;
    _button_Avatar.layer.borderWidth = 2;
    _button_Avatar.layer.borderColor = [UIColor blackColor].CGColor;
    
    //set up gender buttons
    _button_Male.layer.masksToBounds = YES;
    _button_Male.layer.cornerRadius = 10;
    _button_Male.layer.borderColor = [UIColor blackColor].CGColor;
    _button_Male.layer.borderWidth = 2;
    
    _button_Female.layer.masksToBounds = YES;
    _button_Female.layer.cornerRadius = 10;
    _button_Female.layer.borderColor = [UIColor blackColor].CGColor;
    _button_Female.layer.borderWidth = 2;
    
    //get data from database
    self.ref = [[FIRDatabase database] reference];
    
    [[ref child:self.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self->_name = [snapshot.value[@"name"] copy];
        self->_email = [snapshot.value[@"email"] copy];
        self->_avatarURL = [snapshot.value[@"avatar"] copy];
        self->_gender = [snapshot.value[@"gender"] copy];
        self->_birth = [snapshot.value[@"birth"] copy];
        
        //set up gender buttons here
        if ([self->_gender isEqualToString:@"Nam"]) {
            [self->_button_Male setBackgroundColor:[UIColor colorWithRed:51/255.0f green:176/255.0f blue:113/255.0f alpha:1]];
            [self->_button_Female setBackgroundColor:[UIColor whiteColor]];
            self->_button_Female.layer.borderColor = [UIColor lightGrayColor].CGColor;
        } else {
            [self->_button_Female setBackgroundColor:[UIColor colorWithRed:51/255.0f green:176/255.0f blue:113/255.0f alpha:1]];
            [self->_button_Male setBackgroundColor:[UIColor whiteColor]];
            self->_button_Male.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
        
        //set up avatar button
        NSLog(@"ava url = %@", self->_avatarURL);
        if (![self->_avatarURL isEqual: @"nil"]) {
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self->_avatarURL]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                [self.button_Avatar setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            }];
        }
        
        //set up date of birth
        int indexs[2];
        int count = 0;
        for (int i = 0; i < self->_birth.length; i++) {
            if ([self.birth characterAtIndex:i] == '/') {
                indexs[count++] = i;
            }
        }
        
        count = 0;
        [self.textField_Day setText:[self->_birth substringToIndex:indexs[0]]];
        [self.textField_Month setText:[self->_birth substringWithRange:NSMakeRange(indexs[0] + 1, indexs[1] - indexs[0] - 1)]];
        [self.textField_Year setText:[self->_birth substringFromIndex:indexs[1] + 1]];
        
        //set up name
        [self.textField_Name setText:self->_name];
    }];
}

- (IBAction)chooseImageOnClick:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion: ^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    
    
    self.avatarImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.avatarImagePath = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSLog(@"Image path is: %@", _avatarImagePath);
}

- (IBAction)buttonMaleTapped:(id)sender {
    [self->_button_Male setBackgroundColor:[UIColor colorWithRed:51/255.0f green:176/255.0f blue:113/255.0f alpha:1]];
    self.button_Male.layer.borderColor = [UIColor blackColor].CGColor;
    [self->_button_Female setBackgroundColor:[UIColor whiteColor]];
    self->_button_Female.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.gender = @"Nam";
}

- (IBAction)buttonFemaleTapped:(id)sender {
    [self->_button_Female setBackgroundColor:[UIColor colorWithRed:51/255.0f green:176/255.0f blue:113/255.0f alpha:1]];
    self.button_Female.layer.borderColor = [UIColor blackColor].CGColor;
    [self->_button_Male setBackgroundColor:[UIColor whiteColor]];
    self->_button_Male.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.gender = @"Nữ";
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

- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
