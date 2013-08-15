//
//  DateData.m
//  News
//
//  Created by Dmitriy Remezov on 15.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "DateData.h"
#import "FMDatabase.h"
#import "RSSItem.h"
#import "RSSParser.h"


@interface DateData()
@property (nonatomic, strong) FMDatabase *database;
@end


@implementation DateData

+ (DateData *)sharedInstance;
{
	static dispatch_once_t p = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&p, ^{
		_sharedObject = [[self alloc] init];
	});
	return _sharedObject;
}

-(id)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    NSError *error = nil;
    NSString *const kDataBaseFileName = @"rssManaged.sqlite";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dataBasePath = [documentDirectory stringByAppendingPathComponent:kDataBaseFileName];
    
    NSManagedObjectModel *ObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *StoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:ObjectModel];
    [StoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:Nil URL:[NSURL URLWithString:dataBasePath] options:nil error:&error];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:dataBasePath];
    if (![database open])
    {
        database = nil;
        NSLog(@"Database not open.");
        return nil;
    }
    
    self.database = database;
    return self;
}

-(BOOL) HasCahedRssFeed
{
    NSInteger rowsCount = 0;
    FMResultSet *result = [self.database executeQuery:@"select count(*) from rss"];
    if ([result next])
    {
        rowsCount = [result intForColumnIndex:0];
    }
    return rowsCount != 0;
}

-(NSArray *) FetchCacheRssFeed
{
    FMDatabase *database = self.database;
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *result = [database executeQuery:@"select * from rss order by pubDate desc"];
    while ([result next])
    {
        RSSItem *item = [[RSSItem alloc] init];
        item.title = [result stringForColumnIndex:0];
        item.itemDescription = [result stringForColumnIndex:1];
        item.content = [result stringForColumnIndex:2];
        item.link = [NSURL URLWithString:[result stringForColumnIndex:3]];
        item.commentsLink = [NSURL URLWithString:[result stringForColumnIndex:4]];
        item.commentsFeed = [NSURL URLWithString:[result stringForColumnIndex:5]];
        item.commentsCount =[NSNumber numberWithInt:[result intForColumnIndex:6]];
        item.pubDate  = [result dateForColumnIndex:7];
        item.author = [result stringForColumnIndex:8];
        item.guid = [result stringForColumnIndex:9];
        
        [results addObject:item];
    }
    
    return results; 
}

-(void)fetchRssFeedCashedBlock:(DateDataSuccessBlock)cashedBlock successBlock:(DateDataSuccessBlock)succesBlock failureBlock:(DateDataFailureBlock)failureBlock
{
    if (cashedBlock)
    {
        NSArray *cashedFeed = [self FetchCacheRssFeed];
        cashedBlock(cashedFeed);
    }
    NSURL *url = [NSURL URLWithString:@"http://itdox.ru/feed/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems)
     {
         FMDatabase *database = self.database;
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
             if (succesBlock)
             {
                 NSArray *cashedFeed = [self FetchCacheRssFeed];
                 succesBlock(cashedFeed); 
             }
             
        }
     } failure:failureBlock]; 
    
}


@end
