package lab11_05_11.parser.ast; // creato in data 21/06

import lab11_05_11.visitors.Visitor;

public class SeasonLiteral extends PrimLiteral<String> {

	public SeasonLiteral(String n) {
		super(n);
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitSeasonLiteral(value); //aggiungere alla classe visitors
	}
}