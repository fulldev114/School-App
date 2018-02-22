//
//  DatabaseHelper.m
//  DatabaseDemo
//
//  Created by Mayur on 16/05/15.
//  Copyright (c) 2015 eTechmavens. All rights reserved.
//

#import "DatabaseHelper.h"
#import "ParentConstant.h"

@implementation DatabaseHelper

+ (BOOL)createDatabaseFromAssets:(NSString *)databaseName {
    
    BOOL status = FALSE;
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    NSString *databasePath = [DatabaseHelper pathForFile:databaseName];
    
    if(![fileManager fileExistsAtPath:databasePath]) {
        NSString *fromPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        status = [fileManager copyItemAtPath:fromPath toPath:databasePath error:nil];
    }
    else {
        status = TRUE;
    }
    ZDebug(@"databasepath :%@", databasePath);
    return status;
}

+ (NSString *) pathForFile:(NSString *) fileName {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
            stringByAppendingPathComponent:fileName];
}

- (instancetype)init:(NSString *) databaseName {
    self = [super init];
    
    if (self) {
        
        NSString *databasePath = [DatabaseHelper pathForFile:databaseName];
        
        database = [FMDatabase databaseWithPath:databasePath];
        [self openDatabase];
    }
    
    return self;
}

- (void) openDatabase {
    if (![database open]) {
        NSLog(@"Database open error.");
    }
}

- (void) closeDatabase {
    if([database open])
        [database close];
}

- (int) insertOrReplaceIntoTable:(NSString *)tblName Values:(NSMutableDictionary *)value
{
    int lastInsertRowId = -1;
    
    @try {
        
        NSString *strData = [self formateDictToValue:value];
        
        NSString *strQuery = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ %@", tblName, strData];
        
        BOOL queryStatus = [database executeUpdate:strQuery];
        
        if(!queryStatus) {
            NSLog(@"executeUpdate > error: %@",[database lastErrorMessage]);
        }
        else {
            lastInsertRowId = (int)[database lastInsertRowId];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"insertIntoTable > exception: %@", exception);
    }
    
    return lastInsertRowId;
}

- (int) insertIntoTable:(NSString *)tblName Values:(NSMutableDictionary *)value
{
    int lastInsertRowId = -1;
    
    @try {
        
        NSString *strData = [self formateDictToValue:value];
        
        //NSString *strQuery = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ %@", tblName, strData];
        NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO %@ %@", tblName, strData];
        BOOL queryStatus = [database executeUpdate:strQuery];
        
        if(!queryStatus) {
            NSLog(@"executeUpdate > error: %@",[database lastErrorMessage]);
        }
        else {
            lastInsertRowId = (int)[database lastInsertRowId];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"insertIntoTable > exception: %@", exception);
    }
    
    return lastInsertRowId;
}

