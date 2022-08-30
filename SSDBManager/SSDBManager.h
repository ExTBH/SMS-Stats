#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SSDBManager : NSObject
+ (uint)rowCountForQuery:(NSString*)query;
@end