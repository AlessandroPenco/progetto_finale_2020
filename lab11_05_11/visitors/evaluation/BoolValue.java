package lab11_05_11.visitors.evaluation;

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
	
	public boolean lower(Object obj) {
		if(this.equals(obj))
			return false;
		if (!(obj instanceof BoolValue))
			return false;
		if (obj.equals(true))return true;
		else return false;
	}

	@Override
	public boolean toBool() {
		return value;
	}

}
