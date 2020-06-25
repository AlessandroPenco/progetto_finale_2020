package progetto_LPO_2020.parser.ast;

import progetto_LPO_2020.visitors.Visitor;

public class NumOf extends UnaryOp {
	
	public NumOf(Exp exp) {
		super(exp);
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitNumOf(exp); //aggiungere alla classe visitors
	}
}
