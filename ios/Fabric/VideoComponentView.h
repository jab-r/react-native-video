#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoComponentView : RCTViewComponentView

// Event handling methods
- (void)handleVideoLoad:(NSDictionary *)event;
- (void)handleVideoError:(NSDictionary *)event;
- (void)handleVideoProgress:(NSDictionary *)event;

@end

NS_ASSUME_NONNULL_END