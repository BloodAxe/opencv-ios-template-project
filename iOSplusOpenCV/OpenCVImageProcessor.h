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

struct _IplImage;
typedef _IplImage IplImage;

class OpenCVImageProcessor
{
public:
  void process(boost::gil::bgr8_view_t src, boost::gil::bgr8_view_t dst);
  
private:
  IplImage getIplImageView(boost::gil::bgr8_view_t srcView);
  IplImage getIplImageView(boost::gil::gray8_view_t srcView);
};

#endif
