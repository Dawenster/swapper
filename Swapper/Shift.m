//
//  Shift.m
//  Swapper
//
//  Created by David Wen on 2013-07-06.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import "Shift.h"

@implementation Shift

- (NSString *)formatTitle:(Shift *)shift
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [formatter setLocale:locale];
    
    [formatter setDateFormat:@"EEE, MMM d"];
    NSString *dateAsString = [formatter stringFromDate:shift.date];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeAsString = [formatter stringFromDate:shift.date];
    // NSString *hours = [NSString stringWithFormat:@"(%d hrs)", shift.duration];
    
    NSString *titleText = [NSString stringWithFormat:@"%@ @ %@", dateAsString, timeAsString];
    
    return titleText;
}

- (NSString *)formatSubTitle:(Shift *)shift
{
    NSString *subTitleText = [NSString stringWithFormat:@"%@, %@ %@", shift.name, shift.location, shift.locationDetail];
    
    return subTitleText;
}

@end
