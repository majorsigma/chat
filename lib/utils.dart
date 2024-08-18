import 'package:flutter/material.dart';
import 'package:gchat/extensions.dart';
import 'package:logger/logger.dart';

class GChatUtils {
  static Logger getLogger(String className) {
    final logger = Logger(printer: SimpleLogPrinter(className));
    return logger;
  }

  static void showSnackbar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.fixed,
          content: Text(
            message,
            style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      );
  }
}

/// A printer for logging events with emojis and colored text.
///
/// It extends the [LogPrinter] to provide a custom format for logged messages,
/// which includes an emoji based on the log level, and coloring the output
/// depending on the log level as well.
class SimpleLogPrinter extends LogPrinter {
  /// The name of the class where the log is being called.
  final String className;

  /// Constructor that takes the [className] where the log is being called.
  SimpleLogPrinter(this.className);

  /// Logs the given [event] with formatted output.
  ///
  /// The function uses ANSI escape codes for terminal colors and prepends
  /// an appropriate emoji to the message based on the log level.
  /// The format is `emoji :::: <className> :::: message`.
  ///
  /// Returns an empty list as it outputs directly to the console.
  @override
  List<String> log(LogEvent event) {
    // Mapping of log levels to ANSI color codes.
    final levelColors = {
      Level.trace: 37, // Gray color for trace log level.
      Level.debug: 36, // Cyan color for debug log level.
      Level.info: 32, // Green color for info log level.
      Level.warning: 33, // Yellow color for warning log level.
      Level.error: 45, // Red color for error log level.
      Level.fatal: 35, // Magenta color for fatal log level.
    };

    // Mapping of log levels to emojis.
    final levelEmojis = {
      Level.trace: '🔍', // Magnifying glass emoji for verbose.
      Level.debug: '🛠️', // Hammer and wrench emoji for debug.
      Level.info: 'ℹ️', // Information source emoji for info.
      Level.warning: '⚠️', // Warning emoji for warning.
      Level.error: '❌', // Cross mark emoji for error.
      Level.fatal: '🤷', // Shrugging person emoji for wtf.
    };

    // Get the emoji for the current log level, defaulting to empty if not found.
    final emoji = levelEmojis[event.level] ?? '';
    // Get the color code for the current log level, defaulting to no color if not found.
    final color = levelColors[event.level] ?? 0;
    // Format the message with the color code and class name.
    final coloredMessage =
        '\x1B[38;5;${color}m :::: <$className> :::: ${event.message}\x1B[0m';

    // Print the formatted message to the console.
    print('$emoji $coloredMessage');

    // Return an empty list as the function is meant for printing to console.
    return [];
  }
}
