//
//  StringCleaner.h
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringCleaner : NSObject

+ (NSString *)cleanifyPotentialString:(id)potentialString withKey:(NSString *)key;

@end
