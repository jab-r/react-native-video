#import "RCTVideoLogger.h"

@implementation RCTVideoLogger {
    BOOL hasListeners;
}

static RCTVideoLogger *sharedInstance = nil;

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (instancetype)init {
    if (self = [super init]) {
        sharedInstance = self;
    }
    return self;
}

+ (NSString *)moduleName {
    return @"VideoLogger";
}

- (void)setBridge:(RCTBridge *)bridge {
    [super setBridge:bridge];
    
    // Log that the module is ready
    dispatch_async(dispatch_get_main_queue(), ^{
        [RCTVideoLogger emitLogEvent:@"info" message:@"Native logger initialized" data:nil];
    });
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"VideoModuleLog"];
}

- (void)startObserving {
    hasListeners = YES;
}

- (void)stopObserving {
    hasListeners = NO;
}

+ (void)emitLogEvent:(NSString *)level message:(NSString *)message data:(NSDictionary *)data {
    if (!sharedInstance || !sharedInstance->hasListeners) return;
    
    NSMutableDictionary *eventBody = [NSMutableDictionary dictionary];
    [eventBody setObject:level forKey:@"level"];
    [eventBody setObject:message forKey:@"message"];
    if (data) {
        [eventBody setObject:data forKey:@"data"];
    }
    
    [sharedInstance sendEventWithName:@"VideoModuleLog" body:eventBody];
}

@end
