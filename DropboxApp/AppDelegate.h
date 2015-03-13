//
//  AppDelegate.h
//  DropboxApp
//
//  Created by Amol Jadhav on 12/03/15.
//  Copyright (c) 2015 Amol Jadhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, DBSessionDelegate, DBNetworkRequestDelegate>
{
    NSString *relinkUserId;
}

@property (strong, nonatomic) UIWindow *window;


@end

