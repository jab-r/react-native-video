#import <UIKit/UIKit.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoComponentView : RCTViewComponentView <RCTVideoComponentViewProtocol>

// Props
@property (nonatomic, copy) NSDictionary *src;
@property (nonatomic, assign) BOOL controls;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, assign) float volume;
@property (nonatomic, copy) NSString *resizeMode;
@property (nonatomic, assign) BOOL repeat;
@property (nonatomic, assign) float rate;

// Event handling methods
- (void)handleVideoLoad:(NSDictionary *)event;
- (void)handleVideoError:(NSDictionary *)event;
- (void)handleVideoProgress:(NSDictionary *)event;

@end

NS_ASSUME_NONNULL_END

#else
NS_ASSUME_NONNULL_BEGIN

@interface VideoComponentView : UIView

@end

NS_ASSUME_NONNULL_END
#endif