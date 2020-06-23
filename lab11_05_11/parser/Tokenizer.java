package lab11_05_11.parser;

import java.io.IOException;

public interface Tokenizer extends AutoCloseable {

	TokenType next() throws TokenizerException;

	TokenType tokenType();

	String tokenString();

	int intValue();

	boolean boolValue();
	
	int seasonValue(); // aggiunto 21/06

	public void close() throws IOException;

	int getLineNumber();

}