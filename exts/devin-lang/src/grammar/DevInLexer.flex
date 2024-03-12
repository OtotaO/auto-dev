package cc.unitmesh.language;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;
import static cc.unitmesh.language.psi.DevInTypes.*;
import com.intellij.psi.TokenType;

%%

%{
  public _DevInLexer() {
    this((java.io.Reader)null);
  }
%}

%class DevInLexer
%class _DevInLexer
%implements FlexLexer
%unicode
%function advance
%type IElementType
%eof{  return;
%eof}

%s AGENT_BLOCK
%s VARIABLE_BLOCK
%s COMMAND_BLOCK

IDENTIFIER=[a-zA-Z0-9][_\-a-zA-Z0-9]*
VARIABLE_ID=[a-zA-Z0-9][_\-a-zA-Z0-9]*
AGENT_ID=[a-zA-Z0-9][_\-a-zA-Z0-9]*
COMMAND_ID=[a-zA-Z0-9][_\-a-zA-Z0-9]*
REF_BLOCK=([$/@] {IDENTIFIER} )
TEXT_SEGMENT=[^$/@\n]+
NEWLINE=\n|\r\n

%{
    private IElementType contextBlock() {
        yybegin(YYINITIAL);

        String text = yytext().toString();

        return TEXT_SEGMENT;
    }
%}

%%
<YYINITIAL> {
  "@"                  { yybegin(AGENT_BLOCK); return AGENT_START; }
  "/"                  { yybegin(COMMAND_BLOCK); return COMMAND_START; }
  "$"                  { yybegin(VARIABLE_BLOCK); return VARIABLE_START; }

  {TEXT_SEGMENT}       { return TEXT_SEGMENT; }
  {NEWLINE}            { return NEWLINE; }
  [^]                  { return TokenType.BAD_CHARACTER; }
}

<AGENT_BLOCK> {
  {IDENTIFIER}         { yybegin(YYINITIAL); return AGENT_ID; }
  [^]                  { return TokenType.BAD_CHARACTER; }
}

<COMMAND_BLOCK> {
  {COMMAND_ID}         { yybegin(YYINITIAL); return COMMAND_ID; }
  [^]                  { return TokenType.BAD_CHARACTER; }
}

<VARIABLE_BLOCK> {
  {VARIABLE_ID}        { yybegin(YYINITIAL); return VARIABLE_ID; }
  [^]                  { return TokenType.BAD_CHARACTER; }
}
