package progetto_LPO_2020.parser;

import java.io.IOException;

public interface Tokenizer extends AutoCloseable {

	TokenType next() throws TokenizerException;

	TokenType tokenType();

	String tokenString();

	int intValue();

	boolean boolValue();
	
	String seasonValue(); // aggiunta funzione per ritornare il valore del token di tipo season, presente in BufferedTokenizer

	public void close() throws IOException;

	int getLineNumber();

}