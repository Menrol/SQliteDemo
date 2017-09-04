//
//  Person.m
//  SQlite演练OC
//
//  Created by Apple on 2017/9/1.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "Person.h"
#import "SQliteManager.h"

@interface Person ()
/** id */
@property(nonatomic, assign) NSInteger id;
/** 姓名 */
@property(nonatomic, copy) NSString *name;
/** 年龄 */
@property(nonatomic, assign) NSInteger age;
/** 身高 */
@property(nonatomic, assign) double height;

@end

@implementation Person

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

- (BOOL)insertPerson {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_Person (name, age, height) VALUES ('%@', %ld, %f);",_name, (long)_age, _height];
    _id = [[SQliteManager sharedManager] execInsertWithSQL:sql];
//    NSLog(@"新插入的id为 %ld",(long)_id);
    
    return _id > 0;
}

- (BOOL)updatePerson {
    NSString *sql = [NSString stringWithFormat: @"UPDATE T_Person SET name = '%@', age = %ld, height = %f WHERE id = %ld;",_name, (long)_age, _height, (long)_id];
    
    NSInteger rows = [[SQliteManager sharedManager] execUpdateWithSQL:sql];
    NSLog(@"改变行数为 %ld",(long)rows);
    
    return rows > 0;
}

- (BOOL)deletePerson {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_Person WHERE id = %ld;",(long)_id];
    
    NSInteger rows = [[SQliteManager sharedManager] execUpdateWithSQL:sql];
    NSLog(@"改变行数为 %ld",(long)rows);
    
    return rows > 0;
}

+ (NSArray *)persons {
    NSString *sql = @"SELECT id, name, age, height FROM T_Person;";
    NSMutableArray *persons = [[NSMutableArray alloc] init];
    
    NSArray *array = [[SQliteManager sharedManager] execRecordWithSQL:sql];
    for (NSDictionary *dic in array) {
        Person *p = [[Person alloc] initWithDictionary:dic];
        [persons addObject:p];
    }
    
    return persons;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"id: %ld, name: %@, age: %ld, height: %f", (long)_id, _name, (long)_age, _height];
}

@end
