//
//  DateData.h
//  News
//
//  Created by Dmitriy Remezov on 15.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DateDataSuccessBlock)(NSArray *result);
typedef void(^DateDataFailureBlock)(NSError *error);

@interface DateData : NSObject

+(DateData *)sharedInstance;

-(BOOL)HasCahedRssFeed;
-(void)fetchRssFeedCashedBlock:(DateDataSuccessBlock)cashedBlock successBlock:(DateDataSuccessBlock)succesBlock failureBlock:(DateDataFailureBlock)failureBlock;

@end
