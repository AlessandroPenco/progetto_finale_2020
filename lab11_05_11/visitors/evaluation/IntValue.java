package lab11_05_11.visitors.evaluation;

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
	public final boolean lower(Object obj) { // 24/06
		if(this.equals(obj))
			return false;
		if (!(obj instanceof IntValue))
			return false;
		if (this.toInt() < ((IntValue) obj).toInt())return true;
		else return false;
	}

	@Override
	public int toInt() {
		return value;
	}
	
	@Override
	public String toSeason() {
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
			throw new IndexOutOfBoundsException();
		}
	}

}
