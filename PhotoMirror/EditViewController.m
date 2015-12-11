//
//  EditViewController.m
//  PhotoMirror
//
//  Created by heliumsoft on 12/9/14.
//  Copyright (c) 2014 quantum. All rights reserved.
//

#import "EditViewController.h"
#import "ShareViewController.h"
#import "PECropViewController.h"
#import "GenReflectImage.h"
enum
{
    k2D = 0,
    k3D,
    kScale,
    kFilter,
    kCrop,
    kToolbarOption_Count
};

@interface EditViewController () <PECropViewControllerDelegate>
{
    
}

@property (nonatomic, retain) GenReflectImage* genImage;
@end

@implementation EditViewController
@synthesize orgImage;

- (void) updatePreviewImage
{
    UIImage* reflectImage = [self.genImage reflectLastImage];
    [previewImageView setImage: reflectImage];
}

- (void) fillToolbarMain
{
    [toolbarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray* arrayTools = @[@"menu_style_2d.png", @"menu_style_3d.png", @"menu_scale.png", @"menu_filter.png", @"menu_crop.png"];
    
    CGFloat buttonW = 70;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        buttonW = 150;
    }
    
    for (NSInteger i = 0; i < [arrayTools count]; i ++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed: [arrayTools objectAtIndex: i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i*buttonW, 5, buttonW, 40)];
        [button setTag: i];
        [button addTarget:self action:@selector(selectToolbar:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarView addSubview: button];
    }
    
    [toolbarView setContentSize: CGSizeMake([arrayTools count]*buttonW, 50)];
}

