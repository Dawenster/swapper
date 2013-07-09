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

//    Shift *shift = [Shift alloc];
//    shift.name = @"David Wen";
//    shift.location = @"Vancouver General Hospital";
//    shift.locationDetail = @"Unit 6B";
//    shift.date = [NSDate date];
//    shift.duration = 12;
//    shift.email = @"david@gmail.com";
//    shift.taken = NO;
//    shift.notes = @"1. Monday, Jul 31 - Day\n2. Wednesday, Aug 2 - Night\n3. Thursday, Aug 3 - Day";
//    
//    [shifts addObject:shift];
    [self loadShifts];
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

- (void)addShiftViewController:(AddShiftViewController *)controller didFinishEditingShift:(Shift *)shift
{
    int rowIndex = [shifts indexOfObject:shift];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1000];
    UILabel *subTitle = (UILabel *)[cell viewWithTag:1001];
    
    title.text = [shift formatTitle:(shift)];
    subTitle.text = [shift formatSubTitle:(shift)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Shift *shift = [shifts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditShift" sender:shift];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddShift"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddShiftViewController *controller = (AddShiftViewController *)navigationController.topViewController;
        controller.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"EditShift"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddShiftViewController *controller = (AddShiftViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.shiftToEdit = sender;
        
    } else if ([segue.identifier isEqualToString:@"ViewDetail"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Shift *selectedShift = [shifts objectAtIndex:path.row];
        
        UIViewController *viewController = segue.destinationViewController;
        ShiftDetailViewController *controller = (ShiftDetailViewController *)viewController;
        controller.shift = selectedShift;
    }
}

- (IBAction)reloadShifts
{
    [self loadShifts];
}

- (void)loadShifts
{
    [shifts removeAllObjects];
    NSLog(@"viewdidload");
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://swapperapp.herokuapp.com/shifts"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"Connection description: %@",connection.description);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSArray *valueAsArray = (NSArray *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"num in array: %d", [valueAsArray count]);
        
        for (NSDictionary *result in valueAsArray) {
            Shift *shift = [[Shift alloc] init];
            
            shift.location = result[@"location"];
            shift.locationDetail = result[@"locationDetail"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSString *DBString = [result[@"date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            DBString = [DBString stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
            NSDate *dateFromDB = [dateFormat dateFromString:DBString];
            shift.date = dateFromDB;
            
            NSString *duration = result[@"duration"];
            shift.duration = duration.intValue;
            
            shift.name = result[@"name"];
            shift.email = result[@"email"];
            shift.notes = result[@"notes"];
            
            [shifts addObject:shift];
        }
        NSLog(@"Num shifts: %d", [shifts count]);
        Shift *selectedShift = [shifts objectAtIndex:[shifts count] - 1];
        NSLog(@"Last shift's date: %@", [selectedShift formatTitle:(selectedShift)]);
        [self.tableView reloadData];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
