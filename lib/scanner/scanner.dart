import 'package:rapier/ast/ast.dart';
import 'package:string_scanner/string_scanner.dart';
import 'package:source_span/source_span.dart';
import 'token.dart';
export 'token.dart';

class Scanner {
  final List<BonoboError> errors = [];
  final List<Token> tokens = [];
  final SpanScanner scanner;
  LineScannerState errorStart;
  ScannerState state = ScannerState.normal;
  FileSpan _emptySpan;

  static final RegExp whitespace = new RegExp(r'\s+');

  Scanner(String string, {sourceUrl})
      : scanner = new SpanScanner(string, sourceUrl: sourceUrl) {
    _emptySpan = scanner.emptySpan;
  }

  FileSpan get emptySpan => _emptySpan;

  void flush() {
    if (errorStart != null) {
      var span = scanner.spanFrom(errorStart);
      var message = 'Unexpected text "${span.text}".';

      if (span.text.trim() == ';')
        message = 'Semi-colons are illegal in Bonobo!';

      errors.add(new BonoboError(
        BonoboErrorSeverity.warning,
        message,
        span,
      ));
      errorStart = null;
    }
  }

  void scan() {
    while (!scanner.isDone) {
      switch (state) {
        case ScannerState.normal:
          state = scanNormalToken();
          break;
        case ScannerState.multiLineComment:
          state = scanMultiLineComment();
          break;
      }
    }

    flush();
  }

  ScannerState scanNormalToken() {
    var tokens = <Token>[];

    if (scanner.matches('/*')) return ScannerState.multiLineComment;
    if (scanner.scan(whitespace) && scanner.isDone) return ScannerState.normal;
    if (scanner.matches('/*')) return ScannerState.multiLineComment;

    normalPatterns.forEach((pattern, type) {
      if (scanner.matches(pattern)) {
        if (type == TokenType.comment)
          tokens.add(new SingleLineComment(scanner.lastSpan));
        else
          tokens.add(new Token(type, scanner.lastSpan, scanner.lastMatch));
      }
    });

    if (tokens.isEmpty) {
      errorStart ??= scanner.state;
      scanner.readChar();
    } else {
      flush();
      tokens.sort((a, b) => b.span.length.compareTo(a.span.length));
      this.tokens.add(tokens.first);
      scanner.scan(tokens.first.span.text);
    }

    return ScannerState.normal;
  }

  ScannerState scanMultiLineComment() {
    if (!scanner.matches('/*')) return ScannerState.normal;
    tokens.add(_scanMultilineComment());
    return ScannerState.normal;
  }

  MultiLineComment _scanMultilineComment() {
    scanner.scan('/*');
    var span = scanner.lastSpan;
    var members = <MultiLineCommentMember>[];
    LineScannerState textStart;

    void flush() {
      if (textStart != null) {
        members.add(new MultiLineCommentText(scanner.spanFrom(textStart)));
        textStart = errorStart = null;
      }
    }

    while (!scanner.isDone) {
      if (scanner.matches('*/')) {
        flush();
        scanner.scan('*/');
        break;
      } else if (scanner.matches('/*')) {
        flush();
        members.add(new NestedMultiLineComment(_scanMultilineComment()));
      } else {
        textStart ??= scanner.state;
        scanner.readChar();
      }
    }

    flush();
    return new MultiLineComment(members, span);
  }
}

enum ScannerState { normal, multiLineComment }

class BonoboError implements Exception {
  final BonoboErrorSeverity severity;
  final String message;
  final FileSpan span;

  BonoboError(this.severity, this.message, this.span);

  @override
  String toString() {
    if (span == null) return message;
    return '${span.start.toolString}: $message';
  }
}

String severityToString(BonoboErrorSeverity severity) {
  switch (severity) {
    case BonoboErrorSeverity.warning:
      return 'warning';
    case BonoboErrorSeverity.error:
      return 'error';
    case BonoboErrorSeverity.information:
      return 'info';
    case BonoboErrorSeverity.hint:
      return 'hint';
    default:
      throw new ArgumentError();
  }
}

enum BonoboErrorSeverity { warning, error, information, hint }