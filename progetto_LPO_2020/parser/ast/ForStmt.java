package progetto_LPO_2020.parser.ast;

import static java.util.Objects.requireNonNull;

import progetto_LPO_2020.visitors.Visitor;

public class ForStmt implements Stmt {
	private final VarIdent id;
	private final Exp exp;
	private final Block stmts;
	
	public ForStmt(VarIdent id, Exp exp, Block stmts) {
		this.id = requireNonNull(id);
		this.exp = requireNonNull(exp);
		this.stmts = requireNonNull(stmts);
	}

	@Override
	public String toString() {
		return getClass().getSimpleName() + "(" + id + "," + exp + "," + stmts + ")";
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitForStmt(id, exp, stmts);
	}
}
