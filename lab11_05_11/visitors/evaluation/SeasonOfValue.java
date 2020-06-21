package lab11_05_11.visitors.evaluation;

import lab11_05_11.parser.ast.Exp;

// aggiunta in 07/06/2020
public class SeasonOfValue extends PrimValue<Integer> {
	
	
	public SeasonOfValue(Exp exp) {
		super(exp);
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
	public int toInt() {
		return value;
	}
	
}
