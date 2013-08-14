//
//  WebViewController.m
//  News
//
//  Created by Dmitriy Remezov on 13.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    self.WebView.scalesPageToFit = YES;
	NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.WebView loadRequest:request];
}

@end
