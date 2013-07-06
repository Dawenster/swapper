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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	shifts = [[NSMutableArray alloc] initWithCapacity:20];
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
    NSLog(@"Cell number %d clicked", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    }
}

@end
