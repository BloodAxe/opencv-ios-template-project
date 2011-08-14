/*
 * This file is a part of sample project which demonstrates how to use OpenCV
 * library with the XCode to write the iOS-based applications.
 * 
 * Written by Eugene Khvedchenya.
 * Distributed via GPL license. 
 * Support site: http://computer-vision-talks.com
 */

#import "iOSplusOpenCVViewController.h"
#import "iOSplusOpenCVAppDelegate.h"

@implementation iOSplusOpenCVViewController
@synthesize mainButton;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
  [self setMainButton:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

#pragma mark - Selecting image from photo album

- (void) buttonDidTapped:(id)sender
{
  // When the user taps on screen we present the image picker dialog to select the input image
  UIImagePickerController * picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentModalViewController:picker animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate implementation

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
  [picker dismissModalViewControllerAnimated:YES];
  
  iOSplusOpenCVAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
  
  // Process the input image and present the result:
  UIImage * processedImage = [appDelegate.imageProcessor processImage:image];
  self.mainButton.imageView.image = processedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissModalViewControllerAnimated:YES];
}

@end
