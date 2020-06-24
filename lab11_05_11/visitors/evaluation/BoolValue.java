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
	
	@Override
	public final boolean lower(Object obj) { // 23/06
		if(this.equals(obj))
			return false;
		if (!(obj instanceof BoolValue))
			return false;
		if (((BoolValue) obj).value)return true;
		else return false;
	}

	@Override
	public boolean toBool() {
		return value;
	}

}
