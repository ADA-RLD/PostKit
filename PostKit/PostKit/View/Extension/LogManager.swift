//
//  LogManager.swift
//  PostKit
//
//  Created by Kim Andrew on 3/5/24.
//

import Foundation
import OSLog
internal func traceLog(_ description: Any,
           fileName: String = #file,
           lineNumber: Int = #line,
           functionName: String = #function) {

    let traceString = "\(fileName.components(separatedBy: "/").last!) -> \(functionName)(line: \(lineNumber)) -> \(description) "
    
    print(traceString)
}
