/*
 * This file is a part of sample project which demonstrates how to use OpenCV
 * library with the XCode to write the iOS-based applications.
 * 
 * Written by Eugene Khvedchenya.
 * Distributed via GPL license. 
 * Support site: http://computer-vision-talks.com
 */

#import <Foundation/Foundation.h>
#import "ImageProcessingProtocol.h"

@interface ImageProcessingImpl : NSObject<ImageProcessingProtocol>
- (UIImage*) processImage:(UIImage*) src;
@end
