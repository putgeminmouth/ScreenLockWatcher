import AppKit
import Foundation
import ArgumentParser

var verbose = false

func printlnerr(_ s: String) {
    FileHandle.standardError.write(Data(s.utf8))
    FileHandle.standardError.write(Data("\n".utf8))
}
func printlndbg(_ s: String) {
    if (!verbose) {
        return
    }
    
    FileHandle.standardError.write(Data(s.utf8))
    FileHandle.standardError.write(Data("\n".utf8))
}

enum ExecMode: String, EnumerableFlag, Codable {
    case Open, Execute
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var mode: ExecMode = ExecMode.Open
    var lockFile: String?
    var unlockFile: String?

    func exec(_ filePath: String) {
        let p = Process()
        
        switch mode {
        case ExecMode.Open:
            p.executableURL = URL(fileURLWithPath: "/usr/bin/open")
            p.arguments = [filePath]
        case ExecMode.Execute:
            p.executableURL = URL(fileURLWithPath: filePath)
        }
        
        let stdout = Pipe()
        stdout.fileHandleForReading.readabilityHandler = { handler in
            let data = handler.availableData
            FileHandle.standardOutput.write(data)
        }
        p.standardOutput = stdout
        
        let stderr = Pipe()
        stderr.fileHandleForReading.readabilityHandler = { handler in
            let data = handler.availableData
            FileHandle.standardError.write(data)
        }
        p.standardError = stderr
        
        do {
            try p.run()
            p.waitUntilExit()
        } catch {
            printlnerr("\(error)")
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let dnc = DistributedNotificationCenter.default()

        dnc.addObserver(forName: .init("com.apple.screenIsLocked"),
                                       object: nil, queue: .main) { _ in
            printlndbg("Screen Locked")
            if let file = self.lockFile {
                self.exec(file)
            }
        }

        dnc.addObserver(forName: .init("com.apple.screenIsUnlocked"),
                                         object: nil, queue: .main) { _ in
            printlndbg("Screen Unlocked")
            if let lockFile = self.lockFile {
                self.exec(lockFile)
            }
        }
    }

}

struct Args: ParsableArguments {
    @Option(name: [.customLong("lock-file")], help: "File to run when the screen is locked")
    var lockFile: String?
    @Option(name: [.customLong("unlock-file")], help: "File to run when the screen is unlocked")
    var unlockFile: String?
    
    @Flag(help: "'Open' uses /usr/bin/open to achieve similar effect as double-clicking it in Finder. Otherwise, the file must be executable.")
    var mode: ExecMode
    
    @Flag(name: [.customShort("v"), .customLong("verbose")])
    var verbose: Bool = false
}

let args = Args.parseOrExit()
verbose = args.verbose

printlndbg("lockFile: " + (args.lockFile ?? ""))
printlndbg("unlockFile: " + (args.unlockFile ?? ""))

printlndbg("Main Begin")

let delegate = AppDelegate()
delegate.lockFile = args.lockFile
delegate.unlockFile = args.unlockFile
delegate.mode = args.mode

let app = NSApplication.shared
app.delegate = delegate
app.run()

printlndbg("Main End")
