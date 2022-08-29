#import "SSDBManager.h"
#define dbPath "/var/mobile/Library/SMS/sms.db"

@interface SSDBManager()


@end

@implementation SSDBManager

+ (uint)rowCountForQuery:(NSString*)query{

    sqlite3 *smsDb;
    int dbOpenResult = sqlite3_open_v2(dbPath, &smsDb, SQLITE_OPEN_READONLY, NULL);;
    if(dbOpenResult != SQLITE_OK){
        NSLog(@"SSStats - Can't open Database - %s", sqlite3_errmsg(smsDb));
        return -1;
    }
    sqlite3_stmt *stmt;

    int rc = sqlite3_prepare_v2(smsDb, [query UTF8String], -1, &stmt, NULL);
    if(rc != SQLITE_OK){
        NSLog(@"SSStats - IDK something wrong - %s", sqlite3_errmsg(smsDb));
        return -1;
    }
    rc = sqlite3_step(stmt);
    if(rc != SQLITE_ROW){
        NSLog(@"SSStats - no rows found? - %s", sqlite3_errmsg(smsDb));
        return -1;
    }
    uint rowCount = sqlite3_column_int(stmt, 0);


    sqlite3_close(smsDb);
    return rowCount;
}

@end
