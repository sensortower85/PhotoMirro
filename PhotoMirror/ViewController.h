//
//  ViewController.h
//  PhotoMirror
//
//  Created by heliumsoft on 12/9/14.
//  Copyright (c) 2014 quantum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIPopoverController* _popOverController;
}

- (IBAction) galleryAction:(id)sender;
- (IBAction) cameraAction:(id)sender;

@end

