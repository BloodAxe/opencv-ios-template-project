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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [self setMainButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
  // Do any additional setup after loading the view, typically from a nib.
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
  
  UIImage * processedImage = [appDelegate.imageProcessor processImage:image];
  self.mainButton.imageView.image = processedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissModalViewControllerAnimated:NO];
  [self dismissModalViewControllerAnimated:NO];
}

@end
