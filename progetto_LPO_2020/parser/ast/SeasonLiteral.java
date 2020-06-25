package progetto_LPO_2020.parser.ast; // creato in data 21/06

import progetto_LPO_2020.visitors.Visitor;

public class SeasonLiteral extends PrimLiteral<String> {

	public SeasonLiteral(String n) {
		super(n);
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitSeasonLiteral(value); //aggiungere alla classe visitors
	}
}