//
// SwiftyTimer
//
// Copyright (c) 2015 Radosław Pietruszewski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

private class NSTimerActor {
    var block: () -> ()
    
    init(_ block: () -> ()) {
        self.block = block
    }
    
    dynamic func fire() {
        block()
    }
}

extension NSTimer {
    // NOTE: `new` class functions are a workaround for a crashing bug when using convenience initializers (18720947)
    
    /// Create a timer that will call `block` once after the specified time.
    ///
    /// **Note:** the timer won't fire until it's scheduled on the run loop.
    /// Use `NSTimer.after` to create and schedule a timer in one step.
    
    public class func new(after interval: NSTimeInterval, _ block: () -> ()) -> NSTimer {
        let actor = NSTimerActor(block)
        return self.init(timeInterval: interval, target: actor, selector: "fire", userInfo: nil, repeats: false)
    }
    
    /// Create a timer that will call `block` repeatedly in specified time intervals.
    ///
    /// **Note:** the timer won't fire until it's scheduled on the run loop.
    /// Use `NSTimer.every` to create and schedule a timer in one step.
    
    public class func new(every interval: NSTimeInterval, _ block: () -> ()) -> NSTimer {
        let actor = NSTimerActor(block)
        return self.init(timeInterval: interval, target: actor, selector: "fire", userInfo: nil, repeats: true)
    }
    
    /// Create and schedule a timer that will call `block` once after the specified time.
    
    public class func after(interval: NSTimeInterval, _ block: () -> ()) -> NSTimer {
        let timer = NSTimer.new(after: interval, block)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        return timer
    }
    
    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    
    public class func every(interval: NSTimeInterval, _ block: () -> ()) -> NSTimer {
        let timer = NSTimer.new(every: interval, block)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        return timer
    }
}

extension Int {
    public var second:  NSTimeInterval { return NSTimeInterval(self) }
    public var seconds: NSTimeInterval { return NSTimeInterval(self) }
    public var minute:  NSTimeInterval { return NSTimeInterval(self * 60) }
    public var minutes: NSTimeInterval { return NSTimeInterval(self * 60) }
    public var hour:    NSTimeInterval { return NSTimeInterval(self * 3600) }
    public var hours:   NSTimeInterval { return NSTimeInterval(self * 3600) }
}

extension Double {
    public var second:  NSTimeInterval { return self }
    public var seconds: NSTimeInterval { return self }
    public var minute:  NSTimeInterval { return self * 60 }
    public var minutes: NSTimeInterval { return self * 60 }
    public var hour:    NSTimeInterval { return self * 3600 }
    public var hours:   NSTimeInterval { return self * 3600 }
}
