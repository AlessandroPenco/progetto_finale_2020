package progetto_LPO_2020;

import static java.lang.System.err;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import progetto_LPO_2020.parser.BufferedParser;
import progetto_LPO_2020.parser.BufferedTokenizer;
import progetto_LPO_2020.parser.ParserException;
import progetto_LPO_2020.parser.ast.Prog;
import progetto_LPO_2020.visitors.evaluation.Eval;
import progetto_LPO_2020.visitors.evaluation.EvaluatorException;
import progetto_LPO_2020.visitors.typechecking.TypeCheck;
import progetto_LPO_2020.visitors.typechecking.TypecheckerException;

public class Main {
	// instance variables for managing options
	public static final String INPUT_OPT = "-i";
	public static final String OUTPUT_OPT = "-o";
	public static final String NO_TYPE_CHECK = "-ntc";
	public static boolean type_check = true;

	// add here more options with string arguments, if needed
	// maps options to their string values, initially null
	public static final Map<String, String> options = new HashMap<>();
	static {
		options.put(INPUT_OPT, null);
		options.put(OUTPUT_OPT, null);
	}

	// manage generic option errors
	private static void optionError() {
		System.err.println("Option error.\nValid options:\n\t-i <input>\n\t-o <output>\n\t-ntc");
		System.exit(1);
	}

	// processes a single option at position 'i' plus its possible argument
	private static int processArg(String[] args, int i) {
		var opt = args[i];
		if (opt.equals(NO_TYPE_CHECK))
			type_check = false;
		else {
			if (!options.containsKey(opt) || i + 1 == args.length)
				optionError();
			options.put(opt, args[++i]);
		}
		return i;
	}

	// processes all options and their arguments
	private static void processArgs(String[] args) {
		for (var i = 0; i < args.length; i++)
			i = processArg(args, i);
	}

	// end of utility methods for option processing

	// opens the input stream, standard input if -i option is null
	private static BufferedReader tryOpenInput(String inputPath) throws FileNotFoundException {
		return new BufferedReader(inputPath == null ? new InputStreamReader(System.in) : new FileReader(inputPath));
	}

	// opens the output stream, standard output if -o option is null
	private static PrintWriter tryOpenOutput(String outputPath) throws FileNotFoundException {
		return outputPath == null ? new PrintWriter(System.out) : new PrintWriter(outputPath);
	}

	public static void main(String[] args) {
		processArgs(args);
		try (var rd = tryOpenInput(options.get(INPUT_OPT));
				var tokenizer = new BufferedTokenizer(rd);
				var parser = new BufferedParser(tokenizer);
				var pw = tryOpenOutput(options.get(OUTPUT_OPT));) {
			Prog prog = parser.parseProg();
			if (type_check)
				prog.accept(new TypeCheck());
			prog.accept(new Eval(pw));
		} catch (IOException e) {
			err.println("I/O error: " + e.getMessage());
		} catch (ParserException e) {
			err.println("Syntax error: " + e.getMessage());
		} catch (TypecheckerException e) {
			err.println("Static error: " + e.getMessage());
		} catch (EvaluatorException e) {
			err.println("Dynamic error: " + e.getMessage());
		} catch (Throwable e) {
			err.println("Unexpected error.");
			e.printStackTrace();
		}
	}

}
