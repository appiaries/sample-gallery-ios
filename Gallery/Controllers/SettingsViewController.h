//
//  SettingsViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 12/1/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIView *containerView2;
@property (weak, nonatomic) IBOutlet UISwitch *commentSwitch;
@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;

#pragma mark - Actions
- (IBAction)actionSetSecond:(id)sender;
- (IBAction)actionSwitch:(id)sender;

@end
