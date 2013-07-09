//
//  AddShiftViewController.h
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DatePickerViewController.h"
#import "LocationPickerViewController.h"

@class AddShiftViewController;
@class Shift;

@protocol AddShiftViewControllerDelegate <NSObject>

- (void)addShiftViewControllerDidCancel:(AddShiftViewController *)controller;
- (void)addShiftViewController:(AddShiftViewController *)controller didFinishAddingShift:(Shift *)item;

@end

@interface AddShiftViewController : UITableViewController <UITextFieldDelegate, DatePickerViewControllerDelegate, LocationPickerViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (strong, nonatomic) IBOutlet UITextField *detailField;
@property (strong, nonatomic) IBOutlet UITextField *durationField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextView *notesField;
@property (nonatomic, weak) id <AddShiftViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *shiftDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *shiftLocationLabel;

@property (nonatomic, strong) Shift *shiftToEdit;

- (IBAction)cancel;
- (IBAction)done;

@end
