//
//  SettingsViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 12/1/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "SettingsViewController.h"
#import "PreferenceHelper.h"


@implementation SettingsViewController
{
    NSArray *_intervals;
}

static NSString * const kIntervalUnitLabel = @"秒";

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
    [self setupView];
}

#pragma mark - Actions
- (IBAction)actionSetSecond:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    _pickerView.hidden = NO;
    [UIView commitAnimations];
}

- (IBAction)actionSwitch:(id)sender
{
    BOOL commentHidden = ! _commentSwitch.isOn;
    [[PreferenceHelper sharedPreference] saveCommentHidden:commentHidden];
}

#pragma mark - UIPickerView data sources
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_intervals count];
}

#pragma mark - UIPickerView delegates
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d%@", [_intervals[(NSUInteger)row] integerValue], kIntervalUnitLabel];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger interval = [_intervals[(NSUInteger)row] integerValue];
    [[PreferenceHelper sharedPreference] saveDisplayInterval:interval];

    _intervalLabel.text = [NSString stringWithFormat:@"( %d%@ )", interval, kIntervalUnitLabel];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    _pickerView.hidden = YES;
    [UIView commitAnimations];
}

#pragma mark - MISC
- (void)setupView
{
    self.title = @"設定";

    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.hidden = YES;

    _intervals = @[@(2), @(5), @(10)];

    _containerView1.layer.borderColor = [UIColor blackColor].CGColor;
    _containerView1.layer.borderWidth = 1.0f;

    _containerView2.layer.borderColor = [UIColor blackColor].CGColor;
    _containerView2.layer.borderWidth = 1.0f;

    NSInteger interval = [[PreferenceHelper sharedPreference] loadDisplayInterval];
    _intervalLabel.text = [NSString stringWithFormat:@"( %d%@ )", interval, kIntervalUnitLabel];

    BOOL commentHidden = [[PreferenceHelper sharedPreference] loadCommentHidden];
    [_commentSwitch setOn:!commentHidden];
}

@end
