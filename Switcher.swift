import Carbon
import Cocoa
import InputMethodKit

var en: TISInputSource?
var zh: TISInputSource?

func getInputSourceId(_ input: TISInputSource) -> String? {
    guard let id = TISGetInputSourceProperty(input, kTISPropertyInputSourceID) else { return nil }
    return Unmanaged<AnyObject>.fromOpaque(id).takeUnretainedValue() as? String
}

let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
let inputSourceList = inputSourceNSArray as! [TISInputSource]

for input in inputSourceList {
    guard let id = TISGetInputSourceProperty(input, kTISPropertyInputSourceID) else { break }
    let unwrapped = Unmanaged<AnyObject>.fromOpaque(id).takeUnretainedValue() as! String
    switch unwrapped {
    case "org.unknown.keylayout.CustomDvorak":
        en = input
    case "com.sogou.inputmethod.sogouWB.wubi":
        zh = input
    default:
        continue
    }
}

guard let zh = zh, let en = en else { exit(1) }

let keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()

if keyboard == zh {
    TISSelectInputSource(en)
} else {
    TISSelectInputSource(zh)
}
