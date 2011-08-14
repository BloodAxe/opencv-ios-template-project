/*
 * This file is a part of sample project which demonstrates how to use OpenCV
 * library with the XCode to write the iOS-based applications.
 * 
 * Written by Eugene Khvedchenya.
 * Distributed via GPL license. 
 * Support site: http://computer-vision-talks.com
 */

#include "OpenCVImageProcessor.h"

#include <opencv2/opencv.hpp>
#include <boost/assert.hpp>

// A helper macro
#define GIL2CV(GilView) getIplImageView(GilView)

void OpenCVImageProcessor::process(boost::gil::bgr8_view_t src, boost::gil::bgr8_view_t dst)
{
  BOOST_ASSERT(src.dimensions() == dst.dimensions());
  
  boost::gil::gray8_image_t srcGray(src.dimensions());
  boost::gil::gray8_image_t edges(src.dimensions());
  
  IplImage srcIplImage     = GIL2CV(src);
  IplImage srcGrayIplImage = GIL2CV(srcGray._view);
  IplImage edgesIplImage   = GIL2CV(edges._view);
  IplImage dstIplImage     = GIL2CV(dst);
  
  cvCvtColor(&srcIplImage, &srcGrayIplImage, CV_BGR2GRAY);
  
  cvCanny(&srcGrayIplImage, &edgesIplImage, 10, 50);

  cvCvtColor(&edgesIplImage, &dstIplImage, CV_GRAY2BGR);
}

IplImage OpenCVImageProcessor::getIplImageView(boost::gil::bgr8_view_t srcView)
{
  IplImage img;
  cvInitImageHeader(&img, cvSize(srcView.width(), srcView.height()), IPL_DEPTH_8U, 3, 0);
  img.imageData = (char*)&srcView.begin()[0];
  img.widthStep = srcView.xy_at(0,0).row_size();
    
  return img;
}

IplImage OpenCVImageProcessor::getIplImageView(boost::gil::gray8_view_t srcView)
{
  IplImage img;
  
  cvInitImageHeader(&img, cvSize(srcView.width(), srcView.height()), IPL_DEPTH_8U, 1, 0);
  img.imageData = (char*)&srcView.begin()[0];
  img.widthStep = srcView.xy_at(0,0).row_size();

  return img;
}
