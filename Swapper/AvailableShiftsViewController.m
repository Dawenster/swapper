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
    
    Shift *shift;
    
    shift = [[Shift alloc] init];
    shift.name = @"David Wen";
    shift.location = @"BUH";
    shift.locationDetail = @"3D";
    shift.date = [NSDate date];
    shift.duration = 12;
    shift.email = @"david@gmail.com";
    shift.taken = NO;
    shift.notes = @"I'll give you a cookie if you take this shift!";
    
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
    NSLog(@"Cell number %d clicked", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
