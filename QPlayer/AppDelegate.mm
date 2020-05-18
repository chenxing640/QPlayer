//
//  AppDelegate.m
//
//  Created by dyf on 2017/6/29.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "AppDelegate.h"
#import <ZFPlayer/ZFPlayer.h>
#import "DYFNetworkSniffer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self extendSplashDisplayTime];
    [self controlLog];
    [self setupConfiguration];
    
    if (!DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer start];
    }
    
    return YES;
}

- (void)extendSplashDisplayTime {
    // sleep 2 seconds.
    [NSThread sleepForTimeInterval:2];
}

- (void)controlLog {
#ifdef DEBUG
    [ZFPlayerLogManager setLogEnable:YES];
#else
    [ZFPlayerLogManager setLogEnable:NO];
#endif
}

- (void)setupConfiguration {
    BOOL result = [QPlayerExtractFlag(kWriteThemeStyleFlagOnceOnly) boolValue];
    
    if (!result) {
        QPlayerSaveFlag(kThemeStyleOnOff, [NSNumber numberWithBool:YES]);
        QPlayerSaveFlag(kWriteThemeStyleFlagOnceOnly, [NSNumber numberWithBool:YES]);
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    QPlayerSavePlaying(NO);
    if (DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer stop];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (!DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer start];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    QPlayerSavePlaying(NO);
    if (DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer stop];
    }
}

@end
