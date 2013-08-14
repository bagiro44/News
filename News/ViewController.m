//
//  ViewController.m
//  News
//
//  Created by Dmitriy Remezov on 05.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"
#import "DetailViewController.h" 
#import "RSSParser.h"
#import "UIImageView+AFNetworking.h" 
#import "FMDatabase+SharedInstance.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"NewsDoc";
    [self reloadData];
    RSSItem *lastItem = [self._newsContent objectAtIndex:0];
    /*NSTimeInterval interval  = [[NSDate date] timeIntervalSinceDate:lastItem.pubDate];
    if (interval> 60*60*12)
    {
        [self RefreshData];
    }*/
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self._newsContent count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellId2 = @"Cell2";
    
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
    
    RSSItem *item = [self._newsContent objectAtIndex:indexPath.row];
    cell.Text.text = item.title;
    
    NSArray *images = [item imagesFromContent];
    NSString *imagesURLString = [images objectAtIndex:0];
    NSURL *imagesURL = [NSURL URLWithString:imagesURLString];
    //[cell.]
    [cell.Image setImageWithURL:imagesURL];
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath)
    {[self.tableView deselectRowAtIndexPath:indexPath animated:YES];}
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender NS_AVAILABLE_IOS(5_0)
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath){
        RSSItem  *item =  [self._newsContent objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetail:item];
    }
}


- (IBAction)refreshAction:(id)sender
{
    [self RefreshData];

}

-(void) RefreshData
{
    
    //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSURL *url = [NSURL URLWithString:@"http://itdox.ru/feed/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
        //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
        /*self._newsContent = feedItems;*/
        
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
        [self reloadData];
    } failure:^(NSError *error) {
        //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
        NSLog(@"%@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

-(void) reloadData
{
    FMDatabase *database = [FMDatabase sharedInstance];
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
    
    self._newsContent = results;
    [self.tableView reloadData];
}


@end
