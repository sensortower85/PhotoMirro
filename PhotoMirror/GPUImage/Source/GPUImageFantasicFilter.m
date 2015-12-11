#import "GPUImageFantasicFilter.h"
#import "GPUImage.h"

@implementation GPUImageFantasicFilter
//@synthesize lookupFilter;

- (id)initWithFileName: (NSString*) textureFileName brightness: (float) brightness contrast: (float) contrast vignette: (float) vignette
{
    if (!(self = [super init]))
    {
		return nil;
    }

    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:textureFileName ofType:nil]];
    NSAssert(image, @"To use GPUImageAmatorkaFilter you need to add lookup_amatorka.png from GPUImage/framework/Resources to your application bundle.");
    
    lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageLookupFilter* lookupFilter = [[GPUImageLookupFilter alloc] init];

    [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
    [lookupImageSource processImage];
    
    GPUImageVignetteFilter *applyFilter  = [[GPUImageVignetteFilter alloc ] init];

    if (vignette == 0)
    {
        applyFilter.vignetteStart = 1;
        applyFilter.vignetteEnd = 1;
    }
    
    GPUImageBrightnessFilter * brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    brightnessFilter.brightness = brightness;
    
    GPUImageContrastFilter * contrastFilter    = [[GPUImageContrastFilter alloc ] init];
    contrastFilter.contrast = contrast;
    
    [self addFilter: lookupFilter];
    [self addFilter:applyFilter];
    [self addFilter:brightnessFilter];
    [self addFilter:contrastFilter];
    
    [lookupFilter addTarget:applyFilter];
    [applyFilter addTarget: brightnessFilter];
    [brightnessFilter addTarget:contrastFilter];
    
    [self setInitialFilters : [ NSArray arrayWithObject:lookupFilter] ] ;
    [self setTerminalFilter : contrastFilter ] ;
    
    return self;
}

//- (GPUImageLookupFilter*) getLookupFilter
//{
//    return lookupFilter;
//}

//- (void) dealloc
//{
//    [lookupFilter release];
//    [super dealloc];
//}


@end
