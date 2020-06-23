package lab11_05_11.parser.ast;

import lab11_05_11.visitors.Visitor;

public class Lower extends BinaryOp {
	public Lower(Exp left, Exp right) {
		super(left, right);
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitLower(left, right); //aggiungere alla classe visitors
	}
}
