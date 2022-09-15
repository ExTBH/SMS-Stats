#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SSDBManager : NSObject
+ (NSString*)rowCountForQuery:(NSString*)query;
@end