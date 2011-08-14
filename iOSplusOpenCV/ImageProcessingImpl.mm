/*
 * This file is a part of sample project which demonstrates how to use OpenCV
 * library with the XCode to write the iOS-based applications.
 * 
 * Written by Eugene Khvedchenya.
 * Distributed via GPL license. 
 * Support site: http://computer-vision-talks.com
 */

#import "ImageProcessingImpl.h"
#import "OpenCVImageProcessor.h"

@implementation ImageProcessingImpl

template <typename View1, typename View2>
void copy_with_regards_to_orientation(View1 sourceView, View2 dstView, UIImageOrientation orientation)
{
  using namespace boost::gil;
  
  switch (orientation)
  {
    case UIImageOrientationLeft:
      copy_and_convert_pixels(rotated90ccw_view(sourceView), dstView);
      break;
      
    case UIImageOrientationRight:
      copy_and_convert_pixels(rotated90cw_view(sourceView), dstView);
      break;
      
    case UIImageOrientationDown:
      copy_and_convert_pixels(rotated180_view(sourceView), dstView);
      break;
      
    default:
      copy_and_convert_pixels(sourceView, dstView);
      break;
  }
}

/**
 * Converts UIImage to Boost::Gil image holder.
 */
- (boost::gil::bgr8_image_t) convertUIImageToGILImage:(UIImage*) input
{
  boost::gil::bgr8_image_t result;
  
  using namespace boost::gil;
  
  CGImageRef imageRef = input.CGImage;
  
  const int srcWidth        = CGImageGetWidth(imageRef);
  const int srcHeight       = CGImageGetHeight(imageRef);
  const int stride          = CGImageGetBytesPerRow(imageRef);
  const int bitPerPixel     = CGImageGetBitsPerPixel(imageRef);
  const int bitPerComponent = CGImageGetBitsPerComponent(imageRef);
  const int numPixels       = bitPerPixel / bitPerComponent;
  
  CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
  CFDataRef rawData = CGDataProviderCopyData(dataProvider);
  
  const UInt8 * dataPtr = CFDataGetBytePtr(rawData);
  
  UIImageOrientation orientation = input.imageOrientation;
  
  int dstWidth = srcWidth;
  int dstHeight = srcHeight;
  
  if (orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight)
  {
    std::swap(dstWidth, dstHeight); // swap width and height since we have to rotate image to 90 degrees.
  }
  
  if (result.width() != dstWidth || result.height() != dstHeight)
  {
    result.recreate(dstWidth, dstHeight);
  }
  
  if (numPixels == 4 && bitPerComponent == 8)
  {
    bgra8_view_t sourceView = interleaved_view(srcWidth, srcHeight,(bgra8_pixel_t*)dataPtr, stride);
    copy_with_regards_to_orientation(sourceView, view(result), orientation);
  }
  else if(numPixels == 3 && bitPerComponent == 8)
  {
    bgr8_view_t sourceView = interleaved_view(srcWidth, srcHeight,(bgr8_pixel_t*)dataPtr, stride);
    copy_with_regards_to_orientation(sourceView, view(result), orientation);
  }
  else if(numPixels == 1 && bitPerComponent == 8) // Assume gray pixel
  {
    // assume grayscale image
    gray8_view_t sourceView = interleaved_view(srcWidth, srcHeight,(gray8_pixel_t*)dataPtr, stride);
    copy_with_regards_to_orientation(sourceView, view(result), orientation);
  }
  else
  {
    NSLog(@"Unsupported format of the input UIImage (neither BGRA, BGR or GRAY)");
  }
  
  CFRelease(rawData);
  
  return result;
}

/**
 * Converts Boost::Gil image to UIImage.
 */
- (UIImage*) convertGILImageToUIImage: (boost::gil::bgr8_image_t&) input
{
  using namespace boost::gil;
  
  const int width            = input.width();
  const int height           = input.height();
  const int numChannels      = 3; 
  const int bitsPerComponent = 8;
  const int bitsPerPixel     = numChannels * bitsPerComponent;
  const int bytesPerRow      = input._view.xy_at(0,0).row_size();  
  void * rawData             = &input._view.begin()[0];
  
  NSData *data = [[NSData alloc] initWithBytes:rawData length:width * height * numChannels];
  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
  
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo       = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
  
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  CGImageRef imageRef = CGImageCreate(width,
                                      height,
                                      bitsPerComponent,
                                      bitsPerPixel,
                                      bytesPerRow,
                                      colorSpaceRef,
                                      bitmapInfo,
                                      provider,NULL,NO,renderingIntent);
  
  // Getting UIImage from CGImage
  UIImage *ret = [[UIImage alloc] initWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpaceRef);
    
  return ret;
}

/**
 * The main processing function
 */
- (UIImage*) processImage:(UIImage*) src
{
  OpenCVImageProcessor processor;

  // Convert source image from UIImage to Boost::Gil for further processing.
  boost::gil::bgr8_image_t srcImage = [self convertUIImageToGILImage:src];
  boost::gil::bgr8_image_t dstImage(srcImage.dimensions());

  // Delegate the call
  processor.process(view(srcImage), view(dstImage));

  // Convert result image back to UIImage
  return [self convertGILImageToUIImage:dstImage];
}

@end
