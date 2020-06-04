package lab11_05_11.parser;

import lab11_05_11.parser.ast.Prog;

public interface Parser extends AutoCloseable {

	Prog parseProg() throws ParserException;

}