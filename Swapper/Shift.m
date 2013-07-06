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
    [formatter setDateFormat:@"MMM d"];
    NSString *dateAsString = [formatter stringFromDate:shift.date];
    [formatter setDateFormat:@"h:m"];
    NSString *timeAsString = [formatter stringFromDate:shift.date];
    NSString *titleText = dateAsString;
    NSString *hours = [NSString stringWithFormat:@"%d hrs", shift.duration];
    
    titleText = [titleText stringByAppendingString:@" @ "];
    titleText = [titleText stringByAppendingString:timeAsString];
    titleText = [titleText stringByAppendingString:@", "];
    titleText = [titleText stringByAppendingString:hours];
    
    return titleText;
}

- (NSString *)formatSubTitle:(Shift *)shift
{
    NSString *subTitleText = shift.name;
    subTitleText = [subTitleText stringByAppendingString:@", "];
    subTitleText = [subTitleText stringByAppendingString:shift.location];
    subTitleText = [subTitleText stringByAppendingString:@" "];
    subTitleText = [subTitleText stringByAppendingString:shift.locationDetail];
    
    return subTitleText;
}

@end