- (void) fillToolbar2D
{
    [toolbarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray* arrayTools = @[@"back_menu.png",
                            @"ui_style_leftright.png",
                            @"ui_style_rightleft.png",
                            @"ui_style_topbottom.png",
                            @"ui_style_bottomtop.png",
                            @"ui_g4_1.png",
                            @"ui_g4_2.png",
                            @"ui_style_g4_5.png",
                            @"ui_style_g4_6.png"];
    
    for (NSInteger i = 0; i < [arrayTools count]; i ++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed: [arrayTools objectAtIndex: i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i*80, 5, 40, 40)];
        [button setTag: i];
        [button addTarget:self action:@selector(selectToolbar2D:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarView addSubview: button];
    }
    
    [toolbarView setContentSize: CGSizeMake([arrayTools count]*80, 50)];
}

- (void) fillToolbar3D
{
    [toolbarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray* arrayTools = @[@"back_menu.png",
                            @"style_heartleftright_t.png",
                            @"style_heartrightleft_t.png",
                            @"style_butterflyleftright.png",
                            @"style_butterflyrightleft.png",
                            @"style_footleftright.png",
                            @"style_footrightleft.png",
                            @"style_heartleftright.png",
                            @"style_heartrightleft.png",
                            @"style_fourscreen1.png",
                            @"style_fourscreen2.png",
                            @"style_fourscreen3.png",
                            @"style_fourscreen4.png"];
    
    for (NSInteger i = 0; i < [arrayTools count]; i ++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed: [arrayTools objectAtIndex: i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i*80, 5, 40, 40)];
        [button setTag: i];
        [button addTarget:self action:@selector(selectToolbar3D:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarView addSubview: button];
    }
    
    [toolbarView setContentSize: CGSizeMake([arrayTools count]*80, 50)];
}

- (void) fillToolbarScale
{
    [toolbarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray* arrayTools = @[@"back_menu.png",
                            @"s1_1.png",
                            @"s2_3.png",
                            @"s3_2.png",
                            @"s3_4.png",
                            @"s4_3.png",
                            @"s3_5.png",
                            @"s5_3.png",
                            @"s5_7.png",
                            @"s7_5.png",
                            @"s9_16.png",
                            @"s16_9.png"];
    
    for (NSInteger i = 0; i < [arrayTools count]; i ++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed: [arrayTools objectAtIndex: i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i*80, 0, 50, 50)];
        [button setTag: i];
        [button addTarget:self action:@selector(selectToolbarScale:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarView addSubview: button];
    }
    
    [toolbarView setContentSize: CGSizeMake([arrayTools count]*80, 50)];
}

- (void) fillToolbarFilter
{
    [toolbarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray* arrayTools = @[@"back_menu.png",
                            @"1.png",
                            @"2.png",
                            @"3.png",
                            @"4.png",
                            @"5.png",
                            @"6.png",
                            @"7.png",
                            @"8.png",
                            @"9.png",
                            @"10.png",
                            @"11.png",
                            @"12.png",
                            @"13.png",
                            @"14.png"];
    
    for (NSInteger i = 0; i < [arrayTools count]; i ++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed: [arrayTools objectAtIndex: i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i*60, 5, 40, 40)];
        [button setTag: i];
        [button addTarget:self action:@selector(selectFilter:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarView addSubview: button];
    }
    
    [toolbarView setContentSize: CGSizeMake([arrayTools count]*60, 50)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fillToolbarMain];
    
    self.genImage = [[GenReflectImage alloc] initWithImage: self.orgImage];
    
    [self.genImage setReflectType: k2DType_1];
    [previewImageView setImage: [self.genImage reflectImage:0 offsetY:0]];
    prevTouchPos.x = -1;
    prevTouchPos.y = -1;
}

- (void) selectToolbar2D:(id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger nTag = button.tag;
    if (nTag == 0)
    {
        [self fillToolbarMain];
        return;
    }
    
    [self.genImage setReflectType: (nTag-1)];
    [previewImageView setImage: [self.genImage reflectImage:0 offsetY:0]];

//    previewImageView.transform = CGAffineTransformIdentity;
}

- (void) selectToolbar3D:(id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger nTag = button.tag;
    if (nTag == 0)
    {
        [self fillToolbarMain];
        return;
    }
    
    [self.genImage setReflectType: k2DTypeCount+nTag];
    [previewImageView setImage: [self.genImage reflectImage:0 offsetY:0]];
    
    if (nTag <= 2)
    {
//        previewImageView.transform = CGAffineTransformIdentity;
//        previewImageView.transform = CGAffineTransformMakeRotation(-M_PI/10.0f);
    }
    else
    {
//        previewImageView.transform = CGAffineTransformIdentity;
    }
}

- (void) selectToolbarScale:(id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger nTag = button.tag;
    if (nTag == 0)
    {
        [self fillToolbarMain];
        return;
    }

    float ratioValues[] = {1,
        2/3.0f,
        3/2.0f,
        3/4.0f,
        4/3.0f,
        3/5.0f,
        5/3.0f,
        5/7.0f,
        7/5.0f,
        9/16.0f,
        16/9.0f
    };

    [self.genImage setRatio:ratioValues[nTag-1]];
    [previewImageView setImage: [self.genImage reflectLastImage]];

    float width = CGRectGetWidth(self.view.frame);
    float height = CGRectGetHeight(self.view.frame) - 50*3-10*2;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        height = CGRectGetHeight(self.view.frame) - 50*2-100-10*2;
    }
    
    float ratioValue = ratioValues[nTag-1];
    if (ratioValue < 1)
    {
        width = height*ratioValue;
    }
    else
    {
        height = width/ratioValue;
    }

    [previewImageView setFrame: CGRectMake(0, 0, width, height)];
    
    width = CGRectGetWidth(self.view.frame);
    height = CGRectGetHeight(self.view.frame) - 50-10;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        height = CGRectGetHeight(self.view.frame) - 100;
    }
    
    [previewImageView setCenter: CGPointMake(width/2, height/2.0f)];
}

- (void) selectToolbar:(id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger nTag = button.tag;
    
    switch (nTag) {
        case k2D:
            [self fillToolbar2D];
            break;
        case k3D:
            [self fillToolbar3D];
            break;
        case kScale:
            [self fillToolbarScale];
            break;
        case kFilter:
            [self fillToolbarFilter];
            break;
        case kCrop:
        {
            PECropViewController *vc = (PECropViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PECropViewController"];
            vc.delegate = self;
            vc.image = self.orgImage;
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void) selectFilter:(id) sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger nTag = button.tag;
    
    if (nTag == 0)
    {
        [self fillToolbarMain];
        return;
    }
    
    NSArray* arrayFilters = @[@"Origin",
                              @"1Q84",
                              @"B&W",
                              @"BookStore",
                              @"City",
                              @"Country",
                              @"Film",
                              @"Forest",
                              @"Lake",
                              @"Lomo",
                              @"Moment",
                              @"NYC",
                              @"Stage",
                              @"Tea",
                              @"Toaster",
                              ];
    
    NSString* acvFileName = [arrayFilters objectAtIndex: nTag-1];
    GPUImageOutput<GPUImageInput> *filter = [[GPUImageToneCurveFilter alloc] initWithACV:acvFileName];
    UIImage* filteredImage = [filter imageByFilteringImage:self.genImage.backupImage];
    [self.genImage setImage: filteredImage];
    [self updatePreviewImage];
    filter = nil;
    
    
//    for (NSInteger i = 1; i < [arrayFilters count]; i ++)
//    {
//        NSString* acvFileName = [arrayFilters objectAtIndex: i];
//        GPUImageOutput<GPUImageInput> *filter = [[GPUImageToneCurveFilter alloc] initWithACV:acvFileName];
//        UIImage* filteredImage = [filter imageByFilteringImage:[UIImage imageNamed:@"a_bao.jpg"]];
//        [UIImagePNGRepresentation(filteredImage) writeToFile: [NSString stringWithFormat:@"/projects/%d.png", i] atomically: YES];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    prevTouchPos = [touch locationInView: self.view];
    
    touchRightDirection = (prevTouchPos.x > self.view.bounds.size.width/2)?YES:NO;
    touchTopDirection = (prevTouchPos.y > self.view.bounds.size.height/2)?YES:NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [touch locationInView: self.view];
    
    CGFloat offsetX = prevTouchPos.x - touchPos.x;
    CGFloat offsetY = prevTouchPos.y - touchPos.y;
    
    if (touchRightDirection)
        offsetX = -offsetX;
    if (!touchTopDirection)
        offsetY = -offsetY;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [previewImageView setImage: [self.genImage reflectImage:offsetX*1.5f offsetY:offsetY*1.5f]];
    });
    
    prevTouchPos = touchPos;
}

- (IBAction) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) shareAction:(id)sender
{
    ShareViewController *vc = (ShareViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    [vc setShareImage: [self.genImage reflectLastImage]];
    [self.navigationController pushViewController:vc animated: YES];
}

#pragma mark PECropViewControllerDelegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self.genImage setProcessImage:croppedImage];
    [previewImageView setImage:[self.genImage reflectLastImage]];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}


@end
