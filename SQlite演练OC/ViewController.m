//
//  ViewController.m
//  SQlite演练OC
//
//  Created by Apple on 2017/9/1.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "ViewController.h"
#import "SQliteManager.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createDemo1];
//    [self createDemo2];
//    [self insertDemo];
//    [self deleteDemo];
//    [self updateDemo];
//    [self persons];
    [self Demo];
}

- (void)Demo {
    // 性能测试
    float start = CACurrentMediaTime();
    
    // 开启事务
    [[SQliteManager sharedManager] execSQLWithSQL:@"BEGIN TRANSACTION;"];
    
    for (int i = 0; i < 100000; i++) {
        Person *p = [[Person alloc] initWithDictionary:@{@"name": [NSString stringWithFormat:@"李四 - %d",i], @"age": @(18), @"height": @(180)}];
        if (![p insertPerson]) {
            // 回滚
            [[SQliteManager sharedManager] execSQLWithSQL:@"ROLLBACK TRANSACTION;"];
        }
    }
    // 关闭事务
    [[SQliteManager sharedManager] execSQLWithSQL:@"COMMIT TRANSACTION;"];
    
    NSLog(@"%f",CACurrentMediaTime() - start);
}

- (void)createDemo1 {
    [[SQliteManager sharedManager] createTable1];
}

- (void)createDemo2 {
    [[SQliteManager sharedManager] createTable2];
}

- (void)insertDemo {
    Person *p = [[Person alloc] initWithDictionary:@{@"name": @"张三", @"age": @(18), @"height": @(180)}];
    if ([p insertPerson]) {
        NSLog(@"插入成功");
    }else {
        NSLog(@"插入失败");
    }
}

- (void)deleteDemo {
    Person *p = [[Person alloc]initWithDictionary:@{@"id": @(2)}];
    
    if ([p deletePerson]) {
        NSLog(@"删除成功");
    }else {
        NSLog(@"删除失败");
    }
}

- (void)updateDemo {
    Person *p = [[Person alloc] initWithDictionary:@{@"id": @(4), @"name": @"老王", @"age": @(20), @"height": @(185)}];
    
    if ([p updatePerson]) {
        NSLog(@"更新成功");
    }else {
        NSLog(@"更新失败");
    }
}

- (void)persons {
    NSArray *array = [Person persons];
    
    NSLog(@"%@",array);
}


@end