- (BOOL) updateTable:(NSString *)tblName Values:(NSMutableDictionary *)value WhereClause:(NSString *)where
{
    BOOL queryStatus = FALSE;
    @try {
        NSString *strData = [self formateDictForUpdate:value];
        
        NSString *strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE  %@", tblName, strData, where];
        
        queryStatus = [database executeUpdate:strQuery];
        
        if(!queryStatus) {
            NSLog(@"executeUpdateQuery > error: %@",[database lastErrorMessage]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"updateTable > exception: %@", exception);
    }
    
    return queryStatus;
}

- (NSMutableArray *) executeSelectQuery:(NSString *) query
{
    NSMutableArray *arrResultDict = [[NSMutableArray alloc] init];
    
    @try {
        
        FMResultSet *rs = [database executeQuery:query];
        
        while ([rs next]) {
            [arrResultDict addObject:[[NSMutableDictionary alloc] initWithDictionary:rs.resultDictionary]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"executeSelectQuery > exception: %@",exception );
    }
    
    return arrResultDict;
}

- (BOOL) executeUpdateQuery:(NSString *) query
{
    BOOL queryStatus = FALSE;
    
    @try {
        
        queryStatus = [database executeUpdate:query];
        
        if(!queryStatus) {
            NSLog(@"executeUpdateQuery > error: %@",[database lastErrorMessage]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"executeUpdateQuery exception: %@", exception);
    }
    
    return queryStatus;
}

- (NSString *) formateDictToValue:(NSMutableDictionary *) dictValue
{
    NSString *strValues = @"";
    
    NSArray *arrKeys = [dictValue allKeys];
    
    NSString *strKeys = @"(";
    NSString *strData = @"(";
    
    for (int i = 0; i < [arrKeys count]; i++) {
        
        strKeys = [strKeys stringByAppendingFormat:@"%@,", [arrKeys objectAtIndex:i]];
        
        NSString *value = [[dictValue valueForKey:[arrKeys objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        strData = [strData stringByAppendingFormat:@"'%@',", value];
    }
    
    strKeys = [strKeys substringToIndex:[strKeys length] - 1];
    strData = [strData substringToIndex:[strData length] - 1];
    
    strValues = [NSString stringWithFormat:@"%@) VALUES %@)", strKeys, strData];
    
    return strValues;
}

- (NSString *) formateDictForUpdate:(NSMutableDictionary *) dictValue
{
    NSString *strValues = @"";
    
    NSArray *arrKeys = [dictValue allKeys];
    
    for (int i = 0; i < [arrKeys count]; i++) {
        //strValues = [strValues stringByAppendingFormat:@"%@ = '%@',", [arrKeys objectAtIndex:i], [dictValue valueForKey:[arrKeys objectAtIndex:i]]];
        
        NSString *value = [[dictValue valueForKey:[arrKeys objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        strValues = [strValues stringByAppendingFormat:@"%@ = '%@',", [arrKeys objectAtIndex:i], value];
    }
    
    strValues = [strValues substringToIndex:[strValues length] - 1];
    
    return strValues;
}


- (BOOL) bulkInserIntoTable:(NSString *)table values:(NSMutableArray *)arrInserValues {
    
    BOOL status = FALSE;
    
    @try {
        
        FMResultSet *columnNamesSet = [database executeQuery:[NSString stringWithFormat:@"PRAGMA table_info(%@)", table]];
        NSMutableArray* columnNames = [[NSMutableArray alloc] init];
        
        while ([columnNamesSet next]) {
            [columnNames addObject:[columnNamesSet stringForColumn:@"name"]];
            
            //ZDebug(@"column Name: %@", [columnNamesSet stringForColumn:@"name"]);
        }
        
        NSString *columns = [NSString stringWithFormat:@"('%@')", [columnNames componentsJoinedByString:@"','"]];
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES ", table, columns];
        
        //ZDebug(@"query: %@", query);
        
        NSMutableString *appendData = [[NSMutableString alloc] init];
        
        for (NSMutableDictionary *dictRow in arrInserValues) {
            
            [appendData appendString:@" ("];
            
            for (NSString *strColumn in columnNames) {
                
                NSString *strText = [dictRow valueForKey:strColumn];
                
                if([strText class] == [NSNull class] || strText == NULL || [strText length] <= 0 || [strText isEqualToString:@"(null)"]) {
                    strText = @"";
                }
                
                strText = [strText stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                [appendData appendFormat:@" '%@',", strText];
            }
            
            NSString *str1 = [appendData substringToIndex:[appendData length] - 1];
            
            appendData = nil;
            appendData = [[NSMutableString alloc] initWithString:str1];
            
            str1 = nil;
            
            [appendData appendString:@"),"];
        }
        
        NSString *str = [appendData substringToIndex:[appendData length] - 1];
        
        appendData = nil;
        appendData = [[NSMutableString alloc] initWithString:str];
        
        str = nil;
        
        query = [query stringByAppendingFormat:@" %@", appendData];
        
        status = [self executeUpdateQuery:query];
    }
    @catch (NSException *exception) {
        NSLog(@"NSException: %@", [exception description]);
    }
    
    return status;
}

@end
