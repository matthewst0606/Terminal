pub enum TokenType {
    Identifier,
    Pipe,
    RedirectOut,
    RedirectIn,
    Semicolon,
    Eof,

}
pub struct Token {
    pub token_type: TokenType, 
    pub lexeme: String
}

pub struct Lexer {
    source: Vec<char>,
    current: usize,
    start: usize,
    tokens: Vec<Token>,
}

impl Lexer {

    pub(crate) fn new(source: &str) -> Self {
        Self { 
            source: source.chars().collect(), 
            current: 0, 
            start: 0, 
            tokens: Vec::new() 
        }
    }


    pub fn scan_tokens(mut self) -> Vec<Token> {
        while !self.is_at_end() {
            self.start = self.current;
            self.scan_token();   
        }

        self.tokens.push(Token {
            token_type: TokenType::Eof,
            lexeme: String::new(),
        });

        self.tokens
    }


    pub fn tokenize_input(command: &str) -> Vec<String> {
        let tokens = Lexer::new(command).scan_tokens();
        let mut words = Vec::new();

        for token in tokens {
            match token.token_type {
                TokenType::Identifier => words.push(token.lexeme),
                TokenType::Pipe => {},
                TokenType::RedirectIn => {},
                TokenType::RedirectOut => {}
                TokenType::Semicolon => {},
                TokenType::Eof => break,
            }
        }

        words
    }


    fn scan_token(&mut self) {
        match self.next_char() {
            ' ' | '\t' | '\n' | '\r' => (),
            '|' => 
                self.add_token(TokenType::Pipe),
            '>' => 
                self.add_token(TokenType::RedirectOut),
            '<' => 
                self.add_token(TokenType::RedirectIn),
            ';' => 
                self.add_token(TokenType::Semicolon),
            _ => {
                self.identifier();
                self.add_token(TokenType::Identifier);
            },
        }
    }

    fn next_char(&mut self) -> char {
        let character = self.source[self.current];
        self.current += 1;

        character
    }

    fn is_at_end(&mut self) -> bool {
        self.current >= self.source.len()
    }

    fn add_token(&mut self, token_type: TokenType) {
        let lexeme = self.source[self.start..self.current]
            .iter()
            .collect();
        
        self.tokens.push(Token { 
            token_type, 
            lexeme, 
        });
    }

    fn identifier(&mut self) {
        while !self.is_at_end() {
            let lexeme = self.source[self.current];    
            
            if matches!(lexeme, ' ' | '\t' | '\n' | '\r' | '|' | '>' | '<' | ';') 
                { break; }      

            self.next_char();
        }

    }


    
}
