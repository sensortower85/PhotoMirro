//
//  ShareViewController.m
//  PhotoMirror
//
//  Created by heliumsoft on 12/9/14.
//  Copyright (c) 2014 quantum. All rights reserved.
//

#import "ShareViewController.h"
#import "UIButton+Bootstrap.h"
#import "MBProgressHUD.h"
#import "Line.h"
#import "LKLineActivity.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize shareImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [rollButtton primaryStyle];

    [gramButton primaryStyle];

    [whatsButton primaryStyle];

    [lineButton primaryStyle];

    [moreButton primaryStyle];
    
    [shareImagePreview setImage: shareImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) homeAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (IBAction) shareRoll:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(self.shareImage, nil, nil, nil);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Photo Save Success";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (IBAction) shareInstagram:(id)sender
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        NSData *imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
        
        NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
        if (![imageData writeToFile:writePath atomically:YES]) {
            // failure
            NSLog(@"image save failed to path %@", writePath);
            return;
        } else {
            // success.
        }
        
        // send it to instagram.
        NSURL *fileURL = [NSURL fileURLWithPath:writePath];
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        self.documentController.delegate = self;
        [self.documentController setUTI:@"com.instagram.exclusivegram"];
        [self.documentController setAnnotation:@{@"InstagramCaption" : @"Made by PhotoMirror"}];
        [self.documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 320, 480) inView:self.view animated:YES];
    }
    else
    {
        NSLog (@"Instagram not found");
        
    }
}

- (IBAction) shareWhatsapp:(id)sender
{
    UIButton* whatbutton = (UIButton*)sender;
    UIActivityViewController* ac = [[UIActivityViewController alloc] initWithActivityItems:@[@"Made by PhotoMirror on Appstore", self.shareImage] applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:ac];
        [pop presentPopoverFromRect:whatbutton.frame inView:shareButtonContainerView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self.navigationController presentViewController:ac animated:YES completion:^{
        }];
    }
}

- (IBAction) shareLine:(id)sender
{
    [Line shareImage:self.shareImage];
}

- (IBAction) shareMore:(id)sender
{
    UIButton* btnMore = (UIButton*)sender;
    UIActivityViewController* ac = [[UIActivityViewController alloc] initWithActivityItems:@[@"Made by PhotoMirror on Appstore", self.shareImage] applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:ac];
        [pop presentPopoverFromRect:btnMore.frame inView:shareButtonContainerView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self.navigationController presentViewController:ac animated:YES completion:^{
        }];
    }
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}


@end
