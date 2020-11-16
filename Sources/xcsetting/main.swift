import Foundation
import ArgumentParser

struct XCSetting: ParsableCommand {
    @Option(name: .shortAndLong, help: "The xcode project, including the xcodeproj extension")
    var project: String?

    @Option(name: .shortAndLong, help: "The xcode workspace, including the xcworkspace extension")
    var workspace: String?

    @Option(name: .shortAndLong, help: "The xcode scheme")
    var scheme: String?

    @Argument(help: "The setting to find the value for")
    var setting: String

    mutating func run() throws {

        let commandLineArguments = generateCommandLine()
        guard commandLineArguments.count > 0 else {
            print("Unable to generate xcodebuild command line, exiting")
            return
        }

        guard let resultData = xcrun(commandLineArguments),
              let resultDataString = String(data: resultData, encoding: .utf8) else {
            print("Error running xcodebuild to generate settings")
            return
        }

        for line in resultDataString.split(separator: "\n") {
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespaces)
            if trimmedLine.hasPrefix(setting) {
                let parts = trimmedLine.split(separator: "=")
                if parts.count > 0 {
                    print(parts[1].trimmingCharacters(in: CharacterSet.whitespaces))
                }
            }
        }
    }

    private func generateCommandLine() -> [String] {
        guard project != nil || workspace != nil else {
            return []
        }

        var arguments: [String] = []
        arguments.append("xcodebuild")
        if let project = project {
            arguments.append("-project")
            arguments.append(project)
        } else if let workspace = workspace {
            arguments.append("-workspace")
            arguments.append(workspace)
        }
        if let scheme = scheme {
            arguments.append("-scheme")
            arguments.append(scheme)
        }
        arguments.append("-showBuildSettings")

        return arguments
    }

    @discardableResult
    private func xcrun(_ arguments: [String]) -> Data? {
        autoreleasepool {
            let task = Process()
            task.launchPath = "/usr/bin/xcrun"
            task.arguments = arguments

            var resultData: Data?
            let pipe = Pipe()
            task.standardOutput = pipe
            task.launch()

            resultData = pipe.fileHandleForReading.readDataToEndOfFile()
            task.waitUntilExit()
            return resultData
        }
    }
}

XCSetting.main()
