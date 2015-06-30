//
//  Member.m
//  Calendar
//
//  Created by emma on 15/6/10.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "Member.h"

@implementation Member

- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic != nil) {
            self.name = [dic objectForKey:@"name"];
            self.school = [dic objectForKey:@"school"];
            self.ID = [dic objectForKey:@"ID"];
            self.something = [dic objectForKey:@"something"];
            self.head = [dic objectForKey:@"head"];

        }
    }
    
    return self;
}

- (NSString *)description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"name : %@\n",self.name];
    result = [result stringByAppendingFormat:@"school : %@\n",self.school];
    result = [result stringByAppendingFormat:@"ID : %@\n",self.ID];
    result = [result stringByAppendingFormat:@"something : %@\n",self.something];
    result = [result stringByAppendingFormat:@"head : %@\n",self.head];
    return result;
}

@end
