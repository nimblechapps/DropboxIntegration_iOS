//
//  AppDelegate.h
//  ZTestAppDemo
//
//  Created by Zaki P Laliwala on 22/08/17.
//  Copyright © 2017 Zaki P Laliwala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,DBSessionDelegate, DBNetworkRequestDelegate>
{
    NSString *UserId;
}
@property (strong, nonatomic) UIWindow *window;


@end

