import type { ViewProps, NativeSyntheticEvent } from 'react-native';
import type {
  VideoNativeProps,
  VideoSrc,
  OnLoadStartData,
  OnBufferData,
  OnProgressData,
  OnSeekData,
  OnVideoErrorData,
  OnVideoAspectRatioData,
  OnBandwidthUpdateData,
  OnTimedMetadataData,
  OnAudioTracksData,
  OnVideoTracksData,
  OnTextTrackDataChangedData,
  OnPictureInPictureStatusChangedData,
  OnAudioFocusChangedData,
  OnControlsVisibilityChange,
  OnExternalPlaybackChangeData,
  OnGetLicenseData
} from '../specs/VideoNativeComponent';

export enum ViewType {
  NONE = 0,
  TEXTURE = 1,
  SURFACE = 2,
  SURFACE_SECURE = 3,
}

export enum CmcdMode {
  MODE_QUERY_PARAMETER = 1,
  MODE_HEADER = 2,
}

export interface CmcdData {
  [key: string]: string;
}

export interface VideoRef {
  seek: (time: number, tolerance?: number) => void;
  pause: () => void;
  resume: () => void;
  setVolume: (volume: number) => void;
  setFullScreen: (fullscreen: boolean) => void;
  presentFullscreenPlayer: () => void;
  dismissFullscreenPlayer: () => void;
  enterPictureInPicture: () => Promise<void>;
  exitPictureInPicture: () => Promise<void>;
  restoreUserInterfaceForPictureInPictureStopCompleted: (restored: boolean) => void;
  save: (options: object) => Promise<void>;
  getCurrentPosition: () => Promise<number>;
  setSource: (source?: ReactVideoSource) => void;
}

export interface OnLoadData {
  currentTime: number;
  duration: number;
  naturalSize: {
    width: number;
    height: number;
    orientation: string;
  };
  audioTracks: Array<{
    index: number;
    title?: string;
    language?: string;
    bitrate?: number;
    type?: string;
    selected?: boolean;
  }>;
  textTracks: Array<{
    index: number;
    title?: string;
    language?: string;
    type?: string;
    selected?: boolean;
  }>;
}

export interface OnTextTracksData {
  textTracks: Array<{
    index: number;
    title?: string;
    language?: string;
    type?: string;
    selected?: boolean;
  }>;
}

export interface OnReceiveAdEventData {
  data?: Record<string, unknown>;
  event: string;
}

export type ReactVideoSource = number | VideoSrc;

export interface ReactVideoProps extends Omit<VideoNativeProps, 'src'> {
  source: ReactVideoSource;
  style?: ViewProps['style'];
  onLoad?: (event: NativeSyntheticEvent<OnLoadData>) => void;
  onLoadStart?: (event: NativeSyntheticEvent<OnLoadStartData>) => void;
  onBuffer?: (event: NativeSyntheticEvent<OnBufferData>) => void;
  onError?: (event: NativeSyntheticEvent<OnVideoErrorData>) => void;
  onProgress?: (event: NativeSyntheticEvent<OnProgressData>) => void;
  onSeek?: (event: NativeSyntheticEvent<OnSeekData>) => void;
  onEnd?: () => void;
  onFullscreenPlayerWillPresent?: () => void;
  onFullscreenPlayerDidPresent?: () => void;
  onFullscreenPlayerWillDismiss?: () => void;
  onFullscreenPlayerDidDismiss?: () => void;
  onReadyForDisplay?: () => void;
  onPlaybackRateChange?: (event: NativeSyntheticEvent<{ playbackRate: number }>) => void;
  onAudioBecomingNoisy?: () => void;
  onPictureInPictureStatusChanged?: (event: NativeSyntheticEvent<OnPictureInPictureStatusChangedData>) => void;
  onRestoreUserInterfaceForPictureInPictureStop?: () => void;
  onAudioFocusChanged?: (event: NativeSyntheticEvent<OnAudioFocusChangedData>) => void;
  onBandwidthUpdate?: (event: NativeSyntheticEvent<OnBandwidthUpdateData>) => void;
  onExternalPlaybackChange?: (event: NativeSyntheticEvent<OnExternalPlaybackChangeData>) => void;
  onGetLicense?: (event: NativeSyntheticEvent<OnGetLicenseData>) => void;
  onPlaybackStateChanged?: (event: NativeSyntheticEvent<{ isPlaying: boolean }>) => void;
  onAspectRatio?: (event: NativeSyntheticEvent<OnVideoAspectRatioData>) => void;
  onTimedMetadata?: (event: NativeSyntheticEvent<OnTimedMetadataData>) => void;
  onAudioTracks?: (event: NativeSyntheticEvent<OnAudioTracksData>) => void;
  onTextTracks?: (event: NativeSyntheticEvent<OnTextTracksData>) => void;
  onTextTrackDataChanged?: (event: NativeSyntheticEvent<OnTextTrackDataChangedData>) => void;
  onVideoTracks?: (event: NativeSyntheticEvent<OnVideoTracksData>) => void;
  onControlsVisibilityChange?: (event: NativeSyntheticEvent<OnControlsVisibilityChange>) => void;
}

export type { VideoSrc };
