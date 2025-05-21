use crate::frontend::{
    lexer::{token::Token, LexError},
    sourceloc::SourceLoc,
};

#[derive(Clone, PartialEq, Eq)]
pub enum ParseError {
    LexError(LexError),
    UnexpectedToken(UnexpectedTokenError),
    InvalidPathExpr(UnexpectedTokenError),
}

impl std::fmt::Display for ParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::LexError(lex_error) => write!(f, "{}", lex_error),
            Self::UnexpectedToken(unexpected_token) => {
                write!(
                    f,
                    "Unexpected token '{}' at {}, expected one of [{}]",
                    unexpected_token.got,
                    unexpected_token.loc,
                    unexpected_token.expected_str()
                )
            }
            Self::InvalidPathExpr(invalid_path) => {
                write!(
                    f,
                    "Invalid token {} in path expression at {}, expected one of [{}]",
                    invalid_path.got,
                    invalid_path.loc,
                    invalid_path.expected_str()
                )
            }
        }
    }
}

impl std::fmt::Debug for ParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self)
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct UnexpectedTokenError {
    pub loc: SourceLoc,
    pub got: Token,
    pub expected: Vec<Token>,
}

impl UnexpectedTokenError {
    pub fn expected_str(&self) -> String {
        let mut expected_tokens = String::new();
        for tok in &self.expected {
            if expected_tokens.len() > 0 {
                expected_tokens += ", ";
            }

            expected_tokens += &format!("'{}'", tok.name());
        }
        expected_tokens
    }
}
impl ParseError {
    pub fn unexpected_token(loc: SourceLoc, got: Token, expected: &[Token]) -> Self {
        Self::UnexpectedToken(UnexpectedTokenError {
            loc,
            got,
            expected: expected.to_vec(),
        })
    }

    pub fn invalid_path(loc: SourceLoc, got: Token, expected: &[Token]) -> Self {
        Self::InvalidPathExpr(UnexpectedTokenError {
            loc,
            got,
            expected: expected.to_vec(),
        })
    }
}

impl From<LexError> for ParseError {
    fn from(value: LexError) -> Self {
        Self::LexError(value)
    }
}
