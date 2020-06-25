package progetto_LPO_2020.parser.ast; // creato in data 21/06

import progetto_LPO_2020.visitors.Visitor;

public class SeasonOf extends UnaryOp {
	
	public SeasonOf(Exp exp) {
		super(exp);
	}

	@Override
	public <T> T accept(Visitor<T> visitor) {
		return visitor.visitSeasonOf(exp); //aggiungere alla classe visitors
	}
}
