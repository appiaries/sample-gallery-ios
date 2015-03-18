//
//  SettingViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 12/1/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *listSecond;
}
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UIView *viewContainer1;
@property (weak, nonatomic) IBOutlet UIView *viewContainer2;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UILabel *selectedSecond;

#pragma mark - Actions
- (IBAction)actionSetSecond:(id)sender;
- (IBAction)actionSwitch:(id)sender;

@end
