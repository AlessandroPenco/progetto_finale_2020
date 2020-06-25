package progetto_LPO_2020.parser.ast;

import progetto_LPO_2020.visitors.Visitor;

public interface AST {
	<T> T accept(Visitor<T> visitor);
}
