//
//  AgentCommunicator.swift
//  MenuBarTest
//
//  Created by Joseph Tennant on 1/16/19.
//  Copyright © 2019 7SIGNAL. All rights reserved.
//

import Foundation

class AgentCommunicator {
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    func sendMessage(_ message: String) {
        let data = "\(message)\n".data(using: .utf8)!
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
    func setupNetworkCommunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "127.0.0.1" as CFString,
                                           11208,
                                           &readStream,
                                           &writeStream)
        
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream.schedule(in: .current, forMode: .common)
        self.outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
}
