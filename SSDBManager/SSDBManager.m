#import "SSDBManager.h"
#define dbPath "/var/mobile/Library/SMS/sms.db"

@interface SSDBManager()

@end

@implementation SSDBManager

+ (NSString*)statsForGUID:(nullable NSString*)guid{
    //BOOL dbExists = [[NSFileManager new] fileExistsAtPath:@dbPath];
    sqlite3 *smsDb;
    BOOL dbOpenResult = sqlite3_open_v2(dbPath, &smsDb, SQLITE_OPEN_READONLY, NULL);;
    if(dbOpenResult == SQLITE_OK){
        NSLog(@"SSDataBase opened ? %d", dbOpenResult);
    }

    sqlite3_close(smsDb);
    return @"Success";
}

@end
e