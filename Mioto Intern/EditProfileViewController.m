//
//  EditProfileViewController.m
//  Mioto Intern
//
//  Created by Trần Đình Tôn Hiếu on 7/13/19.
//  Copyright © 2019 Trần Đình Tôn Hiếu. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)chooseImageOnClick:(id)sender;

@property (nonatomic) NSString *avatarImagePath;
@property (nonatomic) UIImage *avatarImage;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

@end
