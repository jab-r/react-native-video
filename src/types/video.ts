import type { ViewProps, NativeSyntheticEvent } from 'react-native';
import type { VideoNativeProps, VideoSrc } from '../specs/VideoNativeComponent';

type NativeVideoErrorData = {
  error: {
    errorString?: string;
    errorException?: string;
    errorStackTrace?: string;
    errorCode?: string;
    error?: string;
    code?: number;
    localizedDescription?: string;
    localizedFailureReason?: string;
    localizedRecoverySuggestion?: string;
    domain?: string;
  };
  target?: number;
};

type NativeLoadData = {
  currentTime: number;
  duration: number;
  naturalSize: {
    width: number;
    height: number;
    orientation: string;
  };
};

export interface ReactVideoProps extends Omit<VideoNativeProps, 'src'> {
  source: VideoSrc;
  onError?: (event: NativeSyntheticEvent<NativeVideoErrorData>) => void;
  onLoad?: (event: NativeSyntheticEvent<NativeLoadData>) => void;
}

export type { VideoSrc };
