/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header for renderer class which performs Metal setup and per frame rendering
*/

@import MetalKit;

#import "FlickerModel.h"


@class FlickerRenderer_texture;
@protocol Delegate_FlickerRenderer_texture

- (void)unexpectedFrameTimingOccuredIn:(FlickerRenderer_texture *_Nonnull)renderer;
//- (void)processStimulusWithIndexFrame:(NSUInteger)indexFrame at:(NSTimeInterval)time;
- (void)flickerRenderedShowed:(NSInteger)frameIndex at:(NSTimeInterval)time;
@end



// Our platform independent renderer class
@interface FlickerRenderer_texture : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;
- (NSUInteger)maxNBuffersInFlight;

@property (nonatomic) NSObject<Delegate_FlickerRenderer_texture> * _Nullable delegate;
@property (nonatomic) NSUInteger nFlickeringRectangles;
@property (nonatomic) NSArray * _Nullable texturesPerRectangle; // for each control contains an array with elements of type id<MTLTexture>
@property (nonatomic) CGRect * _Nullable frames; // todo: rename, this is confusing; here frames are placements of images on the screen, while it can also mean the frames that are displayed (e.g. at 120Hz)
//@property (nonatomic) NSArray *eventsData; // count nImages; contains an NSData for each frame
@property (nonatomic) NSArray * _Nullable eventDataForUtopiaPerFrame; // when a frame has actually been displayed, we want to let Utopia know; we store this here so we use the correct data even if there are changes in the set of used noise tag elements in the time between planning to a) show a frame and b) communicating that this frame actually has been shown.
@property (nonatomic) BOOL isOn;


@end
