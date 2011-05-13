void releaseScreenshotData(void *info, const void *data, size_t size) {
    free((void *)data);
};
 
@implementation EAGLView (Helpers)

- (UIImage *)renderedAsImage 
{
    int backingWidth = self.bounds.size.width;
    int backingHeight = self.bounds.size.height;
    
    NSInteger myDataLength = backingWidth * backingHeight * 4;
    
    // allocate array and read pixels into it.
    GLuint *buffer = (GLuint *) malloc(myDataLength);
    glReadPixels(0, 0, backingWidth, backingHeight, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders “upside down” so swap top to bottom into new array.
    for(int y = 0; y < backingHeight / 2; y++) {
        for(int x = 0; x < backingWidth; x++) {
            //Swap top and bottom bytes
            GLuint top = buffer[y * backingWidth + x];
            GLuint bottom = buffer[(backingHeight - 1 - y) * backingWidth + x];
            buffer[(backingHeight - 1 - y) * backingWidth + x] = top;
            buffer[y * backingWidth + x] = bottom;
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, releaseScreenshotData);
    
    // prep the ingredients
    const int bitsPerComponent = 8;
    const int bitsPerPixel = 4 * bitsPerComponent;
    const int bytesPerRow = 4 * backingWidth;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;

    CGImageRef imageRef = CGImageCreate(320, 480, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    // then make the UIImage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return myImage;
}
@end