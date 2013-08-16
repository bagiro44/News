//
//  Rss+RssManaged.h
//  News
//
//  Created by Dmitriy Remezov on 15.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "Rss.h"

@interface Rss (RssManaged)

-(NSArray *)imagesFromItemDescription;
-(NSArray *)imagesFromContent;   

@end
