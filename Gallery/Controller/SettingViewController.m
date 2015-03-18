//
//  SettingViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 12/1/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "SettingViewController.h"
#import "GalleryAPIClient.h"


@implementation SettingViewController
@synthesize myPickerView;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"設定";
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    myPickerView.hidden = YES;
    
    listSecond = @[@"2秒", @"5秒", @"10秒"];
    
    self.viewContainer1.layer.borderColor = [UIColor blackColor].CGColor;
    self.viewContainer1.layer.borderWidth = 1.0f;
    
    self.viewContainer2.layer.borderColor = [UIColor blackColor].CGColor;
    self.viewContainer2.layer.borderWidth = 1.0f;
    
    NSString *selectedItem = [[GalleryAPIClient sharedClient] getSettingTimeInterval];
    self.selectedSecond.text = [NSString stringWithFormat:@"( %@ )", selectedItem];
    
    BOOL isComment = [[GalleryAPIClient sharedClient] getSettingComment];
    [self.mySwitch setOn:isComment];
}

#pragma mark - Actions
- (IBAction)actionSetSecond:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    myPickerView.hidden = NO;
    [UIView commitAnimations];
}

- (IBAction)actionSwitch:(id)sender
{
    [[GalleryAPIClient sharedClient] saveSettingUserDefault:self.mySwitch.isOn timeInterval:@"" option:1];
}

#pragma mark - UIPickerView data sources
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UIPickerView delegates
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return listSecond[(NSUInteger)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *selectedItem = listSecond[(NSUInteger)row];
    [[GalleryAPIClient sharedClient] saveSettingUserDefault:YES timeInterval:selectedItem option:2];
    
    self.selectedSecond.text = [NSString stringWithFormat:@"( %@ )", selectedItem];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    myPickerView.hidden = YES;
    [UIView commitAnimations];
}

@end
