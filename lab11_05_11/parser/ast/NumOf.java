package lab11_05_11.parser.ast;

import lab11_05_11.visitors.Visitor;

public class NumOf extends UnaryOp {
	
	public NumOf(Exp exp) {
		super(exp);
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitNumOf(exp); //aggiungere alla classe visitors
	}
}
