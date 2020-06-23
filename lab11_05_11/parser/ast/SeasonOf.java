package lab11_05_11.parser.ast; // creato in data 21/06

import lab11_05_11.visitors.Visitor;

public class SeasonOf extends UnaryOp {
	
	public SeasonOf(Exp exp) {
		super(exp);
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitSeasonOf(exp); //aggiungere alla classe visitors
	}
}