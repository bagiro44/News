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
#import "UIImageView+AFNetworking.h" 
#import "SVPullToRefresh.h"
#import "DateData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"NewsDoc";
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self RefreshData];
    } position:(SVPullToRefreshPositionTop)];
    [self.tableView triggerPullToRefresh];

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

-(void) RefreshData
{
    [[DateData sharedInstance] fetchRssFeedCashedBlock:^(NSArray *result) {
        self._newsContent = result;
        [self.tableView reloadData];
    } successBlock:^(NSArray *result) {
        [self.tableView.pullToRefreshView stopAnimating];
        self._newsContent = result;
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}




@end
