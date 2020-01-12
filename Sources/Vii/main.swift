import ConsoleKit
import ViiLibrary
import NIO

let console = Terminal()
let commands = CommandInput(arguments: CommandLine.arguments)
let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

do {
    try console.run(ViiCommand(eventLoopGroup: group), input: commands)
    do {
        try group.syncShutdownGracefully()
    }
} catch let error as CommandError {
    let term = Terminal()
    term.error("error:")
    term.output(error.description.consoleText())
} catch {
    let term = Terminal()
    term.error("error:")
    term.output("\(error)".consoleText())
}
