package progetto_LPO_2020.visitors.evaluation;

public class BoolValue extends PrimValue<Boolean> {

	public BoolValue(Boolean value) {
		super(value);
	}

	@Override
	public final boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!(obj instanceof BoolValue))
			return false;
		return value.equals(((BoolValue) obj).value);
	}
	
	@Override
	public final boolean lower(Object obj) { // aggiunta funzione lower per i booleani
		if(this.equals(obj))
			return false;
		if (!(obj instanceof BoolValue))
			throw new EvaluatorException("Expecting a boolean");
		if (((BoolValue) obj).toBool())return true;
		else return false;
	}

	@Override
	public boolean toBool() {
		return value;
	}

}
