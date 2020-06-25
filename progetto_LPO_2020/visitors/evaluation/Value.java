package progetto_LPO_2020.visitors.evaluation;

public interface Value {
	/* default conversion methods */
	default int toInt() {
		throw new EvaluatorException("Expecting an integer");
	}
	
	default int toIntS() {
		throw new EvaluatorException("Expecting a season");
	}

	default boolean toBool() {
		throw new EvaluatorException("Expecting a boolean");
	}

	default PairValue toProd() {
		throw new EvaluatorException("Expecting a pair");
	}

	default String toSeason() { // 24/06
		throw new EvaluatorException("Expecting an integer");
	}
	
	boolean lower(Object obj); // 23/06
}
