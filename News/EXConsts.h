//
//  EXConsts.h
//  NewsCatalog
//
//  Created by Alexey Aleshkov on 27.05.13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import <Foundation/Foundation.h>


extern NSString *const EXSettingFontName;
extern NSString *const EXSettingFontSize;


@interface EXFontName : NSObject
@property (nonatomic, copy) NSString *fontDisplayName;
@property (nonatomic, copy) NSString *fontName;
+ (instancetype)fontWithName:(NSString *)fontName displayName:(NSString *)displayName;
@end


extern NSArray *EXFontNames();
extern NSArray *EXFontSizes();

extern NSInteger EXFindNearestFontNameIndex(NSString *fontName);
extern NSInteger EXFindNearestFontSizeIndex(NSNumber *fontSize);
