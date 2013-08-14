//
//  UIImage+ImageNamed568.m
//
//  Created by Alexey Aleshkov on 31.10.12.
//  Copyright (c) 2012 Webparadox, LLC. All rights reserved.
//


#import "UIImage+ImageNamed568.h"


@implementation UIImage (ImageNamed568)

+ (UIImage *)imageNamed568:(NSString *)imageName
{
	NSMutableString *imageNameMutable = [imageName mutableCopy];
	
	NSRange retinaAtSymbol = [imageName rangeOfString:@"@"];
	if (retinaAtSymbol.location != NSNotFound) {
		[imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
	} else {
		CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
		if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
			NSRange dot = [imageName rangeOfString:@"."];
			if (dot.location != NSNotFound) {
				[imageNameMutable insertString:@"-568h@2x" atIndex:dot.location];
			} else {
				[imageNameMutable appendString:@"-568h@2x"];
			}
		}
	}
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
	if (imagePath) {
		return [UIImage imageNamed:imageNameMutable];
	} else {
		return [UIImage imageNamed:imageName];
	}
	
	return nil;
}

@end
