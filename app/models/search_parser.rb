require "parslet"

class SearchParser < Parslet::Parser
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:quoted) { str('"') >> (match("\\w") | space).repeat(1).as(:quoted) >> str('"') >> space? }
  rule(:tag) { str("tag:") >> match("[A-Za-z0-9\\-_+]").repeat(1).as(:tag) >> space? }
  rule(:domain) { str("domain:") >> match("[A-Za-z_\\-\\.]").repeat.as(:domain) >> space? }
  rule(:negated) { str("-") >> (domain | tag | quoted | term).as(:negated) >> space? }

  # 'term' is a catchall so it can consume ill-structured input, should be last in groups
  rule(:term) { match("\\S").repeat(1).as(:term) >> space? }

  rule(:expression) { space.maybe >> (domain | tag | quoted | negated | term).repeat(1) }
  root(:expression)
end
