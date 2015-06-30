//
//  StringCleaner.m
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "StringCleaner.h"

@implementation StringCleaner

+ (NSString *)cleanifyPotentialString:(id)potentialString withKey:(NSString *)key {
    NSString *fallbackString = [NSString stringWithFormat:@"%@ 未知", key];
    
    if ([potentialString isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)potentialString;
        return string.length == 0 ? fallbackString : string;
    }
    
    else {
        return fallbackString;
    }
}

@end
