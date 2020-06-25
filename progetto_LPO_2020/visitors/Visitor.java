package progetto_LPO_2020.visitors;

import progetto_LPO_2020.parser.ast.Block;
import progetto_LPO_2020.parser.ast.Exp;
import progetto_LPO_2020.parser.ast.Stmt;
import progetto_LPO_2020.parser.ast.StmtSeq;
import progetto_LPO_2020.parser.ast.VarIdent;

public interface Visitor<T> {
	T visitAdd(Exp left, Exp right);

	T visitAssignStmt(VarIdent ident, Exp exp);

	T visitIntLiteral(int value);

	T visitEq(Exp left, Exp right);

	T visitMoreStmt(Stmt first, StmtSeq rest);

	T visitMul(Exp left, Exp right);

	T visitPrintStmt(Exp exp);

	T visitProg(StmtSeq stmtSeq);

	T visitSign(Exp exp);

	T visitVarIdent(VarIdent id); // the only corner case ...

	T visitSingleStmt(Stmt stmt);

	T visitVarStmt(VarIdent ident, Exp exp);

	T visitNot(Exp exp);

	T visitAnd(Exp left, Exp right);

	T visitBoolLiteral(boolean value);

	T visitIfStmt(Exp exp, Block thenBlock, Block elseBlock);

	T visitBlock(StmtSeq stmtSeq);

	T visitPairLit(Exp left, Exp right);

	T visitFst(Exp exp);

	T visitSnd(Exp exp);
	
	T visitForStmt(VarIdent id, Exp exp, Block stmts); // aggiunto  e modificato in data 23/06
	
	T visitLower(Exp left, Exp right); // aggiunto in data 23/06
	
	T visitNumOf(Exp exp); // aggiunto in data 23/06
	
	T visitSeasonLiteral(String value); // aggiunto in data 23/06
	
	T visitSeasonOf(Exp exp); // aggiunto in data 23/06
}
