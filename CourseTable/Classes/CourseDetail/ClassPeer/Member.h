//
//  Member.h
//  Calendar
//
//  Created by emma on 15/6/10.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Member : NSObject

@property (nonatomic, copy) NSString     *name;
@property (nonatomic, copy) NSString     *school;
@property (nonatomic, copy) NSString     *ID;
@property (nonatomic, copy) NSString     *something;
@property (nonatomic, copy) UIImage      *head;

- (id)initWithPropertiesDictionary:(NSDictionary *)dic;

@end
