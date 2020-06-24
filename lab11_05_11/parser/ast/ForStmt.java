package lab11_05_11.parser.ast;

import static java.util.Objects.requireNonNull;

import lab11_05_11.visitors.Visitor;

public class ForStmt implements Stmt { // modificato in data 23/06
	private final VarIdent id;
	private final Exp exp;
	private final Block stmts;
	
	public ForStmt(VarIdent id, Exp exp, Block stmts) {
		this.id = requireNonNull(id);
		this.exp = requireNonNull(exp);
		this.stmts = stmts;
	}

	public ForStmt(VarIdent id, Exp exp) {
		this(id, exp, null);
	}

	@Override
	public String toString() {
		return getClass().getSimpleName() + "(" + id + "," + exp + "," + stmts + ")";
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitForStmt(id, exp, stmts); //aggiungere alla classe visitors
	}
}
