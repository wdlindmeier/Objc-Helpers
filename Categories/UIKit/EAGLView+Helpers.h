void releaseScreenshotData(void *info, const void *data, size_t size) {
    free((void *)data);
};
 
@implementation EAGLView (Helpers)

- (UIImage *)renderedAsImage;

@end
