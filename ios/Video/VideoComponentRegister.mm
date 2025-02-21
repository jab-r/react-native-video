#import <React/RCTLog.h>
#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import <react/renderer/componentregistry/ComponentDescriptorProviderRegistry.h>
#import <react/renderer/componentregistry/ComponentDescriptorRegistry.h>
#import "VideoComponentDescriptor.h"

using namespace facebook::react;

@interface VideoComponentRegister : NSObject
@end

@implementation VideoComponentRegister

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        auto providerRegistry = std::make_shared<ComponentDescriptorProviderRegistry>();
        providerRegistry->add(concreteComponentDescriptorProvider<VideoComponentDescriptor>());
        
        RCTSetComponentDescriptorProviderRegistry(providerRegistry);
        
        [VideoComponentRegister registerViewComponent];
    });
}

+ (void)registerViewComponent
{
    auto const &providerRegistry = RCTGetComponentDescriptorProviderRegistry();
    if (!providerRegistry) {
        RCTLogError(@"Failed to get component descriptor registry");
        return;
    }
    
    auto const componentName = "RCTVideo";
    auto const componentDescriptor = providerRegistry->findComponentDescriptor(componentName);
    if (!componentDescriptor) {
        RCTLogError(@"Failed to find component descriptor for %s", componentName);
        return;
    }
}

@end