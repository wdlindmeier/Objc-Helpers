#import "EAGLView+Helpers.h"

void releaseScreenshotData(void *info, const void *data, size_t size) {
    free((void *)data);
};

@implementation EAGLView (Helpers)

- (UIImage *)renderedAsImage:(BOOL)allowTransparency
{
    int backingWidth = self.bounds.size.width;
    int pixelsWide = backingWidth * self.contentScaleFactor;
    int backingHeight = self.bounds.size.height;
    int pixelsHigh = backingHeight * self.contentScaleFactor;

    NSInteger myDataLength = pixelsWide * pixelsHigh * 4;

    // allocate array and read pixels into it.
    GLuint *buffer = (GLuint *) malloc(myDataLength);
    glReadPixels(0, 0, pixelsWide, pixelsHigh, GL_RGBA, GL_UNSIGNED_BYTE, buffer);

    // gl renders “upside down” so swap top to bottom into new array.
    for(int y = 0; y < pixelsHigh / 2; y++) {
        for(int x = 0; x < pixelsWide; x++) {
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
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    if(allowTransparency){
        bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
    }
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;

    CGImageRef imageRef = CGImageCreate(pixelsWide, pixelsHigh, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);

    // then make the UIImage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef scale:self.contentScaleFactor orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);

    return myImage;
}
@end