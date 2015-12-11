#import "GPUImageFilterGroup.h"
#import "GPUImagePicture.h"
#import "GPUImageLookupFilter.h"

@class GPUImagePicture;

/** A photo filter based on Photoshop action by Amatorka
    http://amatorka.deviantart.com/art/Amatorka-Action-2-121069631
 */

// Note: If you want to use this effect you have to add lookup_amatorka.png
//       from Resources folder to your application bundle.

@interface GPUImageFantasicFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
//    GPUImageLookupFilter *lookupFilter;
}

//@property (nonatomic, retain) GPUImageLookupFilter *lookupFilter;

- (id)initWithFileName: (NSString*) textureFileName brightness: (float) brightness contrast: (float) contrast vignette: (float) vignette;
@end
