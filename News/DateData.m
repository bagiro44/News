//
//  DateData.m
//  News
//
//  Created by Dmitriy Remezov on 15.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "DateData.h"
#import "RSSItem.h"
#import "RSSParser.h"


@interface DateData()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *ManagedObjectContext; 
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
    [StoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:Nil URL:[NSURL fileURLWithPath:dataBasePath] options:nil error:&error];
    
    NSManagedObjectContext *ManagedObjectContext = [[NSManagedObjectContext alloc] init];
    ManagedObjectContext.persistentStoreCoordinator = StoreCoordinator;
    self.ManagedObjectContext = ManagedObjectContext;
    return self;
}

-(BOOL) HasCahedRssFeed
{
    NSUInteger rowsCount = 0;
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Rss" inManagedObjectContext:self.ManagedObjectContext];
    NSFetchRequest *Request = [[NSFetchRequest alloc] init];
    Request.entity = description;
    NSError *error =  nil;
    rowsCount = [self.ManagedObjectContext countForFetchRequest:Request error:&error];
    return rowsCount != 0;
}

-(NSArray *) FetchCacheRssFeed
{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Rss" inManagedObjectContext:self.ManagedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
    NSFetchRequest *Request = [[NSFetchRequest alloc] init];
    Request.entity = description;
    Request.sortDescriptors = @[sortDescriptor];
    
    NSError *error =  nil;
    NSArray *results =  [self.ManagedObjectContext executeFetchRequest:Request error:&error];
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
         for (RSSItem *item in feedItems)
         {
             NSEntityDescription *description = [NSEntityDescription entityForName:@"Rss" inManagedObjectContext:self.ManagedObjectContext];
             NSFetchRequest *Request = [[NSFetchRequest alloc] init];
             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid == %@", item.guid];
             Request.entity = description;
             Request.predicate = predicate;             
             NSError *error =  nil;
             NSArray *results =  [self.ManagedObjectContext executeFetchRequest:Request error:&error];
             if (error)
             {
                 NSLog(@"%@", [error localizedDescription]);
                 continue;
             }
             
             Rss *rss = nil;
             if ([results count])
             {
                 rss = [results objectAtIndex:0];
                 
             }
             else
             {
                 rss = [NSEntityDescription insertNewObjectForEntityForName:@"Rss" inManagedObjectContext:self.ManagedObjectContext];
             }
             
             rss.title = item.title; 
             rss.itemDescription = item.itemDescription;
             rss.content = item.content;
             rss.link = [item.link  absoluteString];
             rss.commentsLink = [item.commentsLink absoluteString];
             rss.commentsFeed = [item.commentsFeed absoluteString];
             rss.commentsCount = item.commentsCount;
             rss.pubDate = item.pubDate;
             rss.author = item.author;
             rss.guid = item.guid;
             
             
             [self.ManagedObjectContext save:&error];
             if (error)
             {
                 NSLog(@"%@", [error localizedDescription]); 
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
