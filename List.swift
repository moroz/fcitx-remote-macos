import Carbon

let ZH_ID = "com.sogou.inputmethod.sogouWB.wubi"

func getInputSourceId(_ input: TISInputSource) -> String? {
  guard let id = TISGetInputSourceProperty(input, kTISPropertyInputSourceID) else { return nil }
  return Unmanaged<AnyObject>.fromOpaque(id).takeUnretainedValue() as? String
}

let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
let inputSourceList = inputSourceNSArray as! [TISInputSource]

for input in inputSourceList {
  print(input)
  print(getInputSourceId(input)!)
}


