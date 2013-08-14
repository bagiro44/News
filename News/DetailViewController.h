//
//  DetailViewController.h
//  News
//
//  Created by Dmitriy Remezov on 08.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSParser.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) RSSItem *Detail;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *ViewInScrollView;
@property (weak, nonatomic) IBOutlet UITextView *newsText;
- (IBAction)Share:(id)sender;

@end
