package progetto_LPO_2020.parser.ast;

import static java.util.Objects.requireNonNull;

import progetto_LPO_2020.visitors.Visitor;

public class ProgAST implements Prog {
	private final StmtSeq stmtSeq;

	public ProgAST(StmtSeq stmtSeq) {
		this.stmtSeq = requireNonNull(stmtSeq);
	}

	@Override
	public String toString() {
		return getClass().getSimpleName() + "(" + stmtSeq + ")";
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitProg(stmtSeq);
	}

}
