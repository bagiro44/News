//
//  SplashScreenViewController.m
//  News
//
//  Created by Dmitriy Remezov on 13.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "UIImage+ImageNamed568.h"
#import "RSSParser.h"
#import "ViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

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
    UIImage *image = [UIImage imageNamed568:@"Default"];
    self.ImageSplash.image = image;
    
    
}

@end
