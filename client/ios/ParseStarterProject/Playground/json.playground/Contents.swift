//: Playground - noun: a place where people can play

import Cocoa
import Foundation

let options = NSJSONWritingOptions(rawValue: 0)
var array:[[String: String]] = [["text" : "text", "x": ""], ["text" : "text", "x": ""], ["text" : "text", "x": ""]]

let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
let string = NSString(data: data!, encoding: NSUTF8StringEncoding)