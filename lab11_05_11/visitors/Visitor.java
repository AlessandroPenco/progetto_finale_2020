package lab11_05_11.visitors;

import lab11_05_11.parser.ast.Block;
import lab11_05_11.parser.ast.Exp;
import lab11_05_11.parser.ast.Stmt;
import lab11_05_11.parser.ast.StmtSeq;
import lab11_05_11.parser.ast.VarIdent;

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
	
	T visitLower(Exp left, Exp right); // aggiunto in data 23/06 // da aggiungere per int e season e in pair value
	
	T visitNumOf(Exp exp); // aggiunto in data 23/06
	
	T visitSeasonLiteral(int value); // aggiunto in data 23/06
	
	T visitSeasonOf(Exp exp); // aggiunto in data 23/06
}
