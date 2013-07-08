//
//  SwapperViewController.m
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import "AvailableShiftsViewController.h"
#import "Shift.h"

@interface AvailableShiftsViewController ()

@end

@implementation AvailableShiftsViewController {
    NSMutableArray *shifts;
//    Shift *selectedShift;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	shifts = [[NSMutableArray alloc] initWithCapacity:20];
    
    Shift *shift = [Shift alloc];
    shift.name = @"David Wen";
    shift.location = @"Vancouver General Hospital";
    shift.locationDetail = @"Unit 6B";
    shift.date = [NSDate date];
    shift.duration = 12;
    shift.email = @"david@gmail.com";
    shift.taken = NO;
    shift.notes = @"1. Monday, Jul 31 - Day\n2. Wednesday, Aug 2 - Night\n3. Thursday, Aug 3 - Day";
    
    [shifts addObject:shift];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shifts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Shift"];
    Shift *shift = [shifts objectAtIndex:indexPath.row];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1000];
    UILabel *subTitle = (UILabel *)[cell viewWithTag:1001];
    
    title.text = [shift formatTitle:(shift)];
    subTitle.text = [shift formatSubTitle:(shift)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Shift *shift = [shifts objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [shifts removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addShiftViewControllerDidCancel:(AddShiftViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addShiftViewController:(AddShiftViewController *)controller didFinishAddingShift:(Shift *)shift
{
    int newRowIndex = [shifts count];
    [shifts addObject:shift];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddShift"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddShiftViewController *controller = (AddShiftViewController *)navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"ViewDetail"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Shift *selectedShift = [shifts objectAtIndex:path.row];
        
        UIViewController *viewController = segue.destinationViewController;
        ShiftDetailViewController *controller = (ShiftDetailViewController *)viewController;
        controller.shift = selectedShift;
    }
}

@end
