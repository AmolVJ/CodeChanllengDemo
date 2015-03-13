//
//  OpenImageViewController.m
//  DropboxApp
//
//  Created by Amol Jadhav on 13/03/15.
//  Copyright (c) 2015 Amol Jadhav. All rights reserved.
//

#import "OpenImageViewController.h"
#import <Social/Social.h>

@interface OpenImageViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *downloadedImage;
- (IBAction)shareOnFacebook:(id)sender;

@end

@implementation OpenImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.downloadedImage setImage:[UIImage imageWithContentsOfFile:self.filePath]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareOnFacebook:(id)sender {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller addImage:[UIImage imageWithContentsOfFile:self.filePath]];
        [self presentViewController:controller animated:YES completion:Nil];
}

@end
