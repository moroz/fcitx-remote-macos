import Carbon
import Cocoa
import InputMethodKit

let keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()

let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
let inputSourceList = inputSourceNSArray as! [TISInputSource]

var en: TISInputSource?
var zh: TISInputSource?

func getInputSourceId(_ input: TISInputSource) -> String? {
    guard let id = TISGetInputSourceProperty(input, kTISPropertyInputSourceID) else { return nil }
    return Unmanaged<AnyObject>.fromOpaque(id).takeUnretainedValue() as? String
}

print(keyboard)

for input in inputSourceList {
    guard let id = TISGetInputSourceProperty(input, kTISPropertyInputSourceID) else { break }
    let unwrapped = Unmanaged<AnyObject>.fromOpaque(id).takeUnretainedValue()
    switch unwrapped as! String {
    case "org.unknown.keylayout.CustomDvorak":
        // TISSelectInputSource(input)
        en = input
    case "com.sogou.inputmethod.sogouWB.wubi":
        zh = input
    default:
        continue
    }
}

let zhId = getInputSourceId(zh!)
let enId = getInputSourceId(en!)

if getInputSourceId(keyboard) == zhId {
    TISSelectInputSource(en)
} else {
    TISSelectInputSource(zh)
}
