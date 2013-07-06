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

@implementation AddShiftViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        shift.locationDetail = self.detailField.text;
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
    
    [self.detailField becomeFirstResponder];
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

@end
