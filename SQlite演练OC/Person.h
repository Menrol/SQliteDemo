//
//  Person.h
//  SQlite演练OC
//
//  Created by Apple on 2017/9/1.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (BOOL)insertPerson;

- (BOOL)updatePerson;

- (BOOL)deletePerson;

+ (NSArray *)persons;

@end
