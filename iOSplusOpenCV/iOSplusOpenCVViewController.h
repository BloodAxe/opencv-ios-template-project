/*
 * This file is a part of sample project which demonstrates how to use OpenCV
 * library with the XCode to write the iOS-based applications.
 * 
 * Written by Eugene Khvedchenya.
 * Distributed via GPL license. 
 * Support site: http://computer-vision-talks.com
 */


#import <UIKit/UIKit.h>

@interface iOSplusOpenCVViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> 
{
  UIButton *mainButton;
}

@property (strong, nonatomic) IBOutlet UIButton *mainButton;
- (IBAction)buttonDidTapped:(id)sender;

@end
