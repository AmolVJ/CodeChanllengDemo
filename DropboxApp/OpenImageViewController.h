//
//  OpenImageViewController.h
//  DropboxApp
//
//  Created by Amol Jadhav on 13/03/15.
//  Copyright (c) 2015 Amol Jadhav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenImageViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIImageView *downloadedImage;
@property (nonatomic, strong) NSString *filePath;
@end
