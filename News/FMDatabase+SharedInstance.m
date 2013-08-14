//
//  FMDatabase+SharedInstance.m
//  News
//
//  Created by Dmitriy Remezov on 14.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "FMDatabase+SharedInstance.h"

static FMDatabase *sDataBase = nil;

@implementation FMDatabase (SharedInstance) 

+(FMDatabase *)sharedInstance
{
    return sDataBase;
}

+(void) setSharedInstance:(FMDatabase *)sharedInstance
{
    sDataBase = sharedInstance; 
}

@end
