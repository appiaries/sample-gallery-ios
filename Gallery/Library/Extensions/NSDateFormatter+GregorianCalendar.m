//
//  NSDateFormatter+GregorianCalendar.m
//  Gallery
//
//  Created by Appiaries Corporation on 2014/05/21.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "NSDateFormatter+GregorianCalendar.h"

@implementation NSDateFormatter (GregorianCalendar)

#pragma mark - Initialization
- (id)initWithGregorianCalendar {
    self = [self init];
    if (self) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [self setLocale:[NSLocale systemLocale]];
        [self setTimeZone:[NSTimeZone systemTimeZone]];
        [self setCalendar:calendar];
    }
    return self;
}

@end
