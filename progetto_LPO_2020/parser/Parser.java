package progetto_LPO_2020.parser;

import progetto_LPO_2020.parser.ast.Prog;

public interface Parser extends AutoCloseable {

	Prog parseProg() throws ParserException;

}