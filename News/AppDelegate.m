//
//  AppDelegate.m
//  News
//
//  Created by Dmitriy Remezov on 05.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "EXConsts.h"
#import "DateData.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    EXFontName *fintName = [EXFontNames() objectAtIndex:4];
    NSNumber *size = [EXFontSizes() objectAtIndex:4];
    
    NSMutableDictionary *settingsDef = [NSMutableDictionary dictionary];
    [settingsDef setObject:fintName.fontName forKey:EXSettingFontName];
    [settingsDef setObject:size forKey:EXSettingFontSize];
    [userDefaults registerDefaults:settingsDef];
    [userDefaults synchronize];
    
    
    
    BOOL HasCahe = [[DateData sharedInstance] HasCahedRssFeed];
    if (HasCahe)
    {
        UIViewController *rootViewController = self.window.rootViewController;
        UIStoryboard *storyboard = rootViewController.storyboard;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"InitStoryboard"];
        self.window.rootViewController = navigationController;
    }else
    { [[DateData sharedInstance]fetchRssFeedCashedBlock:Nil successBlock:^(NSArray *result)
        {
            UIViewController *rootViewController = self.window.rootViewController;
            UIStoryboard *storyboard = rootViewController.storyboard;
            UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"InitStoryboard"];
            self.window.rootViewController = navigationController;        
        }
        failureBlock:^(NSError *error)
        {
            NSLog(@"%@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        
        }];
    }    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application{}
- (void)applicationDidEnterBackground:(UIApplication *)application{}
- (void)applicationWillEnterForeground:(UIApplication *)application{}
- (void)applicationDidBecomeActive:(UIApplication *)application{}
- (void)applicationWillTerminate:(UIApplication *)application{}

@end
