//
//  EXConsts.m
//  NewsCatalog
//
//  Created by Alexey Aleshkov on 27.05.13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "EXConsts.h"


NSString *const EXSettingFontName = @"EXSettingFontName";
NSString *const EXSettingFontSize = @"EXSettingFontSize";


@implementation EXFontName

+ (instancetype)fontWithName:(NSString *)fontName displayName:(NSString *)displayName
{
	EXFontName *result = [[EXFontName alloc] init];
	result.fontName = fontName;
	result.fontDisplayName = displayName;
	return result;
}

@end


NSArray *EXFontNames()
{
	static id _instance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		NSMutableArray *fontNames = [NSMutableArray array];
		[fontNames addObject:[EXFontName fontWithName:@"HelveticaNeue" displayName:@"Helvetica Neue"]];
		[fontNames addObject:[EXFontName fontWithName:@"TimesNewRomanPSMT" displayName:@"Times New Roman"]];
		[fontNames addObject:[EXFontName fontWithName:@"Verdana" displayName:@"Verdana"]];
		[fontNames addObject:[EXFontName fontWithName:@"CourierNewPSMT" displayName:@"Courier New"]];
		[fontNames addObject:[EXFontName fontWithName:@"Courier" displayName:@"Courier"]];
		[fontNames addObject:[EXFontName fontWithName:@"Georgia" displayName:@"Georgia"]];
		[fontNames addObject:[EXFontName fontWithName:@"Baskerville" displayName:@"Baskerville"]];
		[fontNames addObject:[EXFontName fontWithName:@"ArialMT" displayName:@"Arial"]];
		_instance = fontNames;
	});

	return _instance;
}

NSArray *EXFontSizes()
{
	static id _instance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		NSArray *fontSizes = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:10],
							  [NSNumber numberWithFloat:11],
							  [NSNumber numberWithFloat:12],
							  [NSNumber numberWithFloat:14],
							  [NSNumber numberWithFloat:16],
							  [NSNumber numberWithFloat:18],
							  [NSNumber numberWithFloat:20],
							  [NSNumber numberWithFloat:22],
							  nil];
		_instance = fontSizes;
	});

	return _instance;
}

NSInteger EXFindNearestFontNameIndex(NSString *fontName)
{
	NSInteger result = 0;

	NSArray *fontNames = EXFontNames();
	for (NSInteger i = 0; i < [fontNames count]; ++i) {
		EXFontName *item = [fontNames objectAtIndex:i];
		if ([item.fontName isEqualToString:fontName]) {
			result = i;
			break;
		}
	}

	return result;
}

NSInteger EXFindNearestFontSizeIndex(NSNumber *fontSize)
{
	NSInteger result = 0;

	NSArray *fontSizes = EXFontSizes();
	CGFloat fontSizeFloat = [fontSize floatValue];
	for (NSInteger i = 0; i < [fontSizes count]; ++i) {
		NSNumber *item = [fontSizes objectAtIndex:i];
		if ([item floatValue] == fontSizeFloat) {
			result = i;
			break;
		}
	}
	return result;
}
