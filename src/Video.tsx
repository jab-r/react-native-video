import React, { useEffect, useState, type ElementRef } from 'react';
import type { VideoNativeProps, VideoSrc } from './specs/VideoNativeComponent';
import VideoNativeComponent from './specs/VideoNativeComponent';
import { logger } from '@/services/loggingService';
import { ensureLoggerReady } from './VideoLogger';

interface Props extends Omit<VideoNativeProps, 'src'> {
  source: VideoSrc;
}

const Video = React.forwardRef<ElementRef<typeof VideoNativeComponent>, Props>((props, ref) => {
  const { source, ...rest } = props;

  // Initialize logger in background
  useEffect(() => {
    ensureLoggerReady();
  }, []);

  // Always log through loggingService
  logger.debug('Creating Video component', {
    source,
    props: rest,
    hasRef: !!ref,
    nativeComponent: true
  }, 'VideoModule');

  useEffect(() => {
    logger.debug('Video component mounted', { source }, 'VideoModule');
    return () => {
      logger.debug('Video component unmounting', { source }, 'VideoModule');
    };
  }, [source]);

  useEffect(() => {
    logger.debug('Video props updated', { props }, 'VideoModule');
  }, [props]);

  return <VideoNativeComponent {...rest} src={source} ref={ref} />;
});

Video.displayName = 'Video';

export default Video;
