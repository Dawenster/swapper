//
//  AddShiftViewController.m
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import "AddShiftViewController.h"
#import "Shift.h"

@interface AddShiftViewController ()

@end

@implementation AddShiftViewController {
    NSDate *date;
    NSString *location;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateShiftDateLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.shiftDateLabel.text = [formatter stringFromDate:date];
}

- (void)updateShiftLocationLabel
{
    self.shiftLocationLabel.text = location;
}

- (void)viewDidLoad
{
    NSDate *today = [NSDate date];
    
    NSDateComponents *futureComponents = [NSDateComponents new];
    futureComponents.day = 7 ;

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate *futureDate = [gregorian dateByAddingComponents:futureComponents toDate:today options:0];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: futureDate];
    
    [components setHour: 7];
    [components setMinute: 30];
    [components setSecond: 0];
    
    date = [gregorian dateFromComponents: components];
    
    NSString *defaultLocation = @"Burnaby General Hospital";
    location = defaultLocation;
    
    [super viewDidLoad];
    [self updateShiftDateLabel];
    [self updateShiftLocationLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel
{
    [self.delegate addShiftViewControllerDidCancel:self];
}

- (IBAction)done
{
    if (self.doneBarButton.enabled) {
        Shift *shift = [[Shift alloc] init];
        
        shift.location = location;
        shift.locationDetail = self.detailField.text;
        shift.date = self->date;
        shift.duration = self.durationField.text.intValue;
        shift.name = self.nameField.text;
        shift.email = self.emailField.text;
        shift.notes = self.notesField.text;
        
        [self.delegate addShiftViewController:self didFinishAddingShift:shift];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2) {
        return indexPath;
    } else {
        return nil;
    }
}

- (void)viewDidUnload {
    [self setDetailField:nil];
    [self setDurationField:nil];
    [self setNameField:nil];
    [self setEmailField:nil];
    [self setNotesField:nil];
    [self setDoneBarButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // [self.detailField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.doneBarButton.enabled =
        (([self.detailField.text length] > 0 || (self.detailField == theTextField && [newText length] > 0)) &&
        ([self.durationField.text length] > 0 || (self.durationField == theTextField && [newText length] > 0)) &&
        ([self.nameField.text length] > 0 || (self.nameField == theTextField && [newText length] > 0)) &&
        ([self.emailField.text length] > 0 || (self.emailField == theTextField && [newText length] > 0)));
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickDate"]) {
        DatePickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.date = date;
    } else if ([segue.identifier isEqualToString:@"PickLocation"]) {
        LocationPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.location = location;
    }
}

- (void)datePickerDidCancel:(DatePickerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)datePicker:(DatePickerViewController *)picker didPickDate:(NSDate *)shiftDate
{
    date = shiftDate;
    [self updateShiftDateLabel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationPickerDidCancel:(LocationPickerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationPicker:(LocationPickerViewController *)picker didPickLocation:(NSString *)shiftLocation
{
    location = shiftLocation;
    [self updateShiftLocationLabel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end