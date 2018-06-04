import 'expression.dart';

abstract class RapierVisitor<T> {
  T visitParenthesizedExpression(ParenthesizedExpressionContext ctx);

  T visitNamespacedIdentifier(
      NamespacedIdentifierContext namespacedIdentifierContext);

  T visitNumberLiteral(NumberLiteralContext numberLiteralContext);

  T visitStringLiteral(StringLiteralContext stringLiteralContext);

  T visitBinaryExpression(BinaryExpressionContext binaryExpressionContext);

  T visitPrefixExpression(PrefixExpressionContext prefixExpressionContext);

  T visitPostfixExpression(PostfixExpressionContext postfixExpressionContext);

  T visitConditionalExpression(
      ConditionalExpressionContext conditionalExpressionContext);

  T visitCallExpression(CallExpressionContext callExpressionContext);

  T visitMemberExpression(MemberExpressionContext memberExpressionContext);

  T visitObjectLiteral(ObjectLiteralContext objectLiteralContext);

  T visitRangeLiteral(RangeLiteralContext rangeLiteralContext);

  T visitSimpleIdentifier(SimpleIdentifierContext simpleIdentifierContext);
}
