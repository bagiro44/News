//
//  AppDelegate.m
//  News
//
//  Created by Dmitriy Remezov on 05.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "AppDelegate.h"
#import "RSSParser.h"
#import "ViewController.h"
#import "EXConsts.h"
#import "FMDatabase+SharedInstance.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *const kDataBaseFileName = @"rss.sqlite";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dataBasePath = [documentDirectory stringByAppendingPathComponent:kDataBaseFileName];
    
    if (![fileManager fileExistsAtPath:dataBasePath]) {
        NSString *defaultDataBasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDataBaseFileName];
        [fileManager copyItemAtPath:defaultDataBasePath toPath:dataBasePath error:nil];
    }
    
    FMDatabase *database = [FMDatabase databaseWithPath:dataBasePath];
    if ([database open])
    {
        database = nil;
        NSLog(@"BAAD");
    }
    
    NSInteger rowsCount = 0;
    [FMDatabase setSharedInstance:database]; 
    FMResultSet *result = [database executeQuery:@"select count(*) from rss"];
    if ([result next])
    {
        rowsCount = [result intForColumn:0];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    EXFontName *fintName = [EXFontNames() objectAtIndex:0];
    NSNumber *size = [EXFontSizes() objectAtIndex:4];
    
    NSMutableDictionary *settingsDef = [NSMutableDictionary dictionary];
    [settingsDef setObject:fintName.fontName forKey:EXSettingFontName];
    [settingsDef setObject:size forKey:EXSettingFontSize];
    [userDefaults registerDefaults:settingsDef];
    [userDefaults synchronize];
    
    
    NSURL *url = [NSURL URLWithString:@"http://itdox.ru/feed/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url]; 
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
        FMDatabase *database = [FMDatabase sharedInstance];
        for (RSSItem *item in feedItems)
        {
            NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:10];
            [parameters addObject:item.title];
            [parameters addObject:item.itemDescription];
            [parameters addObject:item.content];
            [parameters addObject:[item.link  absoluteString]];
            [parameters addObject:[item.commentsLink absoluteString]];
            [parameters addObject:[item.commentsFeed absoluteString]];
            [parameters addObject:item.commentsCount];
            [parameters addObject:item.pubDate];
            [parameters addObject:item.author];
            [parameters addObject:item.guid ];
            BOOL updateResult = [database executeUpdate:@"INSERT OR REPLACE INTO rss VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:parameters];
            if (!updateResult)
            {
                NSLog(@"Failed: %@ ", [database lastError]);
            }
        }
        
        
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UINavigationController *NavigationController = [storyboard instantiateViewControllerWithIdentifier:@"InitStoryboard"];
        ViewController *ViewContr = [NavigationController.viewControllers objectAtIndex:0]; 
        ViewContr._newsContent = feedItems;
        [ViewContr.tableView reloadData];
        
        self.window.rootViewController = NavigationController; 
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK'" otherButtonTitles:nil];
        [alert show];}];
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
