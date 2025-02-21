import React, { useEffect, type ElementRef } from 'react';
import type { VideoNativeProps, VideoSrc } from './specs/VideoNativeComponent';
import VideoNativeComponent from './specs/VideoNativeComponent';
import { logger } from '@/services/loggingService';

interface Props extends Omit<VideoNativeProps, 'src'> {
  source: VideoSrc;
}

const Video = React.forwardRef<ElementRef<typeof VideoNativeComponent>, Props>((props, ref) => {
  const { source, ...rest } = props;

  useEffect(() => {
    logger.debug('Video component mounted', { source }, 'VideoModule');
    return () => {
      logger.debug('Video component unmounting', { source }, 'VideoModule');
    };
  }, [source]);

  useEffect(() => {
    logger.debug('Video props updated', { props }, 'VideoModule');
  }, [props]);

  logger.debug('Creating Video component', {
    source,
    props: rest,
    hasRef: !!ref,
    nativeComponent: true
  }, 'VideoModule');

  try {
    return <VideoNativeComponent {...rest} src={source} ref={ref} />;
  } catch (error) {
    logger.error('Failed to render Video component', error, 'VideoModule');
    return null;
  }
});

Video.displayName = 'Video';

export default Video;
