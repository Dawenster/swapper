//
//  LocationPickerViewController.m
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import "LocationPickerViewController.h"

@interface LocationPickerViewController ()

@end

@implementation LocationPickerViewController {
    NSArray *locations;
    UILabel *locationLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *loc1 = @"Burnaby General Hospital";
    NSString *loc2 = @"Vancouver General Hospital";
    NSString *loc3 = @"Royal Columbian Hospital";
    NSString *loc4 = @"St. Paul's Hospital";
    NSString *loc5 = @"Surrey Memorial Hospital";
    
	locations = [NSArray arrayWithObjects:loc1, loc2, loc3, loc4, loc5, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)updateLocationLabel
{
    locationLabel.text = self.location;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    
    locationLabel = (UILabel *)[cell viewWithTag:1000];
    [self updateLocationLabel];
    
    return cell;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [locations count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [locations objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *location = [locations objectAtIndex:row];
    self.location = location;
    [self updateLocationLabel];
}

- (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 77;
}

- (IBAction)cancel
{
    [self.delegate locationPickerDidCancel:self];
}

- (IBAction)done
{
    [self.delegate locationPicker:self didPickLocation:self.location];
}

@end
