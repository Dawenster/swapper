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
            UITextView *swapping = (UITextView *)[cell viewWithTag:1004];
            swapping.text = self.shift.notes;
            break;}
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        NSString *cellText = self.shift.notes;
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
        CGSize constraintSize = CGSizeMake(330.0f, MAXFLOAT);
        CGSize labelSize_val = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        NSLog(@"%@", cellText);
        NSLog(@"Label height: %f", labelSize_val.height);
        return labelSize_val.height + 20;
    }
    return 40;
}

@end
