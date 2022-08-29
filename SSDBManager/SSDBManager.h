#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SSDBManager : NSObject
+ (nonnull NSString*)statsForGUID:(nullable NSString*)guid;
@end