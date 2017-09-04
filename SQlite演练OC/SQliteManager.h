//
//  SQliteManager.h
//  SQlite演练OC
//
//  Created by Apple on 2017/9/1.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQliteManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)open;

- (BOOL)execSQLWithSQL:(NSString *)sql;

- (void)createTable1;

- (void)createTable2;

- (NSInteger)execInsertWithSQL:(NSString *)sql;

- (NSInteger)execUpdateWithSQL:(NSString *)sql;

- (NSArray *)execRecordWithSQL:(NSString *)sql;

@end
