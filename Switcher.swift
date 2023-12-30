import Carbon

func requireEnv(_ name: String, message: String) -> String {
    let value = ProcessInfo.processInfo.environment[name]

    if value == nil || value == "" {
        print("FATAL: The environment variable \(name) is not set!\n\(message)")
        exit(1)
    }
    return value!
}

let NON_LATIN_ID = requireEnv("FCITX_NON_LATIN_ID", message: "This variable must be set to the ID of your non-Latin input method.")
let LATIN_ID = requireEnv("FCITX_LATIN_ID", message: "This variable must be set to the ID of your Latin input method.")
let _ = requireEnv("DISPLAY", message: "fcitx.nvim only runs if this variable is set.")

let INTERMEDIATE_ID = ProcessInfo.processInfo.environment["FCITX_INTERMEDIATE_ID"]
let useIntermediateLayout = INTERMEDIATE_ID != nil && INTERMEDIATE_ID != ""

func getInputSourceId(_ input: TISInputSource) -> String? {
    guard let id = TISGetInputSourceProperty(input, kTISPropertyInputSourceID) else { return nil }
    return Unmanaged<AnyObject>.fromOpaque(id).takeUnretainedValue() as? String
}

func isEnabled(id: String) -> Bool {
    let keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
        return getInputSourceId(keyboard) == id
}

func isNonLatinEnabled() -> Bool {
    return isEnabled(id: NON_LATIN_ID)
}

func isLatinEnabled() -> Bool {
    return isEnabled(id: LATIN_ID)
}

func enableLatin() {
    guard !isLatinEnabled() else { return }
    guard let source = findInputSource(id: LATIN_ID) else { return }
    TISSelectInputSource(source)
}

func enableNonLatin() {
    guard !isNonLatinEnabled() else { return }
    if useIntermediateLayout {
        guard let us = findInputSource(id: INTERMEDIATE_ID!) else { return }
        TISSelectInputSource(us)
    }
    guard let source = findInputSource(id: NON_LATIN_ID) else { return }
    // Switch to US first to ensure QWERTY layout
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
