//
//  DetailViewController.m
//  News
//
//  Created by Dmitriy Remezov on 08.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "DetailViewController.h"
#import "RSSParser.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
#import "EXConsts.h"

@interface DetailViewController () <UIActionSheetDelegate>

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData]; 
    
} 
-(void)setDetail:(RSSItem *)Detail
{
    _Detail = Detail;
    //NSLog(@"%@", _Detail.itemDescription);
}




-(void)reloadData
{
    self.navigationItem.title = _Detail.title;
    
    NSUserDefaults *UserDef = [NSUserDefaults standardUserDefaults];
    NSString *fontName = [UserDef objectForKey:EXSettingFontName];
    NSNumber *fontSize = [UserDef objectForKey:EXSettingFontSize];
    self.newsText.font = [UIFont fontWithName:fontName size:[fontSize floatValue]];
    
	 
    //self.newsImage.image = [UIImage imageNamed:_Detail.imageName];
    NSArray *images = [_Detail imagesFromContent ];
    NSString *imagesURLString = [images objectAtIndex:0];
    NSURL *imagesURL = [NSURL URLWithString:imagesURLString];
    [self.newsImage setImageWithURL:imagesURL];
    self.newsText.text = _Detail.itemDescription;
    self.newsName.text = _Detail.author;
    
    CGRect ContentViewFrame = _ViewInScrollView.frame;
    ContentViewFrame.size.height += _newsText.contentSize.height - _newsText.frame.size.height;
    _ViewInScrollView.frame = ContentViewFrame;
    _scrollView.contentSize = _ViewInScrollView.frame.size;
}

- (IBAction)Share:(id)sender
{
    //[[UIApplication sharedApplication] openURL:_Detail.link];
    UIActionSheet *sheet = [[UIActionSheet  alloc] initWithTitle:nil  delegate:self cancelButtonTitle:@"Cancel"  destructiveButtonTitle:nil otherButtonTitles:@"Open", @"Open with Safari", nil];
    [sheet showInView:self.view];
    //[self performSegueWithIdentifier:@"OpenURL" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewController *controller = segue.destinationViewController;
    controller.URL = _Detail.link ;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
     {
        case 0:
            [self performSegueWithIdentifier:@"OpenURL" sender:self]; 
            break;
         case 1:
             [[UIApplication sharedApplication] openURL:_Detail.link];
             break;
            
        default:
            break;
    }
}

@end
