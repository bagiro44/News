//
//  WebViewController.h
//  News
//
//  Created by Dmitriy Remezov on 13.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (strong, nonatomic) NSURL *URL;

@end
