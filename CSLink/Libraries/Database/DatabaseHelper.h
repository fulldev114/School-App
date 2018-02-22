//
//  DatabaseHelper.h
//  DatabaseDemo
//
//  Created by Mayur on 16/05/15.
//  Copyright (c) 2015 eTechmavens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DatabaseHelper : NSObject
{
    FMDatabase *database;
}
+ (BOOL)createDatabaseFromAssets:(NSString *)databaseName ;
- (instancetype)init:(NSString *) databaseName;
- (void) openDatabase;
- (void) closeDatabase;

- (int) insertOrReplaceIntoTable:(NSString *)tblName Values:(NSMutableDictionary *)value;
- (int) insertIntoTable:(NSString *)tblName Values:(NSMutableDictionary *)value;
- (BOOL) updateTable:(NSString *)tblName Values:(NSMutableDictionary *)value WhereClause:(NSString *)where;
- (NSMutableArray *) executeSelectQuery:(NSString *) query;
- (BOOL) executeUpdateQuery:(NSString *) query;
- (BOOL) bulkInserIntoTable:(NSString *)table values:(NSMutableArray *)arrInserValues;
@end
