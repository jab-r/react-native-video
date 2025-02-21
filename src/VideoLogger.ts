import { NativeEventEmitter, NativeModules } from 'react-native';

const { VideoLogger } = NativeModules;
let eventEmitter: NativeEventEmitter | null = null;
let isListenerSetup = false;

function setupEventListener() {
  if (!VideoLogger) {
    console.warn('[VideoModule] Native logger not available, will retry on next log attempt');
    return false;
  }

  if (isListenerSetup) {
    return true;
  }

  try {
    eventEmitter = new NativeEventEmitter(VideoLogger);
    eventEmitter.addListener('VideoModuleLog', (event) => {
      const { level, message, data } = event;
      const formattedData = data ? JSON.stringify(data, null, 2) : '';
      const logMessage = `[VideoModule] ${message}${formattedData ? ' ' + formattedData : ''}`;
      
      switch (level) {
        case 'debug':
          console.debug(logMessage);
          break;
        case 'info':
          console.info(logMessage);
          break;
        case 'error':
          console.error(logMessage);
          break;
        default:
          console.log(logMessage);
      }
    });
    isListenerSetup = true;
    return true;
  } catch (error) {
    console.warn('[VideoModule] Failed to setup native logger:', error);
    return false;
  }
}

// Try initial setup
setupEventListener();

// Export a wrapped version that attempts to reconnect if needed
const logger = {
  debug: (message: string, data?: object) => {
    if (!VideoLogger) {
      console.warn('[VideoModule] Native logger not available, retrying initialization...');
      const { VideoLogger: RefetchedLogger } = NativeModules;
      if (RefetchedLogger) {
        Object.assign(VideoLogger, RefetchedLogger);
        setupEventListener();
      }
    }
    if (VideoLogger?.debug) {
      VideoLogger.debug(message, data);
    }
  },
  info: (message: string, data?: object) => {
    if (!VideoLogger) {
      console.warn('[VideoModule] Native logger not available, retrying initialization...');
      const { VideoLogger: RefetchedLogger } = NativeModules;
      if (RefetchedLogger) {
        Object.assign(VideoLogger, RefetchedLogger);
        setupEventListener();
      }
    }
    if (VideoLogger?.info) {
      VideoLogger.info(message, data);
    }
  },
  error: (message: string, data?: object) => {
    if (!VideoLogger) {
      console.warn('[VideoModule] Native logger not available, retrying initialization...');
      const { VideoLogger: RefetchedLogger } = NativeModules;
      if (RefetchedLogger) {
        Object.assign(VideoLogger, RefetchedLogger);
        setupEventListener();
      }
    }
    if (VideoLogger?.error) {
      VideoLogger.error(message, data);
    }
  }
};

export default logger;
