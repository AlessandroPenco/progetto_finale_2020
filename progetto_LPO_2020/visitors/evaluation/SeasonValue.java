package progetto_LPO_2020.visitors.evaluation;

public class SeasonValue extends PrimValue<String> {

	public SeasonValue(String value) {
		super(value);
	}

	@Override
	public final boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!(obj instanceof SeasonValue))
			return false;
		return value.equals(((SeasonValue) obj).value);
	}
	
	@Override
	public final boolean lower(Object obj) { // aggiunta funzione lower per il tipo season
		if(this.equals(obj))
			return false;
		if (!(obj instanceof SeasonValue))
			throw new EvaluatorException("Expecting a season");
		if (this.toIntS() < ((SeasonValue) obj).toIntS())return true;
		else return false;
	}

	public int toIntS() { // aggiunta funzione toIntS per l'operatore '#'
		switch (value) {
		case "Winter":
			return 0;
		case "Spring":
			return 1;
		case "Summer":
			return 2;
		case "Fall":
			return 3;
		default:
			throw new EvaluatorException();
		}
	}

}
