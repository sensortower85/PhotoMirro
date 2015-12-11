//
//  ShareViewController.h
//  PhotoMirror
//
//  Created by heliumsoft on 12/9/14.
//  Copyright (c) 2014 quantum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController<UIPopoverControllerDelegate, UIDocumentInteractionControllerDelegate>
{
    UIImage* shareImage;
    
    IBOutlet UIImageView* shareImagePreview;
    
    IBOutlet UIView* shareButtonContainerView;
    
    IBOutlet UIButton* rollButtton;
    IBOutlet UIButton* gramButton;
    IBOutlet UIButton* whatsButton;
    IBOutlet UIButton* lineButton;
    IBOutlet UIButton* moreButton;
}

@property (nonatomic, retain) UIImage* shareImage;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

- (IBAction) backAction:(id)sender;
- (IBAction) homeAction:(id)sender;

- (IBAction) shareRoll:(id)sender;
- (IBAction) shareInstagram:(id)sender;
- (IBAction) shareWhatsapp:(id)sender;
- (IBAction) shareLine:(id)sender;
- (IBAction) shareMore:(id)sender;

@end
