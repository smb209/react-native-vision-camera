//
//  ExamplePluginSwift.swift
//  VisionCamera
//
//  Created by Marc Rousavy on 30.04.21.
//  Copyright © 2021 mrousavy. All rights reserved.
//

import AVKit
import Vision

@objc(ExamplePluginSwift)
public class ExamplePluginSwift: NSObject, FrameProcessorPluginBase {
  
  public static var frameCount = 0;
  public static var armDumpFrame = true;
    @objc
    public static func callback(_ frame: Frame!, withArgs args: [Any]!) -> Any! {
      
        if (args[0] is Bool) {
          // ...
        } else {
          return {
            ["error": "Invalid argument",
            "status": "First argument must be boolean"]
          }
        }
        
      let reqDumpFrame: Bool = args[0] as! Bool
      
      var returnFrame = false
      if self.armDumpFrame && reqDumpFrame {
        returnFrame = true;
      }
      
      if (!reqDumpFrame) {
        self.armDumpFrame = true;
      }
      
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(frame.buffer) else {
            return nil
        }
      self.frameCount = self.frameCount + 1;
//        NSLog("ExamplePluginSwift: \(CVPixelBufferGetWidth(imageBuffer)) x \(CVPixelBufferGetHeight(imageBuffer)) Video Frame")

      var depthFormat: UInt32 = 0
      var minValue: Float32 = 0.0
      var maxValue: Float32  = 0.0
      var bString: String = ""
      var width: Int = -1
      var height: Int = -1
      var bufSize: Int = -1
      var bytesPerRow: Int = -1
        if let depth = frame.depth {
          CVPixelBufferLockBaseAddress(depth, CVPixelBufferLockFlags.readOnly)
          
          width = CVPixelBufferGetWidth(depth)
          height = CVPixelBufferGetHeight(depth)
          let nPlanes = CVPixelBufferGetPlaneCount(depth)
          bufSize = CVPixelBufferGetDataSize(depth)
          
          bytesPerRow = CVPixelBufferGetBytesPerRow(depth); //2560 == (640 * 4)
          
//          NSLog("ExamplePluginSwift: \(CVPixelBufferGetWidth(depth)) x \(CVPixelBufferGetHeight(depth)) Depth Frame")
          depthFormat = CVPixelBufferGetPixelFormatType(depth)
          
          
          if let baseAddress = CVPixelBufferGetBaseAddress(depth) {
            let buf = baseAddress.assumingMemoryBound(to: Float32.self)
            let numBufElems = Int(bufSize / MemoryLayout<Float32>.size)
            let bufPtr = UnsafeBufferPointer(start: buf, count: numBufElems).lazy.map{ $0.isNaN ? 0 : $0 }
            minValue = bufPtr.min() ?? Float32(0)
            maxValue = bufPtr.max() ?? Float32(0)
            NSLog("ExamplePluginSwift: Depth Min: \(minValue), Max: \(maxValue)")
            
            let d = Data(bytesNoCopy: buf, count: bufSize, deallocator: .none)
            bString = d.base64EncodedString()
          } else {
            NSLog("ExamplePluginSwift: Depth baseAddress is nil")
              // `baseAddress` is `nil`
          }
          
          CVPixelBufferUnlockBaseAddress(depth, CVPixelBufferLockFlags.readOnly)
        }

        return [
            "maxValue": maxValue,
            "frameCount": self.frameCount,
            "x": width,
            "y": height,
            "bytesPerRow": bytesPerRow,
            "bufSize": bufSize,
            "b64": returnFrame ? bString : "",
//            "example_bool": true,
//            "example_double": 5.3,
//            "example_array": [
//                "Hello",
//                true,
//                17.38,
//            ],
        ]
    }
}
