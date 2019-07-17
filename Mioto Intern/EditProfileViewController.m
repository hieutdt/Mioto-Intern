//
//  EditProfileViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/13/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "EditProfileViewController.h"
#import <FIRDatabase.h>
#import <FIRStorage.h>
#import <FirebaseStorage/FirebaseStorage.h>
#import "Mioto_Intern-Swift.h"

@interface EditProfileViewController ()

//PROPERTIES -----------------------------------------------------------
@property (nonatomic) NSString *avatarImagePath;
@property (nonatomic) UIImage *avatarImage;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *avatarURL;
@property (nonatomic) NSString *birth;
@property (nonatomic) NSString *phone;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorageReference *storageRef;

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
@property (strong, nonatomic) IBOutlet UIView *view_Contact;
@property (strong, nonatomic) IBOutlet UILabel *label_Email;
@property (strong, nonatomic) IBOutlet ZFRippleButton *button_Save;
@property (strong, nonatomic) IBOutlet UITextField *textField_PhoneNumber;


// METHODS -------------------------------------------------------------
- (IBAction)buttonSaveTapped:(id)sender;
- (IBAction)buttonMaleTapped:(id)sender;
- (IBAction)buttonFemaleTapped:(id)sender;
- (void)setShadowSubView: (UIView*) view;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)changeAvatarTapped:(id)sender;

@end


// IMPLEMENTATIONS /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

@implementation EditProfileViewController
@synthesize ref;

// SET UP UI -----------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"UID = %@", self.uid);
    //set up views
    [self setShadowSubView:_view_Name];
    [self setShadowSubView:_view_Birth];
    [self setShadowSubView:_view_Contact];
    
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
    
    //set up save button
    self.button_Save.layer.masksToBounds = NO;
    self.button_Save.layer.cornerRadius = 5.f;
    self.button_Save.layer.shadowOffset = CGSizeMake(.0f,2.5f);
    self.button_Save.layer.shadowRadius = 1.5f;
    self.button_Save.layer.shadowOpacity = .9f;
    self.button_Save.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.button_Save.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.button_Save.bounds].CGPath;
    
    [_button_Save setRippleOverBounds:NO];
    [_button_Save setRipplePercent:1.0f];
    [_button_Save setRippleColor:[UIColor colorWithRed:42/255.0f green:122/255.0f blue:34/255.0f alpha:1]];
    [_button_Save setRippleBackgroundColor:[UIColor colorWithRed:41/255.0f green:99/255.0f blue:27/255.0f alpha:1]];
    [_button_Save shadowRippleEnable];
    
    [[ref child:self.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self->_name = [snapshot.value[@"name"] copy];
        self->_email = [snapshot.value[@"email"] copy];
        self->_avatarURL = [snapshot.value[@"avatar"] copy];
        self->_gender = [snapshot.value[@"gender"] copy];
        self->_birth = [snapshot.value[@"birth"] copy];
        self->_phone = [snapshot.value[@"phone"] copy];
        
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
        
        //set up email label
        [self.label_Email setText:self->_email];
        
        //set up phonenumber text field
        [self.textField_PhoneNumber setText:self->_phone];
    }];
}

//Save data -------
- (IBAction)buttonSaveTapped:(id)sender {
    NSString *fileName = [NSString stringWithFormat:@"%@.png", self.uid];
    _storageRef = [[[FIRStorage storage] reference] child:fileName];

    //set up image data
    UIImage *avatarData = UIImagePNGRepresentation(self.button_Avatar.currentBackgroundImage);
    
    [_storageRef putData:avatarData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error);
        }
        else {
            [self->_storageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError* _Nullable error) {
                //get image url in Firebase storage
                NSString *imageUrl = URL.absoluteString;
                NSLog(@"URL = %@", imageUrl);
                
                //update data in database
                NSString *updateBirth = [NSString stringWithFormat:@"%@/%@/%@", self.textField_Day.text, self.textField_Month.text, self.textField_Year.text];
                
                [[self.ref child:self.uid] setValue:@{@"name": self.textField_Name.text, @"birth": updateBirth, @"email": self.label_Email.text, @"phone": self->_textField_PhoneNumber.text, @"gender": self.gender, @"avatar": imageUrl}];
            }];
            
            //Send success message and dismiss this view
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cập nhật thành công" message:@"Vui lòng kiểm tra lại thông tin!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [self dismissViewControllerAnimated:true completion:nil];
                                        }];
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

//-----------------

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


//UPLOAD AVATAR -------------------------------------------------------------
- (IBAction)changeAvatarTapped:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion: ^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.button_Avatar setBackgroundImage: [info objectForKey:@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal] ;
    self.avatarImagePath = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSLog(@"Image path is: %@", _avatarImagePath);
    
    [picker dismissModalViewControllerAnimated:YES];
}

@end
