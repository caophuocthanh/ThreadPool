//
//  ThreadPool.swift
//  ThreadPool
//
//  Created by Cao Phuoc Thanh on 3/29/21.
//

import Foundation

public class ThreadPool: Foundation.Thread {
    
    private var runLoop: RunLoop?
    private var mainBlock: (() -> Void)?
    
    public convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    public override func main() {
        runLoop = RunLoop.current
        guard let runLoop = runLoop else { return }
        
        mainBlock?()
        mainBlock = nil
        
        while !isCancelled {
            autoreleasepool { runLoop.run() }
        }
        
        CFRunLoopStop(runLoop.getCFRunLoop())
    }
    
    public func perform(_ block: @escaping () -> Void) {
        if runLoop == nil {
            let semaphore = DispatchSemaphore(value: 0)
            mainBlock = { semaphore.signal() }
            start()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
        precondition(runLoop != nil, "Cannot add operation to thread before it is started")
        CFRunLoopPerformBlock(runLoop!.getCFRunLoop(), CFRunLoopMode.commonModes.rawValue, block)
        CFRunLoopWakeUp(runLoop!.getCFRunLoop())
    }
}
