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
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        CGSize constraintSize = CGSizeMake(185.0f, MAXFLOAT);
        CGSize labelSize_val = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        return labelSize_val.height + 20;
    }
    return 40;
}

- (IBAction)sendEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [formatter setLocale:locale];
        
        [formatter setDateFormat:@"MMM d, YYYY (EEE)"];
        NSString *dateAsString = [formatter stringFromDate:self.shift.date];
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeAsString = [formatter stringFromDate:self.shift.date];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Swap request: %@ at %@", dateAsString, timeAsString]];
        NSArray *toRecipients = [NSArray arrayWithObjects:self.shift.email, nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = [NSString stringWithFormat:@"Hi %@,\n\nI can take your shift on %@ at %@.  Let me know if that works for you!", self.shift.name, dateAsString, timeAsString];
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
            message:@"Your device doesn't support the composer sheet"
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

@end
