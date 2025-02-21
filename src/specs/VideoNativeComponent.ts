import type {ViewProps} from 'react-native';
import type {
  BubblingEventHandler,
  DirectEventHandler,
  Int32,
  Double,
  Float,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type {HostComponent} from 'react-native';

export interface VideoSrc {
  uri?: string;
  isNetwork?: boolean;
  isAsset?: boolean;
  type?: string;
}

export interface VideoNativeProps extends ViewProps {
  // Props
  src?: VideoSrc;
  controls?: boolean;
  paused?: boolean;
  muted?: boolean;
  volume?: Float;
  resizeMode?: WithDefault<string, 'contain'>;
  repeat?: boolean;
  rate?: Float;
  
  // Events
  onVideoLoad?: DirectEventHandler<{
    duration: Double;
    currentTime: Double;
    naturalSize: {
      width: Float;
      height: Float;
      orientation: string;
    };
  }>;
  
  onVideoError?: DirectEventHandler<{
    error: {
      code: Int32;
      domain: string;
      localizedDescription: string;
    };
  }>;
  
  onVideoProgress?: DirectEventHandler<{
    currentTime: Double;
    playableDuration: Double;
    seekableDuration: Double;
  }>;
  
  onVideoSeek?: DirectEventHandler<{
    currentTime: Double;
    seekTime: Double;
  }>;
  
  onVideoEnd?: DirectEventHandler<{}>;
  
  onVideoBuffer?: DirectEventHandler<{
    isBuffering: boolean;
  }>;
  
  onPlaybackRateChange?: DirectEventHandler<{
    playbackRate: Float;
  }>;
}

export default codegenNativeComponent<VideoNativeProps>('RCTVideo', {
  paperComponentName: 'RCTVideo',
  excludedPlatforms: [],
}) as HostComponent<VideoNativeProps>;
