//
//  SwapperViewController.m
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import "AvailableShiftsViewController.h"
#import "Shift.h"
#import "MBProgressHUD.h"

@interface AvailableShiftsViewController ()

@end

@implementation AvailableShiftsViewController {
    NSMutableArray *shifts;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	shifts = [[NSMutableArray alloc] initWithCapacity:20];
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
    Shift *shift = [shifts objectAtIndex:indexPath.row];
    [self makeRequestToServer:(shift) requestMethod:(@"DELETE")];
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
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Loading";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"viewdidload");
            self.responseData = [NSMutableData data];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://swapperapp.herokuapp.com/shifts"]];
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            NSLog(@"Connection description: %@",connection.description);
        });
    });
}

- (void)makeRequestToServer:(Shift *)shift requestMethod:(NSString *)method
{
    NSString *url = [NSString stringWithFormat:@"http://swapperapp.herokuapp.com/shifts/1?uniqueID=%@", shift.uniqueID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    NSURLConnection * postOutput = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"Request: %@", postOutput.description);
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
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = @"Error loading... try again? :)";
    [HUD hide:YES afterDelay:2];
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
            shift.uniqueID = result[@"uniqueID"];
            
            [shifts addObject:shift];
        }
        NSLog(@"Num shifts: %d", [shifts count]);
        Shift *selectedShift = [shifts objectAtIndex:[shifts count] - 1];
        NSLog(@"Last shift's date: %@", [selectedShift formatTitle:(selectedShift)]);
        
    }
    [self.tableView reloadData];
    
    [HUD hide:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
