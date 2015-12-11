//
//  EditViewController.h
//  PhotoMirror
//
//  Created by heliumsoft on 12/9/14.
//  Copyright (c) 2014 quantum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface EditViewController : UIViewController
{
    UIImage* orgImage;
    
    IBOutlet UIImageView* previewImageView;
    IBOutlet UIScrollView* toolbarView;
    
    CGPoint prevTouchPos;
    BOOL touchRightDirection;
    BOOL touchTopDirection;
}

@property(nonatomic, retain) UIImage* orgImage;

- (IBAction) backAction:(id)sender;
- (IBAction) shareAction:(id)sender;

@end
