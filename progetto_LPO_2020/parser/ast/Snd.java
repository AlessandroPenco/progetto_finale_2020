package progetto_LPO_2020.parser.ast;

import progetto_LPO_2020.visitors.Visitor;

public class Snd extends UnaryOp {

	public Snd(Exp exp) {
		super(exp);
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitSnd(exp);
	}
}
