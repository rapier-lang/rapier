import 'package:rapier/scanner/scanner.dart';
import 'package:source_span/source_span.dart';
import 'visitor.dart';

abstract class AstNode {
  final FileSpan span;
  final List<Comment> comments;

  AstNode(this.span, this.comments);

  T accept<T>(RapierVisitor<T> visitor);
}

abstract class Comment extends Token {
  Comment(FileSpan span, Match match) : super(TokenType.comment, span, match);

  String get text;

  @override
  String toString() => text;
}

class SingleLineComment extends Comment {
  SingleLineComment(FileSpan span) : super(span, null);

  @override
  String get text => MultiLineComment.stripStars(span.text.substring(2)).trim();
}

class MultiLineComment extends Comment {
  final List<MultiLineCommentMember> members;

  static final RegExp _star = new RegExp(r'^\*');

  MultiLineComment(this.members, FileSpan span) : super(span, null);

  static String stripStars(String s) {
    var lines = s.split('\n').where((s) => s.isNotEmpty);
    return lines.map((s) => s.trim().replaceAll(_star, '').trim()).join('\n');
  }

  @override
  String get text {
    return members.map((m) => m.text.trim()).join('\n').trim();
  }
}

abstract class MultiLineCommentMember {
  FileSpan get span;

  String get text;
}

class MultiLineCommentText extends MultiLineCommentMember {
  final FileSpan span;

  MultiLineCommentText(this.span);

  @override
  String get text => MultiLineComment.stripStars(span.text);
}

class NestedMultiLineComment extends MultiLineCommentMember {
  final MultiLineComment comment;

  NestedMultiLineComment(this.comment);

  @override
  FileSpan get span => comment.span;

  @override
  String get text => comment.text;
}
