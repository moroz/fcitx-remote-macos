import Carbon

let ZH_ID = "com.sogou.inputmethod.sogouWB.wubi"
let EN_ID = "org.unknown.keylayout.CustomDvorak"

func getInputSourceId(_ input: TISInputSource) -> String? {
  guard let id = TISGetInputSourceProperty(input, kTISPropertyInputSourceID) else { return nil }
  return Unmanaged<AnyObject>.fromOpaque(id).takeUnretainedValue() as? String
}

func isEnabled(id: String) -> Bool {
  let keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
  return getInputSourceId(keyboard) == id
}

func isNonLatinEnabled() -> Bool {
  return isEnabled(id: ZH_ID)
}

func isLatinEnabled() -> Bool {
  return isEnabled(id: EN_ID)
}

func enableLatin() {
  guard !isLatinEnabled() else { return }
  guard let source = findInputSource(id: EN_ID) else { return }
  TISSelectInputSource(source)
}

func enableNonLatin() {
  guard !isNonLatinEnabled() else { return }
  guard let source = findInputSource(id: ZH_ID) else { return }
  TISSelectInputSource(source)
}

func findInputSource(id needleId: String) -> TISInputSource? {
  let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
  let inputSourceList = inputSourceNSArray as! [TISInputSource]

  for input in inputSourceList {
    if let id = getInputSourceId(input), id == needleId {
      return input
    }
  }
  return nil
}

func toggleInput() {
  if isNonLatinEnabled() {
    enableLatin()
  } else {
    enableNonLatin()
  }
}

if CommandLine.argc == 1 {
  if isNonLatinEnabled() {
    print("2")
  } else {
    print("1")
  }
  exit(0)
}

switch CommandLine.arguments[1] {
case "-c":
  enableLatin()
case "-o", "-e":
  enableNonLatin()
default:
  break
}
