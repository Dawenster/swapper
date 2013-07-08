//
//  ShiftDetailViewController.m
//  Swapper
//
//  Created by David Wen on 2013-07-07.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import "ShiftDetailViewController.h"

@interface ShiftDetailViewController ()

@end

@implementation ShiftDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [formatter setLocale:locale];
    
    [formatter setDateFormat:@"MMM d, YYYY (EEE)"];
    NSString *dateAsString = [formatter stringFromDate:self.shift.date];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeAsString = [formatter stringFromDate:self.shift.date];
    
    NSString *timeAndDuration = [NSString stringWithFormat:@"%@ for %d hours",timeAsString,self.shift.duration];
    
    switch (indexPath.row) {
        {case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
            UILabel *location = (UILabel *)[cell viewWithTag:1000];
            location.text = self.shift.location;
            break;}
    
        {case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsCell"];
            UILabel *detail = (UILabel *)[cell viewWithTag:1001];
            detail.text = self.shift.locationDetail;
            break;}
            
        {case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell"];
            UILabel *date = (UILabel *)[cell viewWithTag:1002];
            date.text = dateAsString;
            break;}
            
        {case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
            UILabel *time = (UILabel *)[cell viewWithTag:1003];
            time.text = timeAndDuration;
            break;}
        
        {case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SwappingCell"];
            UILabel *swapping = (UILabel *)[cell viewWithTag:1003];
            swapping.text = timeAndDuration;
            break;}
    }
    
    return cell;
}

@end
