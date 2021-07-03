` ranker implements the popular TF-IDF (term frequency, inverse document
frequency) ranking model. Ranking functions are referenced internally by the
searcher and are not meant to be exposed outside of the library, though it can
be used outside of the library if desired -- the interface is probably stable. `

std := load('../vendor/std')
quicksort := load('../vendor/quicksort')

map := std.map
reduce := std.reduce
sortBy := quicksort.sortBy

docTermFrequency := (doc, token) => doc.tokens.(token)
docInverseFrequency := (doc, token) => ln(doc.tokens.(token) / len(doc.tokens))
docTFIDF := (doc, token) => docTermFrequency(doc, token) * docInverseFrequency(doc, token)

rankDocs := (matchingDocs, queryTokens) => sortBy(matchingDocs, doc => (
	` ranking score is the sum of TF-IDF for all terms `
	tokenScores := map(queryTokens, token => docTFIDF(doc, token))
	~reduce(tokenScores, (a, b) => a + b, 0)
))

