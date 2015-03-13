//
//  DropboxIntegrationViewController.h
//  DropboxApp
//
//  Created by Amol Jadhav on 12/03/15.
//  Copyright (c) 2015 Amol Jadhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxIntegrationViewController : UIViewController <UIPopoverControllerDelegate, UIImagePickerControllerDelegate,DBRestClientDelegate, UINavigationControllerDelegate>
{
    NSString *viewName;
}

@property (nonatomic, strong) DBRestClient *restClient;
-(IBAction)btnUploadFilePress:(id)sender;
-(IBAction)btnDownloadFilePress:(id)sender;
-(IBAction)btnGpsDataPress:(id)sender;

@end
