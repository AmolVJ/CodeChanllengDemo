//
//  DropboxIntegrationViewController.m
//  DropboxApp
//
//  Created by Amol Jadhav on 12/03/15.
//  Copyright (c) 2015 Amol Jadhav. All rights reserved.
//

#import "DropboxIntegrationViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
@interface DropboxIntegrationViewController ()
{
    BOOL isGpsDataButtonPressed;
}
@end

@implementation DropboxIntegrationViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxLoginDone) name:@"OPEN_DROPBOX_VIEW" object:nil];
}

-(void)dropboxLoginDone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"User logged in successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
}

//#pragma mark - Dropbox Methods
//- (DBRestClient *)restClient
//{
//    if (self.restClient == nil) {
//        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//        self.restClient.delegate = self;
//    }
//    return self.restClient;
//}


#pragma mark - Action Methods
-(IBAction)btnUploadFilePress:(id)sender
{
    isGpsDataButtonPressed = false;
    if (![[DBSession sharedSession] isLinked]) {
        viewName = @"OpenUploadFileView";
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(IBAction)btnDownloadFilePress:(id)sender
{
    if (![[DBSession sharedSession] isLinked]) {
        viewName = @"OpenDownloadFileView";
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self performSegueWithIdentifier:@"OpenDownloadFileView" sender:self];
    }
}

-(IBAction)btnGpsDataPress:(id)sender {
    isGpsDataButtonPressed = true;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (isGpsDataButtonPressed) {
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
                CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
                [self showAlertWithMessage:[NSString stringWithFormat:@"%@",location]];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failureBlock:^(NSError *error) {
                [self showAlertWithMessage:[NSString stringWithFormat:@"%@",error]];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImagePNGRepresentation(image);
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
        NSString *fileName = @"myImage.png";
        NSString *tempDir = NSTemporaryDirectory();
        NSString *imagePath = [tempDir stringByAppendingPathComponent:fileName];
        [imageData writeToFile:imagePath atomically:YES];
        [self.restClient uploadFile:@"upload.png" toPath:@"/" withParentRev:nil fromPath:imagePath];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - DBRestClientDelegate Methods for Upload Data
-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlertWithMessage:@"File uploaded successfully."];
}

-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlertWithMessage:[error localizedDescription]];
}

#pragma mark - Show Alert message

- (void)showAlertWithMessage:(NSString *)alertMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(alertMessage, @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
    [alertView show];
}


@end