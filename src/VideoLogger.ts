import { NativeEventEmitter, NativeModules } from 'react-native';
import { logger } from '@/services/loggingService';

const { VideoLogger } = NativeModules;
let eventEmitter: NativeEventEmitter | null = null;
let isListenerSetup = false;

function setupEventListener() {
  if (!VideoLogger) {
    logger.warn('Native logger not available, will retry on next log attempt', undefined, 'VideoModule');
    return false;
  }

  if (isListenerSetup) {
    return true;
  }

  try {
    eventEmitter = new NativeEventEmitter(VideoLogger);
    eventEmitter.addListener('VideoModuleLog', (event) => {
      const { level, message, data } = event;
      switch (level) {
        case 'debug':
          logger.debug(message, data, 'VideoModule');
          break;
        case 'info':
          logger.info(message, data, 'VideoModule');
          break;
        case 'error':
          logger.error(message, data, 'VideoModule');
          break;
      }
    });
    isListenerSetup = true;
    return true;
  } catch (error) {
    logger.error('Failed to setup native logger', error, 'VideoModule');
    return false;
  }
}

// Export a function to ensure logger is ready
export async function ensureLoggerReady(): Promise<void> {
  return new Promise((resolve) => {
    const checkLogger = () => {
      if (VideoLogger) {
        setupEventListener();
        resolve();
      } else {
        setTimeout(checkLogger, 100);
      }
    };
    checkLogger();
  });
}

// Export a wrapped version that attempts to reconnect if needed
const videoLogger = {
  debug: (message: string, data?: object) => {
    if (!VideoLogger) {
      logger.warn('Native logger not available, retrying initialization...', undefined, 'VideoModule');
      const { VideoLogger: RefetchedLogger } = NativeModules;
      if (RefetchedLogger) {
        Object.assign(VideoLogger, RefetchedLogger);
        setupEventListener();
      }
    }
    if (VideoLogger?.debug) {
      VideoLogger.debug(message, data);
    }
    // Also log through loggingService directly
    logger.debug(message, data, 'VideoModule');
  },
  info: (message: string, data?: object) => {
    if (!VideoLogger) {
      logger.warn('Native logger not available, retrying initialization...', undefined, 'VideoModule');
      const { VideoLogger: RefetchedLogger } = NativeModules;
      if (RefetchedLogger) {
        Object.assign(VideoLogger, RefetchedLogger);
        setupEventListener();
      }
    }
    if (VideoLogger?.info) {
      VideoLogger.info(message, data);
    }
    // Also log through loggingService directly
    logger.info(message, data, 'VideoModule');
  },
  error: (message: string, data?: object) => {
    if (!VideoLogger) {
      logger.warn('Native logger not available, retrying initialization...', undefined, 'VideoModule');
      const { VideoLogger: RefetchedLogger } = NativeModules;
      if (RefetchedLogger) {
        Object.assign(VideoLogger, RefetchedLogger);
        setupEventListener();
      }
    }
    if (VideoLogger?.error) {
      VideoLogger.error(message, data);
    }
    // Also log through loggingService directly
    logger.error(message, data, 'VideoModule');
  }
};

export default videoLogger;
