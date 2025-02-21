#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

@interface RCTVideoLogger : RCTEventEmitter <RCTBridgeModule>
+ (void)emitLogEvent:(NSString *)level message:(NSString *)message data:(NSDictionary *)data;
@end
