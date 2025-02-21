#import <React/RCTLog.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import <react/renderer/componentregistry/ComponentDescriptorProviderRegistry.h>
#import <react/renderer/componentregistry/ComponentDescriptorRegistry.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import <VideoModule/VideoComponentDescriptor.h>
#endif

#import "VideoComponentView.h"

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;

@interface RCTVideoComponentRegister : NSObject
@end

@implementation RCTVideoComponentRegister

+ (void)load
{
    RCTLogInfo(@"[VideoModule] Registering Fabric component");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        auto providerRegistry = std::make_shared<ComponentDescriptorProviderRegistry>();
        providerRegistry->add(concreteComponentDescriptorProvider<VideoComponentDescriptor>());
        
        RCTSetFabricComponentsRegistry(providerRegistry);
        RCTLogInfo(@"[VideoModule] Successfully registered Fabric component");
    });
}

@end

Class<RCTComponentViewProtocol> RCTVideoCls(void)
{
    return VideoComponentView.class;
}
#endif