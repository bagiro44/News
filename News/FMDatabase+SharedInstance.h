//
//  FMDatabase+SharedInstance.h
//  News
//
//  Created by Dmitriy Remezov on 14.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "FMDatabase.h"

@interface FMDatabase (SharedInstance)

+(FMDatabase *)sharedInstance;
+(void) setSharedInstance:(FMDatabase *)sharedInstance;

@end
