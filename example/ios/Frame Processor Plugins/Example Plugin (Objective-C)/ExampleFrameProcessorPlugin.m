//
//  ExampleFrameProcessorPlugin.m
//  VisionCameraExample
//
//  Created by Marc Rousavy on 01.05.21.
//

#import <Foundation/Foundation.h>
#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/Frame.h>

// Example for an Objective-C Frame Processor plugin

@interface ExampleFrameProcessorPlugin : NSObject
@end

@implementation ExampleFrameProcessorPlugin

static inline id example_plugin(Frame* frame, NSArray* arguments) {
  CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(frame.buffer);
//  NSLog(@"ExamplePlugin: %zu x %zu Video Frame", CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer));
  
  if (frame.depth != nil) {
//    NSLog(@"ExamplePlugin: %zu x %zu Depth Frame", CVPixelBufferGetWidth(frame.depth), CVPixelBufferGetHeight(frame.depth));
  }
  
  NSLog(@"ExamplePlugin: Logging %lu parameters:", (unsigned long)arguments.count);
  
  for (id param in arguments) {
//    NSLog(@"ExamplePlugin:   -> %@ (%@)", param == nil ? @"(nil)" : [param description], NSStringFromClass([param classForCoder]));
  }
  return @{};
//  return @{
//    @"example_str": @"Test",
//    @"example_bool": @true,
//    @"example_double": @5.3,
//    @"example_array": @[
//      @"Hello",
//      @true,
//      @17.38
//    ]
//  };
}

VISION_EXPORT_FRAME_PROCESSOR(example_plugin)

@end
