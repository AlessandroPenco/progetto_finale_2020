package progetto_LPO_2020.visitors.evaluation;

public class IntValue extends PrimValue<Integer> {

	public IntValue(Integer value) {
		super(value);
	}

	@Override
	public final boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!(obj instanceof IntValue))
			return false;
		return value.equals(((IntValue) obj).value);
	}
	
	@Override
	public final boolean lower(Object obj) { // aggiunta funzione lower per gli interi
		if(this.equals(obj))
			return false;
		if (!(obj instanceof IntValue))
			throw new EvaluatorException("Expecting an integer");
		if (this.toInt() < ((IntValue) obj).toInt())return true;
		else return false;
	}

	@Override
	public int toInt() {
		return value;
	}
	
	@Override
	public String toSeason() { // aggiunta funzione toSeason per l'operatore 'seasonof'
		switch (value) {
		case 0:
			return "Winter";
		case 1:
			return "Spring";
		case 2:
			return "Summer";
		case 3:
			return "Fall";
		default:
			throw new EvaluatorException(new IndexOutOfBoundsException("Index " + value +" out of bounds for length 4"));
		}
	}

}
