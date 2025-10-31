#!/usr/bin/env python3

"""
Convert an input string to a specific case style.

Supported targets:
- camelCase
- PascalCase
- snake_case
- SCREAMING_SNAKE_CASE  (aka "screaming" or CONST_CASE)

Examples:
  python case_convert.py "hello world" --case camel        -> helloWorld
  python case_convert.py "hello world" --case pascal       -> HelloWorld
  python case_convert.py "hello world" --case snake        -> hello_world
  python case_convert.py "hello world" --case screaming    -> HELLO_WORLD

  python case_convert.py "myHTTPServer2App" --case camel   -> myHttpServer2App
  python case_convert.py "API response code 404" --case snake -> api_response_code_404
"""

import argparse
import re
import sys
from typing import List


def split_words(s: str) -> List[str]:
    """
    Split a string into word tokens:
      - breaks on _, -, ., whitespace
      - splits camelCase/PascalCase
      - preserves all-caps runs (e.g., HTTP, ID)
      - extracts numeric runs (e.g., 404)
    """
    if s is None:
        return []

    # Normalize obvious separators to spaces and trim
    s = re.sub(r'[_\-\.\s]+', ' ', s.strip())

    tokens: List[str] = []
    # Keep only alphanumerics for tokenization, then split case boundaries
    for chunk in re.findall(r'[A-Za-z0-9]+', s):
        # Regex pieces:
        # - [A-Z]+(?=[A-Z][a-z]) : all-caps sequence before a Cap-lower (HTTP in HTTPServer)
        # - [A-Z]?[a-z]+         : normal words (server, Http)
        # - [A-Z]+               : trailing/standalone caps (ID)
        # - \d+                  : numbers (404)
        tokens += re.findall(
            r'[A-Z]+(?=[A-Z][a-z])|[A-Z]?[a-z]+|[A-Z]+|\d+',
            chunk
        )
    return tokens


def to_camel(words: List[str]) -> str:
    if not words:
        return ''
    first = words[0].lower()
    rest = [w if w.isdigit() else w.capitalize() for w in words[1:]]
    return first + ''.join(rest)


def to_pascal(words: List[str]) -> str:
    return ''.join(w if w.isdigit() else w.capitalize() for w in words)


def to_snake(words: List[str]) -> str:
    return '_'.join(w.lower() for w in words)


def to_screaming(words: List[str]) -> str:
    return '_'.join(w.upper() for w in words)


def convert_case(text: str, case: str) -> str:
    words = split_words(text)
    if case == 'camel':
        return to_camel(words)
    if case == 'pascal':
        return to_pascal(words)
    if case == 'snake':
        return to_snake(words)
    if case == 'screaming':
        return to_screaming(words)
    # Should never reach here
    raise RuntimeError("Unexpected case target.")


def main():
    parser = argparse.ArgumentParser(
        description="Convert a string to camelCase, PascalCase, snake_case, or SCREAMING_SNAKE_CASE."
    )
    parser.add_argument(
        "text",
        help="The input string to convert. Quote it if it contains spaces."
    )
    parser.add_argument(
        "-c", "--case",
        required=False,
        default="camel",
        choices=["camel","pascal","snake", "screaming" ],
    )
    args = parser.parse_args()

    try:
        result = convert_case(args.text, args.case)
    except ValueError as e:
        print(str(e), file=sys.stderr)
        sys.exit(2)

    print(result)


if __name__ == "__main__":
    main()