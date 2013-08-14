//
//  PickerViewController.m
//  News
//
//  Created by Dmitriy Remezov on 14.08.13.
//  Copyright (c) 2013 Dmitriy Remezov. All rights reserved.
//

#import "PickerViewController.h"
#import "EXConsts.h"

@interface PickerViewController ()<UIPickerViewDelegate, UIPickerViewDataSource> 
@property (strong, nonatomic) NSArray *fontNames;
@property (strong, nonatomic) NSArray *fontSize;
@end

@implementation PickerViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma -
#pragma UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.fontNames count];
    }else { 
        return [self.fontSize count];
    }
}

#pragma -
#pragma UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 210;
    }else {
        return 80;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fontNames = EXFontNames();
    self.fontSize = EXFontSizes();
    
    [self.PickerView selectRow:0 inComponent:0 animated:NO];
    [self.PickerView selectRow:0 inComponent:1 animated:NO];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *result;
        EXFontName *name = [self.fontNames objectAtIndex:row];
        result = name.fontName;
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:result forKey:EXSettingFontName];
        [userDef synchronize];
        return result;
    }else {
        NSString *result;
        NSNumber *size = [self.fontSize objectAtIndex:row];
        result = [size stringValue];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:result forKey:EXSettingFontSize];
        [userDef synchronize];
        return result;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     
}
@end
