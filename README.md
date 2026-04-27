# README

Search uses PostgreSQL's pg_trgm extension with word similarity scoring. Queries under 5 characters use substring matching (ILIKE). Longer queries use fuzzy matching with a 0.4 similarity threshold, which handles most typos but may miss transpositions in short words.