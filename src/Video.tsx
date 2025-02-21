import React from 'react';
import { requireNativeComponent } from 'react-native';
import type { VideoNativeProps, VideoSrc } from './specs/VideoNativeComponent';

const RCTVideo = requireNativeComponent<VideoNativeProps>('RCTVideo');

interface Props extends Omit<VideoNativeProps, 'src'> {
  source: VideoNativeProps['src'];
}

const Video = React.forwardRef<any, Props>((props, ref) => {
  const { source, ...rest } = props;
  return <RCTVideo {...rest} src={source} ref={ref} />;
});

Video.displayName = 'Video';

export default Video;
