import { NativeModules, NativeEventEmitter } from 'react-native';
import { logger } from '@/services/loggingService';

const { RCTVideoManager } = NativeModules;

logger.debug('Initializing RCTVideoManager native module', {
  hasNativeModule: !!RCTVideoManager,
  availableMethods: RCTVideoManager ? Object.keys(RCTVideoManager) : [],
}, 'VideoModule');

if (!RCTVideoManager) {
  logger.error('RCTVideoManager native module not found', {
    availableModules: Object.keys(NativeModules),
  }, 'VideoModule');
  throw new Error('RCTVideoManager native module not found');
}

const eventEmitter = new NativeEventEmitter(RCTVideoManager);

logger.debug('RCTVideoManager event emitter created', {
  hasEventEmitter: !!eventEmitter,
}, 'VideoModule');

export default {
  ...RCTVideoManager,
  addListener: (eventType: string, listener: (event: any) => void) => {
    logger.debug('Adding listener to RCTVideoManager', {
      eventType,
      hasListener: !!listener,
    }, 'VideoModule');
    return eventEmitter.addListener(eventType, listener);
  },
  removeAllListeners: (eventType: string) => {
    logger.debug('Removing all listeners from RCTVideoManager', {
      eventType,
    }, 'VideoModule');
    eventEmitter.removeAllListeners(eventType);
  },
};
