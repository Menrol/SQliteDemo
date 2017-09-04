//
//  SQliteManager.m
//  SQlite演练OC
//
//  Created by Apple on 2017/9/1.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "SQliteManager.h"
#import <sqlite3.h>

@implementation SQliteManager {
    sqlite3 *_db;
    sqlite3_stmt *_stmt;
}

#pragma mark - 单例
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static SQliteManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[SQliteManager alloc] init];
    });
    
    return manager;
}

#pragma mark - 数据库相关操作
- (BOOL)open {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:@"text.db"];
    NSLog(@"%@",path);
    
    return sqlite3_open([path UTF8String], &_db) == SQLITE_OK;
}

- (void)createTable1 {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'T_Person' ( \n"
    "'id' integer NOT NULL PRIMARY KEY AUTOINCREMENT, \n"
    "'name' text, \n"
    "'age' integer, \n"
    "'height' real \n"
    ");";
    
    if ([self execSQLWithSQL:sql]) {
        NSLog(@"创表成功");
    }else {
        NSLog(@"创表失败");
    }
    
}

- (void)createTable2 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"db.sql" ofType:nil];
    NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if ([self execSQLWithSQL:sql]) {
        NSLog(@"创表成功");
    }else {
        NSLog(@"创表失败");
    }
    
}

- (BOOL)execSQLWithSQL:(NSString *)sql {
    return sqlite3_exec(_db, [sql UTF8String], nil, nil, nil) == SQLITE_OK;
}

- (NSInteger)execInsertWithSQL:(NSString *)sql {
    if (![self execSQLWithSQL:sql]) {
        NSLog(@"SQL错误");
        
        return -1;
    }
    
    return sqlite3_last_insert_rowid(_db);
}

- (NSInteger)execUpdateWithSQL:(NSString *)sql {
    if (![self execSQLWithSQL:sql]) {
        NSLog(@"SQL错误");
        
        return -1;
    }
    
    return sqlite3_changes(_db);
}

- (NSArray *)execRecordWithSQL:(NSString *)sql {
    // 预编译
    if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_stmt, nil) != SQLITE_OK) {
        // 释放stmt
        sqlite3_finalize(_stmt);
        
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // 遍历每一行
    while (sqlite3_step(_stmt) == SQLITE_ROW) {
        
        [array addObject:[self record]];
    }
    
    sqlite3_finalize(_stmt);
    return array;
}

- (NSDictionary *)record {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSInteger cols = sqlite3_column_count(_stmt);
    
    // 遍历每一列
    for (int i = 0; i < cols ; i++) {
        // 列名
        NSString *name = [NSString stringWithUTF8String:sqlite3_column_name(_stmt, i)];
        // 类型
        NSInteger type = sqlite3_column_type(_stmt, i);
        
        // 取值
        id value;
        switch (type) {
            case SQLITE_INTEGER:
                value = [NSNumber numberWithLongLong:sqlite3_column_int64(_stmt, i)];
                break;
            case SQLITE_FLOAT:
                value = [NSNumber numberWithDouble:sqlite3_column_double(_stmt, i)];
                break;
            case SQLITE_TEXT:
                value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(_stmt, i)];
                break;
            case SQLITE_NULL:
                value = [NSNull null];
                break;
            default:
                NSLog(@"无法识别的类型");
                break;
        }
        dic[name] = value;
    }
    return dic;
}



@end
