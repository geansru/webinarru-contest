//
//  Exception.swift
//  Webinar.ru-contest
//
//  Created by Dmitriy Roytman on 01.11.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

typealias JobClosure = () throws->()
typealias JobClosureWithReturnedValue = () throws->AnyObject?
typealias errorHandlerCLosure = (error: NSError)->()
class Exception {
    class func performThrowable(job: JobClosure, errorHandler: errorHandlerCLosure) {
        do {
            try job()
        } catch let error as NSError {
            errorHandler(error: error)
        }
    }
    class func performThrowable(job: JobClosure ) {
        do {
            try job()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    class func performThrowableWithReturnValue(job: JobClosureWithReturnedValue, errorHandler: errorHandlerCLosure ) -> AnyObject? {
        do {
            let value: AnyObject? = try job()
            return value
        } catch let error as NSError {
            errorHandler(error: error)
        }
        return nil
    }
    class func performThrowableWithReturnValue(job: JobClosureWithReturnedValue ) -> AnyObject? {
        do {
            let value: AnyObject? = try job()
            return value
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}