/*
 * This file is a part of sample project which demonstrates how to use OpenCV
 * library with the XCode to write the iOS-based applications.
 * 
 * Written by Eugene Khvedchenya.
 * Distributed via GPL license. 
 * Support site: http://computer-vision-talks.com
 */

#ifndef iOSplusOpenCV_OpenCVImageProcessor_h
#define iOSplusOpenCV_OpenCVImageProcessor_h

#include <boost/gil/gil_all.hpp>

// Note - at this points you can't include OpenCV headers since it will cause "Statement expressions ..." error.
// Just a hint how to do forward declarations of OpenCV types if you need them.
struct _IplImage;
typedef _IplImage IplImage;

class OpenCVImageProcessor
{
public:
  
  /**
   * Performs Canny filter on the source image and puts the processed image to the dst.
   * Preconditions: src and dst has equal dimensions.
   */
  void process(boost::gil::bgr8_view_t src, boost::gil::bgr8_view_t dst);
  
private:

  /**
   * Returns an IplImage structure that points to the same memory as the srcView.
   */
  IplImage getIplImageView(boost::gil::bgr8_view_t srcView);
  
  /**
   * Returns an IplImage structure that points to the same memory as the srcView.
   */
  IplImage getIplImageView(boost::gil::gray8_view_t srcView);
};

#endif
